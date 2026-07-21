package com.lockedinlimited.locked_in

import android.content.Context
import android.content.Intent
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.lockedinlimited.locked_in/monitoring"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startService" -> {
                    val intent = Intent(this, AppMonitoringForegroundService::class.java)
                    if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
                        startForegroundService(intent)
                    } else {
                        startService(intent)
                    }
                    result.success(true)
                }
                "stopService" -> {
                    val intent = Intent(this, AppMonitoringForegroundService::class.java)
                    stopService(intent)
                    result.success(true)
                }
                "isAccessibilityEnabled" -> {
                    result.success(isAccessibilityServiceEnabled())
                }
                "openAccessibilitySettings" -> {
                    val intent = Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS)
                    startActivity(intent)
                    result.success(true)
                }
                "updateBlockedApps" -> {
                    val blockedApps = call.argument<List<String>>("blockedApps") ?: emptyList()
                    val prefs = getSharedPreferences("app_monitoring_prefs", Context.MODE_PRIVATE)
                    prefs.edit().putStringSet("blocked_apps", blockedApps.toSet()).apply()
                    result.success(true)
                }
                "updateAppLimitStatus" -> {
                    val packageName = call.argument<String>("packageName") ?: ""
                    val isLimitReached = call.argument<Boolean>("isLimitReached") ?: false
                    
                    val prefs = getSharedPreferences("app_monitoring_prefs", Context.MODE_PRIVATE)
                    prefs.edit().putBoolean("limit_reached_$packageName", isLimitReached).apply()
                    result.success(true)
                }
                "updateAppLockUntil" -> {
                    val packageName = call.argument<String>("packageName") ?: ""
                    val lockUntil = call.argument<Long>("lockUntil") ?: 0L
                    
                    val prefs = getSharedPreferences("app_monitoring_prefs", Context.MODE_PRIVATE)
                    prefs.edit().putLong("lock_until_$packageName", lockUntil).apply()
                    result.success(true)
                }
                "getInstalledApps" -> {
                    Thread {
                        try {
                            val pm = packageManager
                            val mainIntent = Intent(Intent.ACTION_MAIN, null)
                            mainIntent.addCategory(Intent.CATEGORY_LAUNCHER)
                            val resolvedInfos = pm.queryIntentActivities(mainIntent, 0)
                            val appList = ArrayList<Map<String, Any>>()
                            for (resolvedInfo in resolvedInfos) {
                                val packageName = resolvedInfo.activityInfo.packageName
                                try {
                                    val appInfo = pm.getApplicationInfo(packageName, 0)
                                    
                                    // Check if it's a system app
                                    val isSystemApp = (appInfo.flags and android.content.pm.ApplicationInfo.FLAG_SYSTEM) != 0
                                    
                                    if (!isSystemApp) {
                                        val icon = resolvedInfo.loadIcon(pm)
                                        val bitmap = drawableToBitmap(icon)
                                        val stream = java.io.ByteArrayOutputStream()
                                        bitmap.compress(android.graphics.Bitmap.CompressFormat.PNG, 100, stream)
                                        val byteArray = stream.toByteArray()
                                        
                                        val appData = mutableMapOf<String, Any>()
                                        appData["appName"] = resolvedInfo.loadLabel(pm).toString()
                                        appData["packageName"] = packageName
                                        appData["appIcon"] = byteArray
                                        appList.add(appData)
                                    }
                                } catch (e: Exception) {
                                    e.printStackTrace()
                                }
                            }
                            runOnUiThread {
                                result.success(appList)
                            }
                        } catch (e: Exception) {
                            runOnUiThread {
                                result.error("ERROR", e.message, null)
                            }
                        }
                    }.start()
                }
                "getAppUsageStats" -> {
                    val pm = packageManager
                    val prefs = getSharedPreferences("app_monitoring_prefs", Context.MODE_PRIVATE)
                    val today = java.text.SimpleDateFormat("yyyyMMdd", java.util.Locale.getDefault()).format(java.util.Date())
                    val date = call.argument<String>("date") ?: today
                    val trackedPackages = call.argument<List<String>>("trackedPackages") ?: emptyList()
                    
                    val allPrefs = prefs.all
                    val usageMap = mutableMapOf<String, MutableMap<String, Any>>()
                    
                    for ((key, value) in allPrefs) {
                        if (key.startsWith("usage_$date") || key.startsWith("opens_$date")) {
                            val parts = key.split("_")
                            if (parts.size < 3) continue
                            
                            val pkg = parts.subList(2, parts.size).joinToString("_")
                            val type = parts[0] // usage or opens
                            
                            // Skip our own app
                            if (pkg == packageName) continue

                            // If trackedPackages is provided, only include those
                            if (trackedPackages.isNotEmpty() && !trackedPackages.contains(pkg)) {
                                continue
                            }
                            
                            if (!usageMap.containsKey(pkg)) {
                                try {
                                    val appInfo = pm.getApplicationInfo(pkg, 0)
                                    // Skip system apps
                                    val isSystemApp = (appInfo.flags and android.content.pm.ApplicationInfo.FLAG_SYSTEM) != 0
                                    if (isSystemApp) continue

                                    val appData = mutableMapOf<String, Any>(
                                        "packageName" to pkg,
                                        "appName" to pm.getApplicationLabel(appInfo).toString(),
                                        "usageMs" to 0L,
                                        "opens" to 0L
                                    )
                                    
                                    // Load Icon - only for current day or small lists to avoid memory pressure
                                    // For simplicity, we always load it since trackedPackages is usually small.
                                    try {
                                        val icon = pm.getApplicationIcon(pkg)
                                        val bitmap = drawableToBitmap(icon)
                                        val stream = java.io.ByteArrayOutputStream()
                                        bitmap.compress(android.graphics.Bitmap.CompressFormat.PNG, 100, stream)
                                        appData["appIcon"] = stream.toByteArray()
                                    } catch (e: Exception) {
                                        // Ignore icon error
                                    }
                                    
                                    usageMap[pkg] = appData
                                } catch (e: Exception) {
                                    // Skip if app not found/accessible
                                    continue
                                }
                            }
                            
                            if (type == "usage") {
                                usageMap[pkg]?.set("usageMs", value as Long)
                            } else if (type == "opens") {
                                usageMap[pkg]?.set("opens", value as Long)
                            }
                        }
                    }
                    
                    result.success(usageMap.values.toList())
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun drawableToBitmap(drawable: android.graphics.drawable.Drawable): android.graphics.Bitmap {
        if (drawable is android.graphics.drawable.BitmapDrawable) {
            return drawable.bitmap
        }
        val bitmap = android.graphics.Bitmap.createBitmap(
            drawable.intrinsicWidth.coerceAtLeast(1),
            drawable.intrinsicHeight.coerceAtLeast(1),
            android.graphics.Bitmap.Config.ARGB_8888
        )
        val canvas = android.graphics.Canvas(bitmap)
        drawable.setBounds(0, 0, canvas.width, canvas.height)
        drawable.draw(canvas)
        return bitmap
    }

    private fun isAccessibilityServiceEnabled(): Boolean {
        val ams = getSystemService(Context.ACCESSIBILITY_SERVICE) as android.view.accessibility.AccessibilityManager
        val enabledServices = ams.getEnabledAccessibilityServiceList(android.accessibilityservice.AccessibilityServiceInfo.FEEDBACK_ALL_MASK)
        for (service in enabledServices) {
            if (service.resolveInfo.serviceInfo.packageName == packageName) {
                return true
            }
        }
        return false
    }
}
