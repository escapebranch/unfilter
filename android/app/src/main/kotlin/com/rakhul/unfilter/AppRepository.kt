package com.escapebranch.unfilter

import android.content.Context
import android.content.pm.ApplicationInfo
import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.Drawable
import android.os.Build
import java.io.ByteArrayOutputStream
import java.io.File
import java.util.concurrent.Executors
import java.util.concurrent.Future
import java.util.concurrent.Callable
import java.util.concurrent.TimeUnit
import java.util.concurrent.TimeoutException
import java.util.concurrent.atomic.AtomicInteger
import android.util.Log

class AppRepository(private val context: Context) {

    private val packageManager: PackageManager = context.packageManager
    private val stackDetector = StackDetector()
    private val usageManager = UsageManager(context)
    private val deepAnalyzer = DeepAnalyzer(context)
    
    // Thread pool: min 3, max 6 — matches original perf while staying safe 
    private val threadCount = Runtime.getRuntime().availableProcessors().coerceIn(3, 6)
    private val scanExecutor = Executors.newFixedThreadPool(threadCount)
    
    companion object {
        private const val TAG = "AppRepository"
        private const val FUTURE_TIMEOUT_SECONDS = 45L  // More generous for slow devices
        private const val MIN_FREE_MEMORY_MB = 30L      // Lower threshold, rely on GC
        private const val ICON_SIZE = 48                 // Smaller icons = much less memory
    }
    
    class ScanFailureException(val errorReport: String) : Exception(errorReport)
    
    /**
     * Determines optimal batch size based on device available memory.
     * Aggressive but safe — minimum 5 (never goes sequential).
     * Critical (< 80MB free): batch of 5 (still parallel, just smaller)
     * Low-end (80-200MB free): batch of 8
     * Normal (200-400MB free): batch of 12
     * High-end (> 400MB free): batch of 15
     */
    private fun getAdaptiveBatchSize(): Int {
        val runtime = Runtime.getRuntime()
        val freeMemoryMB = runtime.freeMemory() / 1024 / 1024
        val maxMemoryMB = runtime.maxMemory() / 1024 / 1024
        val usedPercent = ((runtime.totalMemory() - runtime.freeMemory()) * 100) / runtime.maxMemory()
        
        val batchSize = when {
            freeMemoryMB < 80 || usedPercent > 85 -> 5    // Critical — small parallel batch
            freeMemoryMB < 200 || usedPercent > 70 -> 8   // Low-end
            freeMemoryMB < 400 -> 12                       // Normal
            else -> 15                                      // High-end
        }
        
        Log.d(TAG, "Adaptive batch: $batchSize (free: ${freeMemoryMB}MB, max: ${maxMemoryMB}MB, used: $usedPercent%)")
        return batchSize
    }
    
