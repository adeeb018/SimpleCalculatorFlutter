package com.example.simplecalcflutter

import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    private val CHANNEL = "justaChannelName"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call: MethodCall, result: MethodChannel.Result ->
            when (call.method) {
                "myMethod" -> {
                    val nativeMethods = NativeMethods()
                    val message = nativeMethods.myMethod()
                    result.success(message)
                }

                else -> {
                    result.notImplemented()
                }
            }
        }

    }
}

class NativeMethods{
    fun myMethod(): String{
        return "hello from Kotlin!"
    }
}
