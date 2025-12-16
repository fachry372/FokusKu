package com.example.fokusku

import android.accessibilityservice.AccessibilityService
import android.view.accessibility.AccessibilityEvent
import io.flutter.plugin.common.MethodChannel

class FocusAccessibilityService : AccessibilityService() {

    companion object {
        var channel: MethodChannel? = null
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        if (event == null) return

        if (event.eventType == AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED) {
            val packageName = event.packageName?.toString() ?: return

            channel?.invokeMethod(
                "onAppChanged",
                packageName
            )
        }
    }

    override fun onInterrupt() {}
}
