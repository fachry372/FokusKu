package com.example.fokusku

object FocusState {
    var isActive = false        // apakah service aktif
    var isInBlockedApp = false  // apakah user sedang di app terblokir
    var myPackage = "com.example.fokusku"

    var isFocusSession = false  // <--- baru: apakah sesi fokus sedang berjalan
}
