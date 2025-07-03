package com.morbit.tencent_map_flutter

import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin


import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.content.pm.PackageManager
import android.graphics.Color
import android.os.Build
import android.os.Looper
import androidx.core.app.NotificationCompat
import com.tencent.map.geolocation.TencentLocation
import com.tencent.map.geolocation.TencentLocationListener
import com.tencent.map.geolocation.TencentLocationManager
import com.tencent.map.geolocation.TencentLocationRequest

import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import android.util.Log

import com.morbit.tencent_map_flutter.models.*
import com.morbit.tencent_map_flutter.models.InitOptions
import com.morbit.tencent_map_flutter.models.NotificationIconData
import com.morbit.tencent_map_flutter.models.NotificationOptions
import com.morbit.tencent_map_flutter.models.getBoolean
import com.morbit.tencent_map_flutter.models.getMap


class TencentMapPlugin : FlutterPlugin, MethodCallHandler, TencentLocationListener {
    private lateinit var channel: MethodChannel
    private lateinit var applicationContext: Context

    private lateinit var locationManager: TencentLocationManager
    private lateinit var tencentLocationRequest: TencentLocationRequest
    private var resultList: ArrayList<Result> = arrayListOf()
    private var isListenLocationUpdates = false

    private var isCreateChannel = false
    private var notificationManager: NotificationManager? = null


    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        binding.platformViewRegistry.registerViewFactory(
            "tencent_map_flutter",
            TencentMapFactory(binding)
        )

        TencentMapSdkApi.setup(binding)

        channel = MethodChannel(binding.binaryMessenger, "flutter_tencent_lbs_plugin")
        channel.setMethodCallHandler(this)

        applicationContext = binding.applicationContext
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "setUserAgreePrivacy" -> {
                TencentLocationManager.setUserAgreePrivacy(true)
            }

            "init" -> {
                initTencentLBS(call, result)
            }

            "getLocationOnce" -> {
                getLocationOnce(result)
            }

            "getLocation" -> {
                this.resultList.add(result)
                getLocation(call)
            }

            "stopLocation" -> {
                stopLocation(result)
            }

            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onLocationChanged(location: TencentLocation?, error: Int, reason: String?) {
        if (error == TencentLocation.ERROR_OK) {
            val result = HashMap<String, Any?>()
            result["name"] = location?.name
            result["latitude"] = location?.latitude
            result["longitude"] = location?.longitude
            result["address"] = location?.address
            result["city"] = location?.city
            result["province"] = location?.province
            result["area"] = location?.district
            result["cityCode"] = location?.cityCode
            result["code"] = TencentLocation.ERROR_OK
            Log.d("linda--------onLocationChanged", "Latitude: ${location?.latitude},Longitude: ${location?.longitude}")
            Log.d("linda--------onLocationChanged", "精度=${location?.accuracy}, 来源=${location?.provider}, 城市=${location?.city}, citycode=${location?.cityCode}")
            sendLocationToFlutter(result)
        } else {
            sendLocationToFlutter(createErrorResult(error), false)
        }
    }

    override fun onStatusUpdate(name: String?, status: Int, desc: String?) {
        val result = HashMap<String, Any?>()
        result["name"] = name
        result["status"] = status
        channel.invokeMethod("receiveStatus", result)
    }

    private fun initTencentLBS(call: MethodCall, result: Result) {
        val args = call.arguments as Map<*, *>?
        locationManager = TencentLocationManager.getInstance(applicationContext)
        tencentLocationRequest = TencentLocationRequest.create()

        val options = InitOptions.getData(locationManager, tencentLocationRequest, args)
        locationManager.coordinateType =options.coordinateType
        locationManager.setMockEnable(options.mockEnable)
        locationManager.triggerCodeGuarder(true)
        tencentLocationRequest.requestLevel = options.requestLevel
        tencentLocationRequest.locMode = options.locMode
        tencentLocationRequest.isAllowGPS = options.isAllowGPS
        tencentLocationRequest.isIndoorLocationMode = options.isIndoorLocationMode
        tencentLocationRequest.isGpsFirst = options.isGpsFirst
        tencentLocationRequest.gpsFirstTimeOut = options.gpsFirstTimeOut
        Log.d("linda--------InitOptions", "coordinateType: ${locationManager.coordinateType}")
        Log.d("linda--------InitOptions", "requestLevel: ${tencentLocationRequest.requestLevel}")

        result.success(true)
    }

    private fun getLocationOnce(result: Result) {
        val error = locationManager.requestSingleFreshLocation(null, this, Looper.getMainLooper())
        if (error == TencentLocation.ERROR_OK) {
            resultList.add(result)
        } else {
            val errResult = createErrorResult(error)
            sendErrorLocationToFlutter(result, errResult)
            notifyLocationRecipients(errResult)
        }
    }


