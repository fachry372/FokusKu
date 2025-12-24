package com.example.fokusku

import android.app.KeyguardManager
import android.content.Context
import android.os.Handler
import android.os.Looper
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    companion object {
        private const val CHANNEL = "focus_session"
        private const val LEAVE_DELAY = 700L 
    }

    private lateinit var channel: MethodChannel

    private var focusActive = false
    private var hasResumed = true
    private var leaveRunnable: Runnable? = null
    private val handler = Handler(Looper.getMainLooper())

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

    override fun onPause() {
        super.onPause()

        if (!focusActive) return

        hasResumed = false

        leaveRunnable = Runnable {
            if (hasResumed) return@Runnable
            if (!focusActive) return@Runnable

            val km = getSystemService(Context.KEYGUARD_SERVICE) as KeyguardManager
            if (km.isKeyguardLocked) return@Runnable

            channel.invokeMethod("user_left_app", null)
        }

        handler.postDelayed(leaveRunnable!!, LEAVE_DELAY)
    }

    override fun onResume() {
        super.onResume()

        hasResumed = true
        leaveRunnable?.let { handler.removeCallbacks(it) }
    }

    override fun onDestroy() {
        super.onDestroy()

        handler.removeCallbacksAndMessages(null)
        focusActive = false
    }
}
