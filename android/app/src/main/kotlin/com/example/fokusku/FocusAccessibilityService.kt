package com.example.fokusku

import android.accessibilityservice.AccessibilityService
import android.content.Intent
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.view.accessibility.AccessibilityEvent

class FocusAccessibilityService : AccessibilityService() {

    companion object {
        var instance: FocusAccessibilityService? = null
    }

    private val handler = Handler(Looper.getMainLooper())
    private var windowReadyTask: Runnable? = null
    private val WINDOW_READY_DELAY = 300L

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
    if (!FocusState.isActive || event == null) return

    val pkg = event.packageName?.toString() ?: return
    val homePackage = getDefaultHomePackage()

    
    if (isIgnoredPackage(pkg)) {
        cancelPending()
        forceHide()
        return
    }

    
    // HANYA launcher default yang dianggap HOME
if (isSystemHome(pkg)) {
    cancelPending()
    forceHide()
    return
}


    val className = event.className?.toString() ?: ""

    if (className.contains("VRI") ||
        className.contains("SurfaceView") ||
        className.contains("DecorView") ||
        className.contains("FrameLayout") ||
        className.contains("Popup") ||
        className.contains("Toast")
    ) return

    when (event.eventType) {
        AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED,
        AccessibilityEvent.TYPE_VIEW_CLICKED,
        AccessibilityEvent.TYPE_WINDOW_CONTENT_CHANGED -> {
            scheduleOverlayCheck(pkg, homePackage, className)
        }
    }
}

private fun scheduleOverlayCheck(pkg: String, homePackage: String?, className: String) {

    windowReadyTask?.let { handler.removeCallbacks(it) }

    windowReadyTask = Runnable {

      val isBlocked =
    pkg != FocusState.myPackage &&
    !isSystemHome(pkg) &&
    !isIgnoredPackage(pkg)


        if (FocusState.isInBlockedApp != isBlocked) {
            FocusState.isInBlockedApp = isBlocked

            if (isBlocked) {
                OverlayManager.sync(applicationContext)
                Log.d(
                    "FocusService",
                    "Overlay DITAMPILKAN | Aplikasi dibuka: $pkg | Activity: $className"
                )
            } else {
                OverlayManager.hide()
                Log.d(
                    "FocusService",
                    "Overlay DISEMBUNYIKAN | Kembali ke aplikasi sendiri / Home"
                )
            }
        }
    }

    handler.postDelayed(windowReadyTask!!, WINDOW_READY_DELAY)
}


private fun isSystemHome(pkg: String): Boolean {
    val home = getDefaultHomePackage()
    return pkg == home
}



    private fun isIgnoredPackage(pkg: String): Boolean {
    return pkg == "com.android.systemui" ||
           pkg.startsWith("com.android.") ||
           pkg.startsWith("android")
}


  

    private fun cancelPending() {
    windowReadyTask?.let {
        handler.removeCallbacks(it)
        windowReadyTask = null
    }
}

private fun forceHide() {
    FocusState.isInBlockedApp = false
    OverlayManager.hide()
}


    private fun getDefaultHomePackage(): String? {
        val intent = Intent(Intent.ACTION_MAIN).addCategory(Intent.CATEGORY_HOME)
        val resolveInfo = packageManager.resolveActivity(intent, 0)
        return resolveInfo?.activityInfo?.packageName
    }

    override fun onInterrupt() {}
}
