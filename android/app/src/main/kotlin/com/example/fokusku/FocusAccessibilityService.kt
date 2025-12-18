package com.example.fokusku

import android.accessibilityservice.AccessibilityService
import android.app.usage.UsageEvents
import android.app.usage.UsageStatsManager
import android.content.Context
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.view.accessibility.AccessibilityEvent

class FocusAccessibilityService : AccessibilityService() {

    companion object {
        var instance: FocusAccessibilityService? = null
    }

    private val handler = Handler(Looper.getMainLooper())
    private var checkTask: Runnable? = null
    private val CHECK_DELAY = 500L 

    enum class UiState {
        SAFE,
        BLOCKED
    }

    private var uiState = UiState.SAFE

    override fun onServiceConnected() {
        super.onServiceConnected()
        instance = this
        Log.d("Forest", "Accessibility Service connected")
    }

    override fun onDestroy() {
        instance = null
        checkTask?.let { handler.removeCallbacks(it) }
        super.onDestroy()
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        if (!FocusState.isActive || event == null) return

        if (event.eventType == AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED) {
            scheduleForestCheck()
        }
    }

    override fun onInterrupt() {}

    private fun scheduleForestCheck() {
        checkTask?.let { handler.removeCallbacks(it) }

        checkTask = Runnable {

            val foregroundPkg = getRealForegroundApp(applicationContext)
            if (foregroundPkg == null) {
                Log.d("Forest", "Foreground app not detected")
                return@Runnable
            }

            val shouldBlock = foregroundPkg != packageName && !isIgnoredPackage(foregroundPkg)

            Log.d("Forest", "Foreground: $foregroundPkg | shouldBlock: $shouldBlock | uiState: $uiState")

            when (uiState) {
                UiState.SAFE -> {
                    if (shouldBlock) {
                        uiState = UiState.BLOCKED
                        OverlayManager.show(applicationContext) 
                        Log.d("Forest", "OVERLAY ON  | $foregroundPkg")
                    }
                }

                UiState.BLOCKED -> {
                    if (!shouldBlock) {
                        uiState = UiState.SAFE
                        OverlayManager.hide()
                        Log.d("Forest", "OVERLAY OFF | $foregroundPkg")
                    }
                }
            }
        }

        handler.postDelayed(checkTask!!, CHECK_DELAY)
    }

    private fun getRealForegroundApp(context: Context): String? {
        val usm = context.getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
        val end = System.currentTimeMillis()
        val begin = end - 1000 * 10 

        val events = usm.queryEvents(begin, end)
        var lastResumedPkg: String? = null

        val event = UsageEvents.Event()
        while (events.hasNextEvent()) {
            events.getNextEvent(event)
            if (event.eventType == UsageEvents.Event.ACTIVITY_RESUMED) {
                lastResumedPkg = event.packageName
            }
        }

        return lastResumedPkg
    }

    private fun isIgnoredPackage(pkg: String): Boolean {
       
        return pkg == "com.android.systemui" ||
               pkg.startsWith("android") ||
               pkg.startsWith("com.android.")
    }
}
