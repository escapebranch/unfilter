package com.escapebranch.unfilter

import android.content.Intent
import android.os.Handler
import android.os.Looper
import android.provider.Settings
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.Executors
import java.util.concurrent.locks.ReentrantLock
import kotlin.concurrent.withLock

class MainActivity : FlutterActivity() {
private val CHANNEL = "com.escapebranch.unfilter/apps"
private val EVENT_CHANNEL = "com.escapebranch.unfilter/scan_progress"
    
    companion object {
        private const val TAG = "MainActivity"
    }
    
    private val executor = Executors.newFixedThreadPool(4) 
    private val handler = Handler(Looper.getMainLooper())
    private var eventSink: EventChannel.EventSink? = null
    
    private val scanLock = ReentrantLock()
    @Volatile private var scanInProgress = false
    @Volatile private var lastScanResult: List<Map<String, Any?>>? = null
    @Volatile private var lastScanIncludedDetails = false
    
    // Chunked transfer support to avoid Binder 1MB limit
    private val CHUNK_SIZE = 15  // 15 apps per chunk — well within Binder limit
    @Volatile private var pendingChunkedResult: List<Map<String, Any?>>? = null

    private lateinit var appRepository: AppRepository

    private lateinit var usageManager: UsageManager
    private lateinit var processManager: ProcessManager
    private lateinit var systemReader: SystemDetailReader
    private lateinit var storageAnalyzer: StorageAnalyzer
    private lateinit var batteryAnalyzer: BatteryAnalyzer

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        appRepository = AppRepository(this)

        usageManager = UsageManager(this)
        processManager = ProcessManager()
        systemReader = SystemDetailReader(this)
        storageAnalyzer = StorageAnalyzer(this)
        batteryAnalyzer = BatteryAnalyzer(this)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getAppChunk" -> {
                    // Chunked transfer: Flutter pulls one chunk at a time
                    val chunkIndex = call.argument<Int>("chunkIndex") ?: 0
                    val data = pendingChunkedResult
                    if (data == null) {
                        result.error("NO_DATA", "No pending scan data for chunked transfer", null)
                        return@setMethodCallHandler
                    }
                    
                    val start = chunkIndex * CHUNK_SIZE
                    val end = minOf(start + CHUNK_SIZE, data.size)
                    
