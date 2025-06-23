package com.example.nikon_detector_app // Pastikan package name ini sesuai dengan proyek Anda

import android.content.Context
import android.hardware.usb.UsbManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    // Nama channel ini harus SAMA PERSIS dengan yang di Dart
    private val CHANNEL = "com.example.nikon_detector/usb"
    
    // ID Vendor untuk semua perangkat Nikon adalah 1200 (dalam desimal)
    private val NIKON_VENDOR_ID = 1200

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            // Ini adalah bagian yang akan dieksekusi saat Dart memanggil sebuah metode
            call, result ->
            if (call.method == "getUsbDeviceStatus") {
                val status = getDeviceStatus()
                result.success(status)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getDeviceStatus(): String {
        val usbManager = getSystemService(Context.USB_SERVICE) as UsbManager
        val deviceList = usbManager.deviceList

        if (deviceList.isEmpty()) {
            return "Tidak ada perangkat USB terhubung."
        }

        for (device in deviceList.values) {
            if (device.vendorId == NIKON_VENDOR_ID) {
                // Sukses! Kita menemukan perangkat dengan Vendor ID milik Nikon.
                return "SUKSES! Kamera Nikon terdeteksi.\nNama Perangkat: ${device.deviceName}"
            }
        }

        return "Kamera Nikon tidak ditemukan di antara perangkat yang terhubung."
    }
}
