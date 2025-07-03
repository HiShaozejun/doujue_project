package com.kmsp.djqs

import android.app.Application
import io.flutter.app.FlutterApplication
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor

class DJApplication : FlutterApplication() {

    override fun onCreate() {
        super.onCreate()
        // 这里可以初始化第三方 SDK 或做一些全局配置
    }
}



