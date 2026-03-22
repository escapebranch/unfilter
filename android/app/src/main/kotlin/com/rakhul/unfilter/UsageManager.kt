package com.escapebranch.unfilter

import android.app.AppOpsManager
import android.app.usage.UsageStatsManager
import android.content.Context
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.drawable.BitmapDrawable
import android.os.Build
import android.util.Log
import java.io.ByteArrayOutputStream
import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Date
import java.util.Locale

class UsageManager(private val context: Context) {

    private val packageManager: PackageManager = context.packageManager
    
    companion object {
        private const val TAG = "UsageManager"
    }
    
    data class UsageDataRange(
        val oldestTimestamp: Long,
        val newestTimestamp: Long,
        val availableDays: Int,
        val hasData: Boolean
    )
    
    data class DailyUsageSnapshot(
        val date: String,
        val timestamp: Long,
        val appUsages: Map<String, Long>
    )

    fun hasPermission(): Boolean {
        val appOps = context.getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
        val mode = appOps.checkOpNoThrow(
            AppOpsManager.OPSTR_GET_USAGE_STATS,
            android.os.Process.myUid(),
            context.packageName
        )
        return mode == AppOpsManager.MODE_ALLOWED
    }

    fun getUsageMap(): Map<String, android.app.usage.UsageStats> {
        if (!hasPermission()) {
            Log.d(TAG, "Usage permission not granted")
            return emptyMap()
        }
        
        return try {
            val usageStatsManager = context.getSystemService(Context.USAGE_STATS_SERVICE) as? UsageStatsManager
            if (usageStatsManager == null) {
                Log.e(TAG, "UsageStatsManager is null")
                return emptyMap()
            }
            
            val calendar = Calendar.getInstance()
            val endTime = calendar.timeInMillis
            calendar.add(Calendar.YEAR, -2)
            val startTime = calendar.timeInMillis
            
            var usageMap = usageStatsManager.queryAndAggregateUsageStats(startTime, endTime)
            
            if (usageMap == null || usageMap.isEmpty()) {
                Log.w(TAG, "queryAndAggregateUsageStats returned null/empty, falling back to queryUsageStats")
                usageMap = queryUsageStatsFallback(usageStatsManager, startTime, endTime)
            }
            
            Log.d(TAG, "Retrieved usage stats for ${usageMap.size} packages")
            usageMap ?: emptyMap()
        } catch (e: SecurityException) {
            Log.e(TAG, "SecurityException getting usage stats: ${e.message}")
            emptyMap()
        } catch (e: Exception) {
            Log.e(TAG, "Error getting usage stats: ${e.message}", e)
            emptyMap()
        }
    }
    
    private fun queryUsageStatsFallback(
        usageStatsManager: UsageStatsManager,
        startTime: Long,
        endTime: Long
    ): Map<String, android.app.usage.UsageStats> {
        return try {
            val usageStatsList = usageStatsManager.queryUsageStats(
                UsageStatsManager.INTERVAL_BEST,
                startTime,
                endTime
            )
            
            if (usageStatsList == null || usageStatsList.isEmpty()) {
                Log.w(TAG, "Fallback queryUsageStats also returned null/empty")
                return emptyMap()
            }
            
            val aggregated = mutableMapOf<String, android.app.usage.UsageStats>()
            for (stats in usageStatsList) {
                val existing = aggregated[stats.packageName]
                if (existing == null || stats.lastTimeUsed > existing.lastTimeUsed) {
                    aggregated[stats.packageName] = stats
                }
            }
            
            Log.d(TAG, "Fallback aggregated ${aggregated.size} packages from ${usageStatsList.size} stats")
            aggregated
        } catch (e: Exception) {
            Log.e(TAG, "Fallback queryUsageStats failed: ${e.message}")
            emptyMap()
        }
    }
    
