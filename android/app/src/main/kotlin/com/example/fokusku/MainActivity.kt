package com.example.fokusku

import android.app.AppOpsManager
import android.app.usage.UsageEvents
import android.app.usage.UsageStatsManager
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.Handler
import android.os.Looper
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    companion object {
        private const val CHANNEL = "focus_session"
        private const val CHECK_INTERVAL = 1000L
        private const val GRACE_PERIOD = 3000L // 3 detik aman saat start
    }

    private lateinit var channel: MethodChannel

    private var focusActive = false
    private var sessionStartTime = 0L

    private val handler = Handler(Looper.getMainLooper())
    private var monitorRunnable: Runnable? = null

    // ==============================
    // Flutter Channel
    // ==============================
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        channel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        )

        channel.setMethodCallHandler { call, result ->
            when (call.method) {

                // Dipanggil Flutter saat sesi fokus mulai / selesai
                "setFocusActive" -> {
                    focusActive = call.arguments as? Boolean ?: false

                    if (focusActive) {
                        sessionStartTime = System.currentTimeMillis()
                        startMonitoring()
                    } else {
                        stopMonitoring()
                    }

                    result.success(null)
                }

                // Cek izin Usage Stats
                "cekUsageIzin" -> {
                    result.success(hasUsagePermission())
                }

                // Buka halaman izin Usage Stats
                "openUsageSettings" -> {
                    startActivity(
                        Intent(android.provider.Settings.ACTION_USAGE_ACCESS_SETTINGS)
                    )
                    result.success(null)
                }

                else -> result.notImplemented()
            }
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        stopMonitoring()
        handler.removeCallbacksAndMessages(null)
        focusActive = false
    }

    // ==============================
    // SINGLE EXIT POINT (ANTI DOBEL)
    // ==============================
    private fun triggerUserLeft() {
        if (!focusActive) return

        focusActive = false
        stopMonitoring()
        channel.invokeMethod("user_left_app", null)
    }

    // ==============================
    // MONITORING LOGIC
    // ==============================
    private fun startMonitoring() {
        if (!hasUsagePermission()) return
        if (monitorRunnable != null) return

        val usageStatsManager =
            getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager

        monitorRunnable = object : Runnable {
            override fun run() {
                if (!focusActive) return

                // 🔒 Grace period (hindari event lama)
                if (System.currentTimeMillis() - sessionStartTime < GRACE_PERIOD) {
                    handler.postDelayed(this, CHECK_INTERVAL)
                    return
                }

                val endTime = System.currentTimeMillis()
                val startTime = endTime - 3000

                val events = usageStatsManager.queryEvents(startTime, endTime)
                val event = UsageEvents.Event()

                while (events.hasNextEvent()) {
                    events.getNextEvent(event)

                    if (event.eventType == UsageEvents.Event.MOVE_TO_FOREGROUND) {
                        if (event.packageName != packageName) {
                            triggerUserLeft()
                            return
                        }
                    }
                }

                handler.postDelayed(this, CHECK_INTERVAL)
            }
        }

        // 🔥 START MONITORING
        handler.post(monitorRunnable!!)
    }

    private fun stopMonitoring() {
        monitorRunnable?.let { handler.removeCallbacks(it) }
        monitorRunnable = null
    }

    // ==============================
    // PERMISSION CHECK
    // ==============================
    private fun hasUsagePermission(): Boolean {
        val appOps = getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager

        val mode = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            appOps.unsafeCheckOpNoThrow(
                AppOpsManager.OPSTR_GET_USAGE_STATS,
                android.os.Process.myUid(),
                packageName
            )
        } else {
            appOps.checkOpNoThrow(
                AppOpsManager.OPSTR_GET_USAGE_STATS,
                android.os.Process.myUid(),
                packageName
            )
        }

        return mode == AppOpsManager.MODE_ALLOWED
    }
}
