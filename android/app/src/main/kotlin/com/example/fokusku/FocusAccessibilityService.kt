package com.example.fokusku

import android.accessibilityservice.AccessibilityService
import android.os.Handler
import android.os.Looper
import android.view.accessibility.AccessibilityEvent

class FocusAccessibilityService : AccessibilityService() {

    companion object {
        var instance: FocusAccessibilityService? = null
    }

    private val handler = Handler(Looper.getMainLooper())
    private var windowReadyTask: Runnable? = null
    private var lastPackage: String? = null

    private val WINDOW_READY_DELAY = 500L // Grace period untuk window stabil

    override fun onServiceConnected() {
        super.onServiceConnected()
        instance = this
    }

    override fun onDestroy() {
        instance = null
        windowReadyTask?.let { handler.removeCallbacks(it) }
        super.onDestroy()
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        if (!FocusState.isActive) return
        if (event == null) return

        val pkg = event.packageName?.toString() ?: return
        val className = event.className?.toString() ?: ""

        // 🚫 Abaikan dummy window
        if (className.contains("VRI") ||
            className.contains("SurfaceView") ||
            className.contains("DecorView") ||
            className.contains("FrameLayout") ||
            className.contains("Popup") ||
            className.contains("Toast")
        ) return

        when (event.eventType) {
            AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED -> {
                if (pkg == FocusState.myPackage) {
                 
                    FocusState.isInBlockedApp = false
                    OverlayManager.hide()
                } else if (!isSafeZone(pkg) && lastPackage != pkg) {
                    
                    lastPackage = pkg
                    FocusState.isInBlockedApp = true
                    OverlayManager.sync(applicationContext)
                } else {
                   
                    lastPackage = pkg
                }
            }

            AccessibilityEvent.TYPE_VIEW_CLICKED,
            AccessibilityEvent.TYPE_WINDOW_CONTENT_CHANGED -> {
                if (pkg == FocusState.myPackage) {
                 
                    FocusState.isInBlockedApp = false
                    OverlayManager.hide()
                } else if (!isSafeZone(pkg)) {
             FocusState.isInBlockedApp = true
                    OverlayManager.sync(applicationContext)
                }
            }
        }
    }

    private fun scheduleOverlayCheck(pkg: String) {
        windowReadyTask?.let { handler.removeCallbacks(it) }
        windowReadyTask = Runnable {
            val newBlocked = !isSafeZone(pkg)
            if (FocusState.isInBlockedApp != newBlocked) {
                FocusState.isInBlockedApp = newBlocked
                OverlayManager.sync(applicationContext)
            }
        }
        handler.postDelayed(windowReadyTask!!, WINDOW_READY_DELAY)
    }

    private fun isSafeZone(pkg: String): Boolean {
        return isMyApp(pkg) || isHome(pkg)
    }

    private fun isMyApp(pkg: String): Boolean {
        return pkg == FocusState.myPackage
    }

    private fun isHome(pkg: String): Boolean {
        val p = pkg.lowercase()
        return p.contains("launcher")
    }

    override fun onInterrupt() {}
}
