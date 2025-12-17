package com.example.fokusku

import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "fokusku/focus_service"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        FocusState.myPackage = packageName

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->

                when (call.method) {

                    "startService" -> {
                        if (!Settings.canDrawOverlays(this)) {
                            result.error("NO_OVERLAY", "Overlay permission required", null)
                            return@setMethodCallHandler
                        }

                        FocusState.isActive = true       // menandakan overlay aktif
                        OverlayManager.sync(applicationContext) // tampilkan overlay
                        result.success(null)
                    }

                    "stopService" -> {
                        FocusState.isActive = false      // menandakan overlay tidak aktif
                        OverlayManager.hide()            // sembunyikan overlay
                        result.success(null)
                    }

                    else -> result.notImplemented()
                }
            }
    }
}