    private fun generateErrorReport(
        filteredTotal: Int,
        failedCount: Int,
        timeoutCount: Int,
        exceptionCount: Int,
        initialFreeMemory: Long
    ): String {
        val runtime = Runtime.getRuntime()
        val currentFreeMemory = runtime.freeMemory() / 1024 / 1024
        val totalMemory = runtime.totalMemory() / 1024 / 1024
        val maxMemory = runtime.maxMemory() / 1024 / 1024
        
        val deviceInfo = StringBuilder()
        deviceInfo.append("═══════════════════════════════════════\n")
        deviceInfo.append("SCAN FAILURE ERROR REPORT\n")
        deviceInfo.append("═══════════════════════════════════════\n\n")
        
        deviceInfo.append("📱 DEVICE INFO:\n")
        deviceInfo.append("  • Manufacturer: ${Build.MANUFACTURER}\n")
        deviceInfo.append("  • Model: ${Build.MODEL}\n")
        deviceInfo.append("  • Android: ${Build.VERSION.RELEASE} (API ${Build.VERSION.SDK_INT})\n")
        deviceInfo.append("  • Build: ${Build.DISPLAY}\n")
        deviceInfo.append("  • CPU Cores: ${Runtime.getRuntime().availableProcessors()}\n\n")
        
        deviceInfo.append("💾 MEMORY STATUS:\n")
        deviceInfo.append("  • Initial Free: ${initialFreeMemory}MB\n")
        deviceInfo.append("  • Current Free: ${currentFreeMemory}MB\n")
        deviceInfo.append("  • Total: ${totalMemory}MB\n")
        deviceInfo.append("  • Max: ${maxMemory}MB\n")
        deviceInfo.append("  • Used: ${totalMemory - currentFreeMemory}MB\n\n")
        
        deviceInfo.append("📊 SCAN STATISTICS:\n")
        deviceInfo.append("  • Total Packages: $filteredTotal\n")
        deviceInfo.append("  • Successful: 0\n")
        deviceInfo.append("  • Failed (null): $failedCount\n")
        deviceInfo.append("  • Timeouts: $timeoutCount\n")
        deviceInfo.append("  • Exceptions: $exceptionCount\n")
        deviceInfo.append("  • Success Rate: 0%\n\n")
        
        deviceInfo.append("⚙️ SCAN CONFIG:\n")
        deviceInfo.append("  • Thread Pool: $threadCount threads\n")
        deviceInfo.append("  • Timeout: ${FUTURE_TIMEOUT_SECONDS}s\n")
        deviceInfo.append("  • Min Free Memory: ${MIN_FREE_MEMORY_MB}MB\n")
        deviceInfo.append("  • Icon Size: ${ICON_SIZE}px\n\n")
        
        deviceInfo.append("❌ FAILURE ANALYSIS:\n")
        when {
            currentFreeMemory < 50 -> {
                deviceInfo.append("  ⚠️ CRITICAL: Very low memory (${currentFreeMemory}MB)\n")
                deviceInfo.append("  → Device is under extreme memory pressure\n")
                deviceInfo.append("  → OEM ROM may be killing processes\n")
            }
            timeoutCount > filteredTotal / 2 -> {
                deviceInfo.append("  ⚠️ CRITICAL: High timeout rate ($timeoutCount/$filteredTotal)\n")
                deviceInfo.append("  → Tasks taking >${FUTURE_TIMEOUT_SECONDS}s to complete\n")
                deviceInfo.append("  → Device may be extremely slow\n")
            }
            exceptionCount > filteredTotal / 2 -> {
                deviceInfo.append("  ⚠️ CRITICAL: High exception rate ($exceptionCount/$filteredTotal)\n")
                deviceInfo.append("  → Unexpected errors during processing\n")
                deviceInfo.append("  → Check logcat for details\n")
            }
            else -> {
                deviceInfo.append("  ⚠️ All tasks failed - unknown cause\n")
                deviceInfo.append("  → Check logcat for detailed errors\n")
            }
        }
        deviceInfo.append("\n")
        
        deviceInfo.append("📋 NEXT STEPS:\n")
        deviceInfo.append("  1. Screenshot this entire message\n")
        deviceInfo.append("  2. Send to developer for analysis\n")
        deviceInfo.append("  3. Try freeing up storage space\n")
        deviceInfo.append("  4. Restart device and try again\n\n")
        
        deviceInfo.append("═══════════════════════════════════════\n")
        deviceInfo.append("Error Code: SCAN_COMPLETE_FAILURE\n")
        deviceInfo.append("═══════════════════════════════════════")
        
        return deviceInfo.toString()
    }

    fun getInstalledApps(
        includeDetails: Boolean,
        onProgress: (current: Int, total: Int, currentApp: String) -> Unit,
        checkScanCancelled: () -> Boolean
    ): List<Map<String, Any?>> {
        var detailsFlags = 0
        if (includeDetails) {
            detailsFlags = PackageManager.GET_META_DATA or
                    PackageManager.GET_PERMISSIONS or
                    PackageManager.GET_SERVICES or
                    PackageManager.GET_RECEIVERS or
                    PackageManager.GET_PROVIDERS or
                    (if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) PackageManager.GET_SIGNING_CERTIFICATES else PackageManager.GET_SIGNATURES)
        }

        // Always use lightweight query for the list — avoids Binder TransactionTooLarge
        val packages = packageManager.getInstalledPackages(0)
        
