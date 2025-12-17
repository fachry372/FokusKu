package com.example.fokusku

import android.content.Context
import android.graphics.PixelFormat
import android.os.Build
import android.provider.Settings
import android.view.LayoutInflater
import android.view.View
import android.view.WindowManager

object OverlayManager {

    private var overlayView: View? = null
    private var isAdded = false
    private var isVisible = false

    fun sync(context: Context) {
        if (!FocusState.isActive || !FocusState.isInBlockedApp) {
            hide()
            return
        }
        show(context)
    }

    private fun show(context: Context) {
        if (!Settings.canDrawOverlays(context)) return

        ensureOverlay(context)

        if (!isVisible) {
            overlayView?.visibility = View.VISIBLE
            isVisible = true
        }
    }

    fun hide() {
        if (isVisible) {
            overlayView?.visibility = View.GONE
            isVisible = false
        }
    }

    private fun ensureOverlay(context: Context) {
        if (isAdded) return

        val wm = context.getSystemService(Context.WINDOW_SERVICE) as WindowManager

        overlayView = LayoutInflater.from(context)
            .inflate(R.layout.focus_overlay, null)
            .apply { visibility = View.GONE }

        val params = WindowManager.LayoutParams(
            WindowManager.LayoutParams.MATCH_PARENT,
            WindowManager.LayoutParams.MATCH_PARENT,
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
                WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
            else
                WindowManager.LayoutParams.TYPE_PHONE,
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or
                    WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN or
                    WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS,
            PixelFormat.TRANSLUCENT
        )

        wm.addView(overlayView, params)
        isAdded = true
    }
}
