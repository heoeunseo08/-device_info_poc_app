package com.example.device_info_poc_app

import android.net.ConnectivityManager
import android.net.Network
import android.net.NetworkCapabilities
import android.os.BatteryManager
import android.os.Handler
import android.os.Looper
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, battryChannelName).setMethodCallHandler { call, result ->
            if (call.method == "getBatteryLevel") {
                val level = getBatteryLevel()
                result.success(level)
            }
        }

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, networkChannelName).setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) = startNetworkMonitor(events)
            override fun onCancel(arguments: Any?) = stopNetworkMonitor()
        })
    }

    fun startNetworkMonitor(events: EventChannel.EventSink?) {
        val connectivityManager = getSystemService(CONNECTIVITY_SERVICE) as ConnectivityManager

        fun pushCurrent() {
            Handler(Looper.getMainLooper()).post {
                events?.success(currentNetworkState(connectivityManager))
            }
        }

        networkCallback = object : ConnectivityManager.NetworkCallback() {
            override fun onAvailable(network: Network) = pushCurrent()
            override fun onLost(network: Network) = pushCurrent()
            override fun onCapabilitiesChanged(network: Network, networkCapabilities: NetworkCapabilities) = pushCurrent()
        }
        connectivityManager.registerDefaultNetworkCallback(networkCallback!!)
    }

    fun stopNetworkMonitor() {
        val connectivityManager = getSystemService(CONNECTIVITY_SERVICE) as ConnectivityManager

        networkCallback?.let { connectivityManager.unregisterNetworkCallback(it) }
        networkCallback = null
    }

    fun currentNetworkState(connectivityManager: ConnectivityManager): String {
        val network = connectivityManager.activeNetwork ?: return "offline"
        val caps = connectivityManager.getNetworkCapabilities(network) ?: return "offline"

        return when {
            caps.hasTransport(NetworkCapabilities.TRANSPORT_WIFI) -> "wifi"
            caps.hasTransport(NetworkCapabilities.TRANSPORT_CELLULAR) -> "mobile"
            else -> "wifi"
        }
    }

    fun getBatteryLevel(): Int? {
        val batteryManager = getSystemService(BATTERY_SERVICE) as BatteryManager
        val level = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
        return if (level in 0..100) level else null
    }

    companion object {
        val battryChannelName = "com.example.device_info_poc_app/battery"
        val networkChannelName = "com.example.device_info_poc_app/network"

        var networkCallback: ConnectivityManager.NetworkCallback? = null
    }
}
