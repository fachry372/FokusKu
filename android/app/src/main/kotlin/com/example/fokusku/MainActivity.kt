package com.example.fokusku

import android.os.Bundle
import android.app.KeyguardManager
import android.content.Context
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    companion object {
        private const val CHANNEL = "focus_session"
    }

    private lateinit var channel: MethodChannel
    private var focusActive: Boolean = false

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        channel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        )

        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "setFocusActive" -> {
                    focusActive = call.arguments as? Boolean ?: false
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    
    override fun onUserLeaveHint() {
        super.onUserLeaveHint()
        handleUserLeftApp()
    }

    override fun onPause() {
        super.onPause()
        handleUserLeftApp()
    }

    private fun handleUserLeftApp() {
        if (!focusActive) return

      
        val km = getSystemService(Context.KEYGUARD_SERVICE) as KeyguardManager
        if (km.isKeyguardLocked) return

        
        channel.invokeMethod("user_left_app", null)
    }

    override fun onDestroy() {
        super.onDestroy()
        focusActive = false
    }
}
