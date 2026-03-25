package com.example.locked_in

import android.accessibilityservice.AccessibilityService
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.view.accessibility.AccessibilityEvent

class AppMonitoringService : AccessibilityService() {

    private lateinit var sharedPreferences: SharedPreferences
    private var lastPackageName: String? = null
    private var startTime: Long = 0

    override fun onServiceConnected() {
        super.onServiceConnected()
        sharedPreferences = getSharedPreferences("app_monitoring_prefs", Context.MODE_PRIVATE)
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        if (event == null || event.eventType != AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED) return

        val packageName = event.packageName?.toString() ?: return
        
        // Track usage for the previous app
        trackUsage()

        // Update tracking for the new app
        lastPackageName = packageName
        startTime = System.currentTimeMillis()

        // We don't want to block our own app
        if (packageName == "com.example.locked_in") return

        if (isAppBlocked(packageName)) {
            blockApp(packageName)
        }
    }

    private fun trackUsage() {
        val pkg = lastPackageName ?: return
        val duration = System.currentTimeMillis() - startTime
        if (duration <= 0) return

        val today = java.text.SimpleDateFormat("yyyyMMdd", java.util.Locale.getDefault()).format(java.util.Date())
        val usageKey = "usage_${today}_$pkg"
        val currentUsage = sharedPreferences.getLong(usageKey, 0L)
        sharedPreferences.edit().putLong(usageKey, currentUsage + duration).apply()
    }

    private fun isAppBlocked(packageName: String): Boolean {
        val blockedApps = sharedPreferences.getStringSet("blocked_apps", emptySet()) ?: emptySet()
        if (!blockedApps.contains(packageName)) return false

        // Check if there is an active lock period (Timestamp based)
        val lockUntil = sharedPreferences.getLong("lock_until_$packageName", 0L)
        if (System.currentTimeMillis() < lockUntil) return true

        // Check if explicit limit reached flag is set from Flutter side
        if (sharedPreferences.getBoolean("limit_reached_$packageName", false)) return true

        // Check Daily Limit (in milliseconds)
        val today = java.text.SimpleDateFormat("yyyyMMdd", java.util.Locale.getDefault()).format(java.util.Date())
        val usageKey = "usage_${today}_$packageName"
        val currentUsage = sharedPreferences.getLong(usageKey, 0L)
        val dailyLimit = sharedPreferences.getLong("daily_limit_$packageName", -1L)

        if (dailyLimit in 1..currentUsage) return true

        return false
    }

    private fun blockApp(packageName: String) {
        // Instantly force the system to go back/home to hide the blocked app splash screen
        performGlobalAction(GLOBAL_ACTION_HOME)

        // Then start overlay activity rapidly
        val overlayIntent = Intent(this, BlockingOverlayActivity::class.java).apply {
            putExtra("blocked_package", packageName)
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP)
            addFlags(Intent.FLAG_ACTIVITY_NO_ANIMATION)
            addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK)
        }
        startActivity(overlayIntent)
    }

    override fun onInterrupt() {}
}