                    if (start >= data.size) {
                        // All chunks sent, clear the pending data
                        pendingChunkedResult = null
                        result.success(emptyList<Map<String, Any?>>())
                    } else {
                        try {
                            result.success(data.subList(start, end))
                        } catch (e: OutOfMemoryError) {
                            Log.e(TAG, "OOM sending chunk $chunkIndex, retrying with smaller batch")
                            System.gc()
                            try {
                                Thread.sleep(100)
                                // Retry with half the chunk
                                val halfEnd = minOf(start + CHUNK_SIZE / 2, data.size)
                                result.success(data.subList(start, halfEnd))
                            } catch (e2: Exception) {
                                result.error("OUT_OF_MEMORY", "Cannot transfer chunk $chunkIndex", null)
                            }
                        } catch (e: Exception) {
                            result.error("ERROR", "Chunk transfer failed: ${e.message}", null)
                        }
                    }
                }
                "getAppsDetails" -> {
                    val packageNames = call.argument<List<String>>("packageNames") ?: emptyList()
                    executor.execute {
                        try {
                            val details = appRepository.getAppsDetails(packageNames)
                            handler.post { 
                                try {
                                    result.success(details) 
                                } catch (e: Exception) {
                                    result.error("ERROR", e.message, null)
                                }
                            }
                        } catch (e: Exception) {
                            handler.post { result.error("ERROR", e.message, null) }
                        }
                    }
                }
                "clearScanCache" -> {
                    scanLock.withLock {
                        lastScanResult = null
                        lastScanIncludedDetails = false
                    }
                    result.success(true)
                }
                "getInstalledApps" -> {
                    val includeDetails = call.argument<Boolean>("includeDetails") ?: true
                    
                    executor.execute {
                        if (!includeDetails) {
                            try {
                                val apps = appRepository.getInstalledApps(
                                    includeDetails = false,
                                    onProgress = { _, _, _ -> },
                                    checkScanCancelled = { false }
                                )
                                handler.post { result.success(apps) }
                            } catch (e: Exception) {
                                handler.post { result.error("ERROR", e.message, null) }
                            }
                            return@execute
                        }
                        
                        scanLock.withLock {
                            val cachedResult = lastScanResult
                            if (cachedResult != null && lastScanIncludedDetails) {
                                handler.post { result.success(cachedResult) }
                                return@execute
                            }
                            
                            if (scanInProgress) {
                                var waited = 0
                                while (scanInProgress && waited < 120000) {
                                    try {
                                        Thread.sleep(100)
                                        waited += 100
                                    } catch (e: InterruptedException) {
                                        break
                                    }
                                }
                                val resultAfterWait = lastScanResult
                                if (resultAfterWait != null && lastScanIncludedDetails) {
                                    handler.post { result.success(resultAfterWait) }
                                    return@execute
                                }
                            }
                            
                            scanInProgress = true
                            lastScanResult = null
                        }
                        
                        try {
                            Log.d(TAG, "Starting full app scan with details")
                            handler.post { eventSink?.success(mapOf("status" to "Fetching app list...", "percent" to 0)) }

                            val apps = appRepository.getInstalledApps(
                                includeDetails = true,
                                onProgress = { current, total, appName ->
                                    handler.post {
                                        eventSink?.success(mapOf(
                                            "status" to "Scanning $appName", 
                                            "percent" to ((current.toDouble() / total) * 100).toInt(),
                                            "current" to current,
                                            "total" to total
                                        ))
                                    }
                                },
                                checkScanCancelled = { false }
                            )

                            scanLock.withLock {
                                lastScanResult = apps
                                lastScanIncludedDetails = true
                                scanInProgress = false
                            }
                            
                            Log.d(TAG, "Scan completed successfully: ${apps.size} apps")
                            
                            // Store for chunked transfer and respond with metadata only
                            pendingChunkedResult = apps
                            val totalChunks = (apps.size + CHUNK_SIZE - 1) / CHUNK_SIZE
                            
                            handler.post { 
                                try {
                                    eventSink?.success(mapOf("status" to "Complete", "percent" to 100))
                                    // Send metadata instead of the full payload
                                    result.success(mapOf(
                                        "chunked" to true,
                                        "totalApps" to apps.size,
                                        "totalChunks" to totalChunks,
                                        "chunkSize" to CHUNK_SIZE
                                    ))
                                } catch (e: Exception) {
                                    Log.e(TAG, "Exception returning scan metadata to Flutter: ${e.message}")
                                    // Fallback: try sending apps directly (smaller payloads might work)
                                    try {
                                        result.success(apps)
                                    } catch (e2: OutOfMemoryError) {
                                        val oomReport = generateOOMReport(e2)
                                        result.error(
                                            "OUT_OF_MEMORY", 
                                            oomReport,
                                            mapOf("errorReport" to oomReport, "errorType" to "OUT_OF_MEMORY")
                                        )
                                    }
                                }
                            }
                        } catch (e: com.escapebranch.unfilter.AppRepository.ScanFailureException) {
                            Log.e(TAG, "Scan failure with detailed report", e)
                            scanLock.withLock {
                                scanInProgress = false
                                lastScanResult = null
                            }
                            handler.post { 
                                result.error(
                                    "SCAN_FAILURE", 
                                    e.errorReport,
                                    mapOf(
                                        "errorReport" to e.errorReport,
                                        "errorType" to "SCAN_COMPLETE_FAILURE"
                                    )
                                ) 
                            }
                        } catch (e: OutOfMemoryError) {
                            Log.e(TAG, "OutOfMemoryError during scan", e)
                            scanLock.withLock {
                                scanInProgress = false
                                lastScanResult = null
                            }
                            val oomReport = generateOOMReport(e)
                            handler.post { 
                                result.error(
                                    "OUT_OF_MEMORY", 
                                    oomReport,
                                    mapOf(
                                        "errorReport" to oomReport,
                                        "errorType" to "OUT_OF_MEMORY"
                                    )
                                ) 
                            }
                        } catch (e: Exception) {
                            Log.e(TAG, "Error during scan: ${e.message}", e)
                            scanLock.withLock {
                                scanInProgress = false
                                lastScanResult = null
                            }
                            val genericReport = generateGenericErrorReport(e)
                            handler.post { 
                                result.error(
                                    "ERROR", 
                                    genericReport,
                                    mapOf(
                                        "errorReport" to genericReport,
                                        "errorType" to "GENERIC_ERROR"
                                    )
                                ) 
                            }
                        }
                    }
                }
                "getAppUsageHistory" -> {
                    val packageName = call.argument<String>("packageName")
                    val installTime = call.argument<Long>("installTime")
                    if (packageName != null) {
                        executor.execute {
                            try {
                                val history = usageManager.getAppUsageHistory(packageName, installTime)
                                handler.post { result.success(history) }
                            } catch (e: Exception) {
                                handler.post { result.error("ERROR", e.message, null) }
                            }
                        }
                    } else {
                        result.error("INVALID_ARGUMENT", "Package name is null", null)
                    }
                }
                "checkUsagePermission" -> {
                    result.success(usageManager.hasPermission())
                }
                "requestUsagePermission" -> {
                    startActivity(Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS))
                    result.success(true)
                }
                "checkInstallPermission" -> {
                   if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
                       result.success(packageManager.canRequestPackageInstalls())
                   } else {
                       result.success(true)
                   }
                }
                "requestInstallPermission" -> {
                    if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
                         startActivity(Intent(Settings.ACTION_MANAGE_UNKNOWN_APP_SOURCES).apply {
                            data = android.net.Uri.parse("package:$packageName")
                        })
                        result.success(true)
                    } else {
                        result.success(true)
                    }
                }
                "getRunningProcesses" -> {
                    executor.execute {
                        try {
                            val processes = processManager.getRunningProcesses()
                            handler.post { result.success(processes) }
                        } catch (e: Exception) {
                            handler.post { result.error("ERROR", e.message, null) }
                        }
                    }
                }
                "getRecentlyActiveApps" -> {
                    val hoursAgo = call.argument<Int>("hoursAgo") ?: 24
                    executor.execute {
                        try {
                            val apps = usageManager.getRecentlyActiveApps(hoursAgo)
                            handler.post { result.success(apps) }
                        } catch (e: Exception) {
                            handler.post { result.error("ERROR", e.message, null) }
                        }
                    }
                }
                "getSystemDetails" -> {
                     executor.execute {
                        try {
                            val memInfo = systemReader.getMemInfo()
                            val cpuTemp = systemReader.getCpuTemp()
                            val gpuUsage = systemReader.getGpuUsage()
                            val kernel = systemReader.getKernelVersion()
                            val cpuCores = systemReader.getCpuCoreCount()
                            
                            val response = mapOf(
                                "memInfo" to memInfo,
                                "cpuTemp" to cpuTemp,
                                "gpuUsage" to gpuUsage,
                                "kernel" to kernel,
                                "cpuCores" to cpuCores
                            )
                            handler.post { result.success(response) }
                        } catch (e: Exception) {
                            handler.post { result.error("ERROR", e.message, null) }
                        }
                     }
                 }
                "getStorageBreakdown" -> {
                    val packageName = call.argument<String>("packageName")
                    val detailed = call.argument<Boolean>("detailed") ?: false
                    
                    if (packageName != null) {
                        storageAnalyzer.analyze(
                            packageName = packageName,
                            detailed = detailed,
                            onResult = { breakdown ->
                                handler.post { result.success(breakdown.toMap()) }
                            },
                            onError = { error ->
                                handler.post { result.error("STORAGE_ERROR", error, null) }
                            }
                        )
                    } else {
                        result.error("INVALID_ARGUMENT", "Package name is required", null)
                    }
                }
                "cancelStorageAnalysis" -> {
                    val packageName = call.argument<String>("packageName")
                    if (packageName != null) {
                        storageAnalyzer.cancelAnalysis(packageName)
                    } else {
                        storageAnalyzer.cancelAll()
                    }
                    result.success(null)
                }
                "clearStorageCache" -> {
                    storageAnalyzer.clearCache()
                    result.success(null)
                }
                "getBatteryImpactData" -> {
                    val hoursBack = call.argument<Int>("hoursBack") ?: 24
                    executor.execute {
                        try {
                            val data = batteryAnalyzer.getBatteryImpactData(hoursBack)
                            handler.post { result.success(data) }
                        } catch (e: Exception) {
                            handler.post { result.error("ERROR", e.message, null) }
                        }
                    }
                }
                "getBatteryVampires" -> {
                    executor.execute {
                        try {
                            val vampires = batteryAnalyzer.getBatteryVampires()
                            handler.post { result.success(vampires) }
                        } catch (e: Exception) {
                            handler.post { result.error("ERROR", e.message, null) }
                        }
                    }
                }
                "getAppBatteryHistory" -> {
                    val packageName = call.argument<String>("packageName")
                    val daysBack = call.argument<Int>("daysBack") ?: 7
                    if (packageName != null) {
                        executor.execute {
                            try {
                                val history = batteryAnalyzer.getAppBatteryHistory(packageName, daysBack)
                                handler.post { result.success(history) }
                            } catch (e: Exception) {
                                handler.post { result.error("ERROR", e.message, null) }
                            }
                        }
                    } else {
                        result.error("INVALID_ARGUMENT", "Package name is required", null)
                    }
                }
                "getDeviceAbi" -> {
                    val abi = android.os.Build.SUPPORTED_ABIS.firstOrNull() ?: "unknown"
                    result.success(abi)
                }
                "getAvailableDataRange" -> {
                    executor.execute {
                        try {
                            val dataRange = usageManager.getAvailableDataRange()
                            val response = mapOf(
                                "oldestTimestamp" to dataRange.oldestTimestamp,
                                "newestTimestamp" to dataRange.newestTimestamp,
                                "availableDays" to dataRange.availableDays,
                                "hasData" to dataRange.hasData
                            )
                            handler.post { result.success(response) }
                        } catch (e: Exception) {
                            handler.post { result.error("ERROR", e.message, null) }
                        }
                    }
                }
                "getDailyUsageSnapshots" -> {
                    val startDate = call.argument<Long>("startDate") ?: 0L
                    val endDate = call.argument<Long>("endDate") ?: System.currentTimeMillis()
                    executor.execute {
                        try {
                            val snapshots = usageManager.getDailyUsageSnapshots(startDate, endDate)
                            handler.post { result.success(snapshots) }
                        } catch (e: Exception) {
                            handler.post { result.error("ERROR", e.message, null) }
                        }
                    }
                }
                else -> result.notImplemented()
            }
        }

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL).setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    eventSink = events
                }
                override fun onCancel(arguments: Any?) {
                    eventSink = null
                }
            }
        )
    }
    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        super.cleanUpFlutterEngine(flutterEngine)
        try {
            appRepository.shutdown()
            storageAnalyzer.shutdown()
        } catch (e: Exception) {
        }
    }
    
    override fun onDestroy() {
        super.onDestroy()
        executor.shutdown()
    }
    
    private fun generateOOMReport(e: OutOfMemoryError): String {
        val runtime = Runtime.getRuntime()
        val freeMemory = runtime.freeMemory() / 1024 / 1024
        val totalMemory = runtime.totalMemory() / 1024 / 1024
        val maxMemory = runtime.maxMemory() / 1024 / 1024
        
        val report = StringBuilder()
        report.append("═══════════════════════════════════════\n")
        report.append("OUT OF MEMORY ERROR REPORT\n")
        report.append("═══════════════════════════════════════\n\n")
        
        report.append("📱 DEVICE INFO:\n")
        report.append("  • Manufacturer: ${android.os.Build.MANUFACTURER}\n")
        report.append("  • Model: ${android.os.Build.MODEL}\n")
        report.append("  • Android: ${android.os.Build.VERSION.RELEASE} (API ${android.os.Build.VERSION.SDK_INT})\n")
        report.append("  • Build: ${android.os.Build.DISPLAY}\n\n")
        
        report.append("💾 MEMORY STATUS:\n")
        report.append("  • Free: ${freeMemory}MB\n")
        report.append("  • Total: ${totalMemory}MB\n")
        report.append("  • Max: ${maxMemory}MB\n")
        report.append("  • Used: ${totalMemory - freeMemory}MB\n\n")
        
        report.append("❌ ERROR:\n")
        report.append("  • Type: OutOfMemoryError\n")
        report.append("  • Message: ${e.message ?: "No message"}\n\n")
        
        report.append("⚠️ CAUSE:\n")
        report.append("  → Device ran out of memory during scan\n")
        report.append("  → Free memory too low: ${freeMemory}MB\n")
        report.append("  → Try closing other apps\n")
        report.append("  → Try freeing up storage space\n\n")
        
        report.append("📋 NEXT STEPS:\n")
        report.append("  1. Screenshot this entire message\n")
        report.append("  2. Send to developer for analysis\n")
        report.append("  3. Close all other apps\n")
        report.append("  4. Restart device and try again\n\n")
        
        report.append("═══════════════════════════════════════\n")
        report.append("App Version: 1.1.3+10\n")
        report.append("Error Code: OUT_OF_MEMORY\n")
        report.append("═══════════════════════════════════════")
        
        return report.toString()
    }
    
    private fun generateGenericErrorReport(e: Exception): String {
        val runtime = Runtime.getRuntime()
        val freeMemory = runtime.freeMemory() / 1024 / 1024
        val totalMemory = runtime.totalMemory() / 1024 / 1024
        
        val report = StringBuilder()
        report.append("═══════════════════════════════════════\n")
        report.append("SCAN ERROR REPORT\n")
        report.append("═══════════════════════════════════════\n\n")
        
        report.append("📱 DEVICE INFO:\n")
        report.append("  • Manufacturer: ${android.os.Build.MANUFACTURER}\n")
        report.append("  • Model: ${android.os.Build.MODEL}\n")
        report.append("  • Android: ${android.os.Build.VERSION.RELEASE} (API ${android.os.Build.VERSION.SDK_INT})\n")
        report.append("  • Build: ${android.os.Build.DISPLAY}\n\n")
        
        report.append("💾 MEMORY STATUS:\n")
        report.append("  • Free: ${freeMemory}MB\n")
        report.append("  • Total: ${totalMemory}MB\n\n")
        
        report.append("❌ ERROR:\n")
        report.append("  • Type: ${e.javaClass.simpleName}\n")
        report.append("  • Message: ${e.message ?: "No message"}\n")
        if (e.cause != null) {
            report.append("  • Cause: ${e.cause?.message}\n")
        }
        report.append("\n")
        
        report.append("📋 STACK TRACE (Top 5):\n")
        val stackTrace = e.stackTrace.take(5)
        for (element in stackTrace) {
            report.append("  → ${element}\n")
        }
        report.append("\n")
        
        report.append("📋 NEXT STEPS:\n")
        report.append("  1. Screenshot this entire message\n")
        report.append("  2. Send to developer for analysis\n")
        report.append("  3. Try restarting the app\n")
        report.append("  4. If issue persists, restart device\n\n")
        
        report.append("═══════════════════════════════════════\n")
        report.append("App Version: 1.1.3+10\n")
        report.append("Error Code: GENERIC_ERROR\n")
        report.append("═══════════════════════════════════════")
        
        return report.toString()
    }
}