    private fun getLocation(call: MethodCall) {
        val args = call.arguments as Map<*, *>?
        val interval: Long = getInt(args, "interval")?.toLong() ?: (1000 * 15)
        Log.d("linda--------getLocation", "interval: ${interval}")
        val backgroundLocation = getBoolean(args, "backgroundLocation") ?: false
        Log.d("linda--------getLocation", "backgroundLocation: ${backgroundLocation}")

        if (!isListenLocationUpdates) {
            isListenLocationUpdates = true
            tencentLocationRequest.interval = interval
            if (backgroundLocation) {
                val options =
                    NotificationOptions.getData(getMap(args, "androidNotificationOptions"))
                Log.d("linda--------androidNotificationOptions", "id: ${options.id}")

                locationManager.enableForegroundLocation(options.id, buildNotification(options))
                locationManager.requestLocationUpdates(tencentLocationRequest, this, Looper.getMainLooper())
            }
        }
    }

    private fun stopLocation(result: Result) {
        Log.d("linda--------stopLocation","")
        isListenLocationUpdates = false
        resultList.clear()
        locationManager.disableForegroundLocation(true)
        locationManager.removeUpdates(this)
        result.success(true)
    }

    private fun sendErrorLocationToFlutter(result: Result?, value: Any) {
        result?.error((value as HashMap<*, *>)["code"].toString(), "Err", value)
    }

    private fun sendSuccessLocationToFlutter(result: Result?, value: Any) {
        result?.success(value)
    }

    private fun sendLocationToFlutter(value: Any, isSuccess: Boolean = true) {
        for (result in resultList.iterator()) {
            if (isSuccess) {
                sendSuccessLocationToFlutter(result, value)
            } else {
                sendErrorLocationToFlutter(result, value)
            }
        }
        resultList.clear()
        notifyLocationRecipients(value)
    }

    private fun createErrorResult(code: Int): HashMap<String, Any> {
        val result = HashMap<String, Any>()
        result["code"] = code
        return result
    }

    private fun notifyLocationRecipients(value: Any) {
        channel.invokeMethod("receiveLocation", value)
    }

    private fun getIconResIdFromIconData(iconData: NotificationIconData): Int {
        val resType = iconData.resType
        val resPrefix = iconData.resPrefix
        val name = iconData.name
        if (resType.isEmpty() || resPrefix.isEmpty() || name.isEmpty()) {
            return 0
        }

        val resName = if (resPrefix.contains("ic")) {
            String.format("ic_%s", name)
        } else {
            String.format("img_%s", name)
        }

        return applicationContext.resources.getIdentifier(
            resName,
            resType,
            applicationContext.packageName
        )
    }

    private fun getIconResIdFromAppInfo(pm: PackageManager): Int {
        return try {
            val appInfo =
                pm.getApplicationInfo(applicationContext.packageName, PackageManager.GET_META_DATA)
            appInfo.icon
        } catch (e: PackageManager.NameNotFoundException) {
            0
        }
    }

    private fun getRgbColor(rgb: String): Int? {
        val rgbSet = rgb.split(",")
        return if (rgbSet.size == 3) {
            Color.rgb(rgbSet[0].toInt(), rgbSet[1].toInt(), rgbSet[2].toInt())
        } else {
            null
        }
    }

    private fun buildNotification(options: NotificationOptions): Notification {
        val pm = applicationContext.packageManager
        val iconData: NotificationIconData? = options.iconData
        val iconBackgroundColor: Int?
        val iconResId: Int
        if (iconData != null) {
            iconBackgroundColor = iconData.backgroundColorRgb?.let(::getRgbColor)
            iconResId = getIconResIdFromIconData(iconData)
        } else {
            iconBackgroundColor = null
            iconResId = getIconResIdFromAppInfo(pm)
        }
        val builder = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            if (!isCreateChannel) {
                notificationManager =
                    applicationContext.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

                val channel = NotificationChannel(
                    options.channelId,
                    options.channelName,
                    NotificationManager.IMPORTANCE_DEFAULT
                ).apply {
                    if (!options.playSound) {
                        setSound(null, null)
                    }
                    enableVibration(options.enableVibration)
                }
                channel.description = options.channelDescription
                notificationManager?.createNotificationChannel(channel)
                isCreateChannel = true
            }
            NotificationCompat.Builder(applicationContext, options.channelId).apply {
                if (iconBackgroundColor != null) {
                    color = iconBackgroundColor
                }
                priority = NotificationCompat.PRIORITY_LOW
                setSmallIcon(iconResId)
                setContentTitle(options.contentTitle)
                setContentText(options.contentText)
                setShowWhen(options.showWhen)
            }
        } else {
            NotificationCompat.Builder(applicationContext).apply {
                if (!options.playSound) {
                    setSound(null)
                }
                if (iconBackgroundColor != null) {
                    color = iconBackgroundColor
                }
                if (!options.enableVibration) {
                    setVibrate(longArrayOf(0L))
                }
                priority = NotificationCompat.PRIORITY_LOW
                setSmallIcon(iconResId)
                setContentTitle(options.contentTitle)
                setContentText(options.contentText)
                setShowWhen(options.showWhen)
            }
        }.build()
        return builder
    }

}