    fun getAvailableDataRange(): UsageDataRange {
        if (!hasPermission()) {
            Log.d(TAG, "No permission for getAvailableDataRange")
            return UsageDataRange(0, 0, 0, false)
        }
        
        return try {
            val usageStatsManager = context.getSystemService(Context.USAGE_STATS_SERVICE) as? UsageStatsManager
            if (usageStatsManager == null) {
                Log.e(TAG, "UsageStatsManager is null in getAvailableDataRange")
                return UsageDataRange(0, 0, 0, false)
            }
            
            val now = System.currentTimeMillis()
            val twoYearsAgo = now - (730L * 24 * 60 * 60 * 1000)
            
            var usageMap = usageStatsManager.queryAndAggregateUsageStats(twoYearsAgo, now)
            
            if (usageMap == null || usageMap.isEmpty()) {
                usageMap = queryUsageStatsFallback(usageStatsManager, twoYearsAgo, now)
            }
            
            if (usageMap.isEmpty()) {
                Log.w(TAG, "No usage data available")
                return UsageDataRange(0, 0, 0, false)
            }
            
            var oldest = Long.MAX_VALUE
            var newest = 0L
            
            for (stats in usageMap.values) {
                if (stats.firstTimeStamp > 0 && stats.firstTimeStamp < oldest) {
                    oldest = stats.firstTimeStamp
                }
                if (stats.lastTimeUsed > newest) {
                    newest = stats.lastTimeUsed
                }
            }
            
            if (oldest == Long.MAX_VALUE) oldest = 0
            
            val days = if (oldest > 0 && newest > oldest) {
                ((newest - oldest) / (24 * 60 * 60 * 1000)).toInt()
            } else {
                0
            }
            
            Log.d(TAG, "Available data range: $days days (${Date(oldest)} to ${Date(newest)})")
            UsageDataRange(oldest, newest, days, true)
        } catch (e: Exception) {
            Log.e(TAG, "Error getting available data range: ${e.message}", e)
            UsageDataRange(0, 0, 0, false)
        }
    }
    
    fun getDailyUsageSnapshots(startDate: Long, endDate: Long): List<Map<String, Any>> {
        if (!hasPermission()) {
            Log.d(TAG, "No permission for getDailyUsageSnapshots")
            return emptyList()
        }
        
        return try {
            val usageStatsManager = context.getSystemService(Context.USAGE_STATS_SERVICE) as? UsageStatsManager
            if (usageStatsManager == null) {
                Log.e(TAG, "UsageStatsManager is null in getDailyUsageSnapshots")
                return emptyList()
            }
            
            val snapshots = mutableListOf<Map<String, Any>>()
            val calendar = Calendar.getInstance()
            val dateFormat = SimpleDateFormat("yyyy-MM-dd", Locale.US)
            
            var currentDate = startDate
            val maxDate = minOf(endDate, System.currentTimeMillis())
            
            while (currentDate < maxDate) {
                calendar.timeInMillis = currentDate
                calendar.set(Calendar.HOUR_OF_DAY, 0)
                calendar.set(Calendar.MINUTE, 0)
                calendar.set(Calendar.SECOND, 0)
                calendar.set(Calendar.MILLISECOND, 0)
                val dayStart = calendar.timeInMillis
                
                calendar.set(Calendar.HOUR_OF_DAY, 23)
                calendar.set(Calendar.MINUTE, 59)
                calendar.set(Calendar.SECOND, 59)
                calendar.set(Calendar.MILLISECOND, 999)
                val dayEnd = calendar.timeInMillis
                
                val usageStats = usageStatsManager.queryUsageStats(
                    UsageStatsManager.INTERVAL_DAILY,
                    dayStart,
                    dayEnd
                )
                
                if (usageStats != null && usageStats.isNotEmpty()) {
                    val appUsages = mutableMapOf<String, Long>()
                    
                    for (stats in usageStats) {
                        if (stats.totalTimeInForeground > 0) {
                            val existing = appUsages[stats.packageName] ?: 0L
                            appUsages[stats.packageName] = existing + stats.totalTimeInForeground
                        }
                    }
                    
                    if (appUsages.isNotEmpty()) {
                        snapshots.add(mapOf(
                            "date" to dateFormat.format(Date(dayStart)),
                            "timestamp" to dayStart,
                            "appUsages" to appUsages
                        ))
                    }
                }
                
                currentDate += 24 * 60 * 60 * 1000
            }
            
            Log.d(TAG, "Generated ${snapshots.size} daily snapshots")
            snapshots
        } catch (e: Exception) {
            Log.e(TAG, "Error getting daily usage snapshots: ${e.message}", e)
            emptyList()
        }
    }

    
    fun getRecentlyActiveApps(hoursAgo: Int = 24): List<Map<String, Any?>> {
        if (!hasPermission()) return emptyList()
        
        val usageStatsManager = context.getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
        val calendar = Calendar.getInstance()
        val endTime = calendar.timeInMillis
        calendar.add(Calendar.HOUR_OF_DAY, -hoursAgo)
        val startTime = calendar.timeInMillis
        
        val usageStats = usageStatsManager.queryUsageStats(
            UsageStatsManager.INTERVAL_DAILY,
            startTime,
            endTime
        )
        
        val packageUsageMap = mutableMapOf<String, android.app.usage.UsageStats>()
        for (stats in usageStats) {
            val existing = packageUsageMap[stats.packageName]
            if (existing == null || stats.lastTimeUsed > existing.lastTimeUsed) {
                packageUsageMap[stats.packageName] = stats
            }
        }
        
        val recentApps = packageUsageMap.values
            .filter { it.lastTimeUsed > startTime && it.totalTimeInForeground > 0 }
            .sortedByDescending { it.lastTimeUsed }
            .take(50)
        
        return recentApps.mapNotNull { stats ->
            try {
                val appInfo = packageManager.getApplicationInfo(stats.packageName, 0)
                
                val launchIntent = packageManager.getLaunchIntentForPackage(stats.packageName)
                if (launchIntent == null && (appInfo.flags and android.content.pm.ApplicationInfo.FLAG_SYSTEM) != 0) {
                    return@mapNotNull null
                }
                
                val appName = packageManager.getApplicationLabel(appInfo).toString()
                val icon = try {
                    val drawable = packageManager.getApplicationIcon(appInfo)
                    drawableToByteArray(drawable)
                } catch (e: Exception) {
                    ByteArray(0)
                }
                
                mapOf(
                    "packageName" to stats.packageName,
                    "appName" to appName,
                    "icon" to icon,
                    "lastTimeUsed" to stats.lastTimeUsed,
                    "totalTimeInForeground" to stats.totalTimeInForeground
                )
            } catch (e: PackageManager.NameNotFoundException) {
                null
            } catch (e: Exception) {
                null
            }
        }
    }
    
