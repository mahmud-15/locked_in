package com.example.locked_in

import android.app.Activity
import android.os.Bundle
import android.widget.Button
import android.widget.TextView
import android.content.Intent

class BlockingOverlayActivity : Activity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_blocking_overlay)

        val packageName = intent.getStringExtra("blocked_package") ?: ""
        val messageTextView = findViewById<TextView>(R.id.blocked_message)
        
        var appName = packageName
        try {
            if (packageName.isNotEmpty()) {
                val pm = packageManager
                val appInfo = pm.getApplicationInfo(packageName, 0)
                appName = pm.getApplicationLabel(appInfo).toString()
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
        
        messageTextView.text = "You've temporarily locked '$appName' to stay focused on your goals."

        findViewById<Button>(R.id.ok_button).setOnClickListener {

            goToHomeScreen()
        }
    }

    private fun goToHomeScreen() {
        val homeIntent = Intent(Intent.ACTION_MAIN)
        homeIntent.addCategory(Intent.CATEGORY_HOME)
        homeIntent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
        startActivity(homeIntent)
        finish()
    }

    override fun onBackPressed() {
        goToHomeScreen()
    }
}