        val launchIntent = android.content.Intent(android.content.Intent.ACTION_MAIN, null)
        launchIntent.addCategory(android.content.Intent.CATEGORY_LAUNCHER)
        val launchables = packageManager.queryIntentActivities(launchIntent, 0)
        val launchablePackages = launchables.map { it.activityInfo.packageName }.toSet()

        val total = packages.size
        val usageMap = if (includeDetails) usageManager.getUsageMap() else emptyMap()
        
        Log.d(TAG, "Starting scan: total=$total packages, includeDetails=$includeDetails, threads=$threadCount")

        if (includeDetails) {
             return processBatchedWithDetails(
                 packages,
                 launchablePackages,
                 usageMap,
                 total,
                 detailsFlags,
                 onProgress,
                 checkScanCancelled
             )
        } else {
            val appList = mutableListOf<Map<String, Any?>>()
            for ((index, pkg) in packages.withIndex()) {
                if (checkScanCancelled()) break

                val packageName = pkg.packageName

                if (index % 10 == 0) {
                     onProgress(index + 1, total, packageName)
                }

                val appInfo = pkg.applicationInfo ?: continue
                val isSystem = (appInfo.flags and ApplicationInfo.FLAG_SYSTEM) != 0
                val isUpdatedSystem = (appInfo.flags and ApplicationInfo.FLAG_UPDATED_SYSTEM_APP) != 0
                val shouldInclude = launchablePackages.contains(packageName) || (!isSystem || isUpdatedSystem)

                if (shouldInclude) {
                    try {
                        appList.add(convertPackageToMap(pkg, includeDetails, usageMap))
                    } catch (e: Exception) {
                        Log.w(TAG, "Failed to process package ${pkg.packageName}: ${e.message}")
                    }
                }
            }
            Log.d(TAG, "Scan complete: ${appList.size} apps processed")
            return appList
        }
    }
    
    private fun processBatchedWithDetails(
        packages: List<PackageInfo>,
        launchablePackages: Set<String>,
        usageMap: Map<String, android.app.usage.UsageStats>,
        total: Int,
        detailsFlags: Int,
        onProgress: (current: Int, total: Int, currentApp: String) -> Unit,
        checkScanCancelled: () -> Boolean
    ): List<Map<String, Any?>> {
        val results = mutableListOf<Map<String, Any?>>()
        val counter = AtomicInteger(0)
        var failedCount = 0
        var timeoutCount = 0
        var exceptionCount = 0
        
        val filteredPackages = packages.filter { pkg ->
            val appInfo = pkg.applicationInfo
            if (appInfo == null) return@filter false
            
            val isSystem = (appInfo.flags and ApplicationInfo.FLAG_SYSTEM) != 0
            val isUpdatedSystem = (appInfo.flags and ApplicationInfo.FLAG_UPDATED_SYSTEM_APP) != 0
            launchablePackages.contains(pkg.packageName) || (!isSystem || isUpdatedSystem)
        }
        
        val filteredTotal = filteredPackages.size
        Log.d(TAG, "Filtered to $filteredTotal packages for detailed scan (from $total total)")
        
        val runtime = Runtime.getRuntime()
        val initialFreeMemory = runtime.freeMemory() / 1024 / 1024
        Log.d(TAG, "Initial free memory: ${initialFreeMemory}MB, max: ${runtime.maxMemory() / 1024 / 1024}MB")
        
        // Get initial batch size — recalculated every few batches
        var currentBatchSize = getAdaptiveBatchSize()
        
        for (batchStart in filteredPackages.indices step currentBatchSize) {
            if (checkScanCancelled()) {
                Log.d(TAG, "Scan cancelled by user")
                break
            }
            
            // Recalculate batch size every 3 batches (not every batch — avoid overhead)
            val batchNumber = batchStart / currentBatchSize + 1
            if (batchNumber % 3 == 0) {
                currentBatchSize = getAdaptiveBatchSize()
            }
            
            val freeMemory = runtime.freeMemory() / 1024 / 1024
            if (freeMemory < MIN_FREE_MEMORY_MB) {
                Log.w(TAG, "Low memory: ${freeMemory}MB free, GC")
                System.gc()
                try { Thread.sleep(50) } catch (e: InterruptedException) { break }
            }
            
            val batchEnd = minOf(batchStart + currentBatchSize, filteredPackages.size)
            val batch = filteredPackages.subList(batchStart, batchEnd)
            
            // Always parallel — thread pool handles the concurrency limit naturally
            val futures = mutableListOf<Pair<String, Future<Map<String, Any?>?>>>()
            
            for (pkg in batch) {
                if (checkScanCancelled()) break
                
                val packageName = pkg.packageName
                val future = scanExecutor.submit(Callable {
                    if (checkScanCancelled() || Thread.currentThread().isInterrupted) return@Callable null
                    
                    try {
                        val detailedPkg = packageManager.getPackageInfo(packageName, detailsFlags)
                        convertPackageToMap(detailedPkg, true, usageMap)
                    } catch (e: OutOfMemoryError) {
                        Log.e(TAG, "OOM: $packageName - ${e.message}")
                        System.gc()
                        null
                    } catch (e: Exception) {
                        Log.w(TAG, "Error processing $packageName: ${e.message}")
                        null
                    }
                })
                futures.add(packageName to future)
            }
            
            for ((packageName, future) in futures) {
                val index = counter.incrementAndGet()
                
                try {
                    val result = future.get(FUTURE_TIMEOUT_SECONDS, TimeUnit.SECONDS)
                    
                    if (index % 5 == 0 || index == filteredTotal) {
                        onProgress(index, filteredTotal, packageName)
                    }
                    
                    if (result != null) {
                        results.add(result)
                    } else {
                        failedCount++
                    }
                } catch (e: TimeoutException) {
                    timeoutCount++
                    future.cancel(true)
                    Log.e(TAG, "TIMEOUT: $packageName after ${FUTURE_TIMEOUT_SECONDS}s")
                } catch (e: OutOfMemoryError) {
                    exceptionCount++
                    Log.e(TAG, "OOM: $packageName - ${e.message}")
                    System.gc()
                } catch (e: Exception) {
                    exceptionCount++
                    Log.e(TAG, "EXCEPTION: $packageName - ${e.javaClass.simpleName}: ${e.message}")
                }
            }
            
            // Light GC every 5 batches — not every 3
            if (batchNumber % 5 == 0) {
                System.gc()
            }
        }
        
        val successRate = if (filteredTotal > 0) (results.size * 100) / filteredTotal else 0
        Log.d(TAG, "Scan complete: ${results.size}/$filteredTotal apps ($successRate%), $failedCount failed, $timeoutCount timeouts, $exceptionCount exceptions")
        
        if (results.isEmpty() && filteredTotal > 0) {
            Log.e(TAG, "CRITICAL: Scan returned 0 apps from $filteredTotal packages - all failed!")
            Log.e(TAG, "Breakdown: $failedCount null results, $timeoutCount timeouts, $exceptionCount exceptions")
            
            val errorReport = generateErrorReport(
                filteredTotal = filteredTotal,
                failedCount = failedCount,
                timeoutCount = timeoutCount,
                exceptionCount = exceptionCount,
                initialFreeMemory = initialFreeMemory
            )
            throw ScanFailureException(errorReport)
        }
        
        return results
    }

    fun getAppsDetails(packageNames: List<String>): List<Map<String, Any?>> {
        val usageMap = usageManager.getUsageMap()
        val flags = PackageManager.GET_META_DATA or
                PackageManager.GET_PERMISSIONS or
                PackageManager.GET_SERVICES or
                PackageManager.GET_RECEIVERS or
                PackageManager.GET_PROVIDERS or
                (if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) PackageManager.GET_SIGNING_CERTIFICATES else PackageManager.GET_SIGNATURES)

        val futures = mutableListOf<Pair<String, Future<Map<String, Any?>?>>>()
        
        for (name in packageNames) {
            val future = scanExecutor.submit(Callable {
                try {
                    val pkg = packageManager.getPackageInfo(name, flags)
                    if (pkg.applicationInfo != null) {
                        convertPackageToMap(pkg, true, usageMap)
                    } else null
                } catch (e: Exception) {
                    Log.w(TAG, "Failed to get details for $name: ${e.message}")
                    null
                }
            })
            futures.add(name to future)
        }

        val results = mutableListOf<Map<String, Any?>>()
        for ((name, future) in futures) {
            try {
                val result = future.get(FUTURE_TIMEOUT_SECONDS, TimeUnit.SECONDS)
                if (result != null) results.add(result)
            } catch (e: TimeoutException) {
                future.cancel(true)
                Log.e(TAG, "Timeout getting details for $name")
            } catch (e: Exception) {
                Log.e(TAG, "Error getting details for $name: ${e.message}")
            }
        }
        return results
    }


    private fun convertPackageToMap(
        pkg: PackageInfo,
        includeDetails: Boolean,
        usageMap: Map<String, android.app.usage.UsageStats>?
    ): Map<String, Any?> {
        // Check thread interruption early
        if (Thread.currentThread().isInterrupted) {
            throw InterruptedException("Thread interrupted for ${pkg.packageName}")
        }
        
        val appInfo = pkg.applicationInfo
        if (appInfo == null) {
            Log.e(TAG, "ApplicationInfo is null for ${pkg.packageName}")
            throw IllegalStateException("ApplicationInfo is null for ${pkg.packageName}")
        }

        var stack = "Unknown"
        var libs = emptyList<String>()
        var iconBytes = ByteArray(0)
        var usage: android.app.usage.UsageStats? = null
        var deepData: Map<String, Any?> = emptyMap()
        
        var permissions = emptyList<String>()
        var services = emptyList<String>()
        var receivers = emptyList<String>()
        var providers = emptyList<String>()

        if (includeDetails) {
            val sourceDir = appInfo.sourceDir
            var zipFile: java.util.zip.ZipFile? = null
            try {
                if (sourceDir != null && File(sourceDir).exists()) {
                    zipFile = java.util.zip.ZipFile(File(sourceDir))
                }
            } catch (e: OutOfMemoryError) {
                Log.e(TAG, "OOM opening ZipFile for ${pkg.packageName}, skipping deep analysis")
                // Don't throw — continue without deep analysis
                zipFile = null
            } catch (e: Exception) {
                Log.w(TAG, "Error opening ZipFile for ${pkg.packageName}: ${e.message}")
            }

            try {
                if (Thread.currentThread().isInterrupted) return createMinimalMap(pkg, appInfo)
                
                val pair = stackDetector.detectStackAndLibs(appInfo, zipFile)
                stack = pair.first
                libs = pair.second

                usage = usageMap?.get(pkg.packageName)
                
                if (Thread.currentThread().isInterrupted) return createMinimalMap(pkg, appInfo)
                
                deepData = try {
                    deepAnalyzer.analyze(pkg, packageManager, zipFile)
                } catch (e: OutOfMemoryError) {
                    Log.e(TAG, "OOM in deepAnalyzer for ${pkg.packageName}")
                    emptyMap()
                }

                try {
                    val iconDrawable = packageManager.getApplicationIcon(appInfo)
                    iconBytes = drawableToByteArray(iconDrawable)
                } catch (e: OutOfMemoryError) {
                    Log.e(TAG, "OOM loading icon for ${pkg.packageName}")
                    iconBytes = ByteArray(0)
                } catch (e: Exception) {
                    Log.w(TAG, "Failed to load icon for ${pkg.packageName}: ${e.message}")
                    iconBytes = ByteArray(0)
                }
                
                permissions = pkg.requestedPermissions?.toList() ?: emptyList()
                services = pkg.services?.map { it.name } ?: emptyList()
                receivers = pkg.receivers?.map { it.name } ?: emptyList()
                providers = pkg.providers?.map { it.name } ?: emptyList()
            } catch (e: OutOfMemoryError) {
                Log.e(TAG, "OOM in convertPackageToMap for ${pkg.packageName}, returning partial data")
                // Return partial data instead of throwing
                return createMinimalMap(pkg, appInfo)
            } catch (e: InterruptedException) {
                return createMinimalMap(pkg, appInfo)
            } catch (e: Exception) {
                Log.e(TAG, "Error in detail processing for ${pkg.packageName}: ${e.javaClass.simpleName} - ${e.message}")
            } finally {
                try {
                    zipFile?.close()
                } catch (e: Exception) {
                    Log.w(TAG, "Error closing ZipFile for ${pkg.packageName}: ${e.message}")
                }
            }
        }

        val isSystem = (appInfo.flags and ApplicationInfo.FLAG_SYSTEM) != 0

        var appSize = 0L
        var dataSize = 0L
        var cacheSize = 0L
        var externalCacheSize = 0L

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            try {
                val storageStatsManager = context.getSystemService(Context.STORAGE_STATS_SERVICE) as android.app.usage.StorageStatsManager
                val uuid = android.os.storage.StorageManager.UUID_DEFAULT
                val stats = storageStatsManager.queryStatsForPackage(
                    uuid, 
                    pkg.packageName, 
                    android.os.Process.myUserHandle()
                )
                
                appSize = stats.appBytes
                dataSize = stats.dataBytes
                cacheSize = stats.cacheBytes
                externalCacheSize = stats.externalCacheBytes
            } catch (e: SecurityException) {
                Log.w(TAG, "SecurityException getting storage stats for ${pkg.packageName}")
                if (appInfo.sourceDir != null) appSize = File(appInfo.sourceDir).length()
            } catch (e: Exception) {
                if (appInfo.sourceDir != null) appSize = File(appInfo.sourceDir).length()
            }
        } else {
             if (appInfo.sourceDir != null) appSize = File(appInfo.sourceDir).length()
        }

        val totalSize = appSize + dataSize + cacheSize

        val appName = try {
            if (includeDetails) {
                packageManager.getApplicationLabel(appInfo).toString()
            } else {
                pkg.packageName
            }
        } catch (e: Exception) {
            Log.w(TAG, "Error getting app label for ${pkg.packageName}: ${e.message}")
            pkg.packageName
        }
        
        val map = mutableMapOf<String, Any?>(
            "appName" to appName,
            "packageName" to pkg.packageName,
            "version" to (pkg.versionName ?: "Unknown"),
            "icon" to iconBytes,
            "versionCode" to (if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) pkg.longVersionCode else pkg.versionCode.toLong()),
            "stack" to stack,
            "nativeLibraries" to libs,
            "isSystem" to isSystem,
            "firstInstallTime" to pkg.firstInstallTime,
            "lastUpdateTime" to pkg.lastUpdateTime,
            "minSdkVersion" to (if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) appInfo.minSdkVersion else 0),
            "targetSdkVersion" to appInfo.targetSdkVersion,
            "uid" to appInfo.uid,
            "permissions" to permissions,
            "services" to services,
            "receivers" to receivers,
            "providers" to providers,
            "totalTimeInForeground" to (usage?.totalTimeInForeground ?: 0),
            "lastTimeUsed" to (usage?.lastTimeUsed ?: 0),
            "category" to (if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                when (appInfo.category) {
                    ApplicationInfo.CATEGORY_GAME -> "game"
                    ApplicationInfo.CATEGORY_AUDIO -> "audio"
                    ApplicationInfo.CATEGORY_VIDEO -> "video"
                    ApplicationInfo.CATEGORY_IMAGE -> "image"
                    ApplicationInfo.CATEGORY_SOCIAL -> "social"
                    ApplicationInfo.CATEGORY_NEWS -> "news"
                    ApplicationInfo.CATEGORY_MAPS -> "maps"
                    ApplicationInfo.CATEGORY_PRODUCTIVITY -> "productivity"
                    -1 -> "unknown"
                    else -> "tools"
                }
            } else "unknown"),
            "size" to totalSize,
            "appSize" to appSize,
            "dataSize" to dataSize,
            "cacheSize" to cacheSize,
            "externalCacheSize" to externalCacheSize,
            "apkPath" to (appInfo.sourceDir ?: ""),
            "dataDir" to (appInfo.dataDir ?: "")
        )
        
        map.putAll(deepData)
        
        return map
    }
    
    /**
     * Creates a minimal map with just basic info when full processing fails (OOM etc).
     * This ensures partial data is always returned rather than dropping the app entirely.
     */
    private fun createMinimalMap(pkg: PackageInfo, appInfo: ApplicationInfo): Map<String, Any?> {
        val appName = try {
            packageManager.getApplicationLabel(appInfo).toString()
        } catch (e: Exception) {
            pkg.packageName
        }
        
        val isSystem = (appInfo.flags and ApplicationInfo.FLAG_SYSTEM) != 0
        var appSize = 0L
        if (appInfo.sourceDir != null) {
            try { appSize = File(appInfo.sourceDir).length() } catch (e: Exception) {}
        }
        
        return mapOf(
            "appName" to appName,
            "packageName" to pkg.packageName,
            "version" to (pkg.versionName ?: "Unknown"),
            "icon" to ByteArray(0),
            "versionCode" to (if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) pkg.longVersionCode else pkg.versionCode.toLong()),
            "stack" to "Unknown",
            "nativeLibraries" to emptyList<String>(),
            "isSystem" to isSystem,
            "firstInstallTime" to pkg.firstInstallTime,
            "lastUpdateTime" to pkg.lastUpdateTime,
            "minSdkVersion" to (if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) appInfo.minSdkVersion else 0),
            "targetSdkVersion" to appInfo.targetSdkVersion,
            "uid" to appInfo.uid,
            "permissions" to emptyList<String>(),
            "services" to emptyList<String>(),
            "receivers" to emptyList<String>(),
            "providers" to emptyList<String>(),
            "totalTimeInForeground" to 0L,
            "lastTimeUsed" to 0L,
            "category" to "unknown",
            "size" to appSize,
            "appSize" to appSize,
            "dataSize" to 0L,
            "cacheSize" to 0L,
            "externalCacheSize" to 0L,
            "apkPath" to (appInfo.sourceDir ?: ""),
            "dataDir" to (appInfo.dataDir ?: "")
        )
    }

    private fun drawableToByteArray(drawable: Drawable): ByteArray {
        var bitmap: Bitmap? = null
        var scaledBitmap: Bitmap? = null
        var stream: ByteArrayOutputStream? = null
        try {
            if (drawable is BitmapDrawable) {
                bitmap = drawable.bitmap
            } else {
                val width = if (drawable.intrinsicWidth > 0) drawable.intrinsicWidth else 1
                val height = if (drawable.intrinsicHeight > 0) drawable.intrinsicHeight else 1
                bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888)
                val canvas = Canvas(bitmap)
                drawable.setBounds(0, 0, canvas.width, canvas.height)
                drawable.draw(canvas)
            }
            
            if (bitmap == null) return ByteArray(0)

            scaledBitmap = Bitmap.createScaledBitmap(bitmap, ICON_SIZE, ICON_SIZE, true)

            stream = ByteArrayOutputStream(2048)  // Pre-allocate smaller buffer
            
            // Use WEBP for much smaller file sizes (4-6x smaller than PNG)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                scaledBitmap.compress(Bitmap.CompressFormat.WEBP_LOSSY, 75, stream)
            } else {
                @Suppress("DEPRECATION")
                scaledBitmap.compress(Bitmap.CompressFormat.WEBP, 75, stream)
            }
            
            val result = stream.toByteArray()
            
            stream.close()
            stream = null
            
            return result
        } catch (e: OutOfMemoryError) {
            Log.e(TAG, "OutOfMemoryError creating icon bitmap", e)
            return ByteArray(0)
        } catch (e: Exception) {
            Log.w(TAG, "Error converting drawable to byte array: ${e.message}")
            return ByteArray(0)
        } finally {
            try {
                stream?.close()
            } catch (e: Exception) { }
            try {
                if (scaledBitmap != null && scaledBitmap != bitmap) {
                    scaledBitmap.recycle()
                }
                if (bitmap != null && drawable !is BitmapDrawable) {
                    bitmap.recycle()
                }
            } catch (e: Exception) {
                Log.w(TAG, "Error recycling bitmaps: ${e.message}")
            }
        }
    }

    fun shutdown() {
        try {
            scanExecutor.shutdownNow()
        } catch (e: Exception) {
        }
    }
}