    private fun drawableToByteArray(drawable: android.graphics.drawable.Drawable): ByteArray {
        var bitmap: Bitmap? = null
        var scaledBitmap: Bitmap? = null
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
            
            scaledBitmap = Bitmap.createScaledBitmap(bitmap, 72, 72, true)
            val stream = ByteArrayOutputStream()
            scaledBitmap.compress(Bitmap.CompressFormat.PNG, 80, stream)
            return stream.toByteArray()
        } catch (e: Exception) {
            return ByteArray(0)
        } finally {
            try {
                if (scaledBitmap != null && scaledBitmap != bitmap) {
                    scaledBitmap.recycle()
                }
                if (bitmap != null && drawable !is BitmapDrawable) {
                    bitmap.recycle()
                }
            } catch (e: Exception) {}
        }
    }

    fun getAppUsageHistory(packageName: String, installTime: Long? = null): List<Map<String, Any>> {
        if (!hasPermission()) return emptyList()

        val usageStatsManager = context.getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
        val calendar = Calendar.getInstance()
        val endTime = calendar.timeInMillis
        
        val startTime = if (installTime != null && installTime > 0) {
            installTime
        } else {
            calendar.add(Calendar.YEAR, -2)
            calendar.timeInMillis
        }

        val usageStatsList = usageStatsManager.queryUsageStats(
            UsageStatsManager.INTERVAL_DAILY,
            startTime,
            endTime
        )

        val dailyUsage = mutableMapOf<Long, Long>()

        for (stats in usageStatsList) {
            if (stats.packageName == packageName) {
                val cal = Calendar.getInstance()
                cal.timeInMillis = stats.firstTimeStamp
                cal.set(Calendar.HOUR_OF_DAY, 0)
                cal.set(Calendar.MINUTE, 0)
                cal.set(Calendar.SECOND, 0)
                cal.set(Calendar.MILLISECOND, 0)
                val dayStart = cal.timeInMillis

                dailyUsage[dayStart] = (dailyUsage[dayStart] ?: 0L) + stats.totalTimeInForeground
            }
        }

        val result = mutableListOf<Map<String, Any>>()
        val todayCal = Calendar.getInstance()
        
        val daysSinceStart = ((endTime - startTime) / (24 * 60 * 60 * 1000)).toInt().coerceIn(1, 730)

        for (i in 0 until daysSinceStart) {
            val dateCal = Calendar.getInstance()
            dateCal.timeInMillis = todayCal.timeInMillis
            dateCal.add(Calendar.DAY_OF_YEAR, -i)
            dateCal.set(Calendar.HOUR_OF_DAY, 0)
            dateCal.set(Calendar.MINUTE, 0)
            dateCal.set(Calendar.SECOND, 0)
            dateCal.set(Calendar.MILLISECOND, 0)
            val dayStart = dateCal.timeInMillis

            result.add(mapOf(
                "date" to dayStart,
                "usage" to (dailyUsage[dayStart] ?: 0L)
            ))
        }

        return result.reversed()
    }
}

