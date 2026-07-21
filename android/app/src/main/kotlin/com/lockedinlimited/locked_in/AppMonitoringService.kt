package com.lockedinlimited.locked_in

import android.accessibilityservice.AccessibilityService
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.SharedPreferences
import android.view.accessibility.AccessibilityEvent

class AppMonitoringService : AccessibilityService() {

    private lateinit var sharedPreferences: SharedPreferences
    private var lastPackageName: String? = null
    private var startTime: Long = 0
    private var launcherPackageName: String? = null

    private val screenReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            if (intent?.action == Intent.ACTION_SCREEN_OFF) {
                trackUsage()
                lastPackageName = null
                startTime = 0L
            }
        }
    }

    override fun onCreate() {
        super.onCreate()
        val filter = IntentFilter().apply {
            addAction(Intent.ACTION_SCREEN_OFF)
        }
        registerReceiver(screenReceiver, filter)
    }

    override fun onDestroy() {
        try {
            unregisterReceiver(screenReceiver)
        } catch (e: Exception) {
            e.printStackTrace()
        }
        super.onDestroy()
    }

    override fun onServiceConnected() {
        super.onServiceConnected()
        sharedPreferences = getSharedPreferences("app_monitoring_prefs", Context.MODE_PRIVATE)
        try {
            val intent = Intent(Intent.ACTION_MAIN).apply {
                addCategory(Intent.CATEGORY_HOME)
            }
            val resolveInfo = packageManager.resolveActivity(intent, 0)
            launcherPackageName = resolveInfo?.activityInfo?.packageName
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    private fun trackUsage() {
        val pkg = lastPackageName ?: return
        if (startTime == 0L) return
        val duration = System.currentTimeMillis() - startTime
        
        val today = java.text.SimpleDateFormat("yyyyMMdd", java.util.Locale.getDefault()).format(java.util.Date())
        val usageKey = "usage_${today}_$pkg"

        val editor = sharedPreferences.edit()
        if (duration > 0) {
            val currentUsage = sharedPreferences.getLong(usageKey, 0L)
            editor.putLong(usageKey, currentUsage + duration)
        }
        editor.apply()
        startTime = 0L
    }

    private fun isSystemApp(packageName: String): Boolean {
        return try {
            val pm = packageManager
            val appInfo = pm.getApplicationInfo(packageName, 0)
            (appInfo.flags and android.content.pm.ApplicationInfo.FLAG_SYSTEM) != 0
        } catch (e: Exception) {
            true
        }
    }

    private fun isInputMethodOrSystemUI(packageName: String): Boolean {
        val lowerPkg = packageName.lowercase()
        return lowerPkg == "com.android.systemui" || 
               lowerPkg == "android" ||
               lowerPkg.contains("inputmethod") || 
               lowerPkg.contains("keyboard") || 
               lowerPkg.contains("ime")
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        if (event == null || event.eventType != AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED) return

        val packageName = event.packageName?.toString() ?: return
        
        if (packageName == "com.lockedinlimited.locked_in") {
            trackUsage()
            return
        }

        // Ignore keyboard, input methods, and System UI overlays so typing time is credited to the active app
        if (isInputMethodOrSystemUI(packageName)) {
            return
        }

        // If it's a launcher app, treat as home screen
        if (packageName == launcherPackageName) {
            trackUsage()
            lastPackageName = null
            startTime = 0L
            return
        }

        if (isSystemApp(packageName)) {
            trackUsage()
            lastPackageName = null
            startTime = 0L
            return
        }

        // User App
        if (packageName != lastPackageName) {
            trackUsage()
            
            val today = java.text.SimpleDateFormat("yyyyMMdd", java.util.Locale.getDefault()).format(java.util.Date())
            val opensKey = "opens_${today}_$packageName"
            val currentOpens = sharedPreferences.getLong(opensKey, 0L)
            sharedPreferences.edit().putLong(opensKey, currentOpens + 1).apply()
            
            lastPackageName = packageName
            startTime = System.currentTimeMillis()
        } else {
            if (startTime == 0L) {
                startTime = System.currentTimeMillis()
            }
        }

        if (isAppBlocked(packageName)) {
            blockApp(packageName)
        }
    }

    private fun isAppBlocked(packageName: String): Boolean {
        val blockedApps = sharedPreferences.getStringSet("blocked_apps", emptySet()) ?: emptySet()
        if (!blockedApps.contains(packageName)) return false

        val lockUntil = sharedPreferences.getLong("lock_until_$packageName", 0L)
        if (System.currentTimeMillis() < lockUntil) return true

        if (sharedPreferences.getBoolean("limit_reached_$packageName", false)) return true

        val today = java.text.SimpleDateFormat("yyyyMMdd", java.util.Locale.getDefault()).format(java.util.Date())
        val usageKey = "usage_${today}_$packageName"
        val currentUsage = sharedPreferences.getLong(usageKey, 0L)
        val dailyLimit = sharedPreferences.getLong("daily_limit_$packageName", -1L)

        if (dailyLimit in 1..currentUsage) return true

        return false
    }

    private fun blockApp(packageName: String) {
        val overlayIntent = Intent(this, BlockingOverlayActivity::class.java).apply {
            putExtra("blocked_package", packageName)
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP)
            addFlags(Intent.FLAG_ACTIVITY_NO_ANIMATION)
        }
        startActivity(overlayIntent)
    }

    override fun onInterrupt() {}
}
