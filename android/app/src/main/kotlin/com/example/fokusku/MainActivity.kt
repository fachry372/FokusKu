package com.example.fokusku

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.app.usage.UsageStatsManager
import android.content.Context
import android.content.Intent
import android.provider.Settings
import com.example.fokusku.FocusService

class MainActivity : FlutterActivity() {

    private val CHANNEL = "fokusku/usage"
    private val SERVICE_CHANNEL = "fokusku/focus_service"
    private val ACCESS_CHANNEL = "fokusku/accessibility"


    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {

                "getForegroundApp" -> {
                    result.success(getForegroundApp())
                }

                "getLauncherPackage" -> {
                    result.success(getLauncherPackage())
                }

                "openUsageSettings" -> {
                    startActivity(
                        Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS)
                    )
                    result.success(null)
                }

                else -> result.notImplemented()
            }
        }

       
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            SERVICE_CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {

                "startService" -> {
                    startService(Intent(this, FocusService::class.java))
                    result.success(null)
                }

                "stopService" -> {
                    stopService(Intent(this, FocusService::class.java))
                    result.success(null)
                }

                else -> result.notImplemented()
            }
        }

        MethodChannel(
    flutterEngine.dartExecutor.binaryMessenger,
    ACCESS_CHANNEL
    ).also {
        FocusAccessibilityService.channel = it
    }

    

    }

    

   
    private fun getForegroundApp(): String? {
        val usm = getSystemService(Context.USAGE_STATS_SERVICE)
                as UsageStatsManager

        val time = System.currentTimeMillis()
        val stats = usm.queryUsageStats(
            UsageStatsManager.INTERVAL_DAILY,
            time - 10_000,
            time
        )

        if (stats.isNullOrEmpty()) return null
        return stats.maxByOrNull { it.lastTimeUsed }?.packageName
    }

    private fun getLauncherPackage(): String? {
        val intent = Intent(Intent.ACTION_MAIN).apply {
            addCategory(Intent.CATEGORY_HOME)
        }

        val resolveInfo = packageManager.resolveActivity(intent, 0)
        return resolveInfo?.activityInfo?.packageName
    }
}
