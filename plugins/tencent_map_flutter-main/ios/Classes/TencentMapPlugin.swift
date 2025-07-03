import Flutter
import UIKit
import TencentLBS

public class TencentMapPlugin: NSObject, FlutterPlugin ,TencentLBSLocationManagerDelegate{
    
    var locationManager: TencentLBSLocationManager?
    var resultList: Array<FlutterResult> = Array()
    var isListenLocationUpdates = false
    public static var channel: FlutterMethodChannel?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        
      // 注册地图通道
      registrar.register(TencentMapFactory(registrar: registrar), withId: "tencent_map_flutter")
      _TencentMapSdkApi.setup(registrar: registrar)
      
      // 注册腾讯地图定位通道
      channel = FlutterMethodChannel(name: "flutter_tencent_lbs_plugin", binaryMessenger: registrar.messenger())
      let instance = TencentMapPlugin()
      registrar.addMethodCallDelegate(instance, channel: channel!)
    }
    
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      switch call.method {
      case "setUserAgreePrivacy":
        TencentLBSLocationManager.setUserAgreePrivacy(true)
        break
      case "init":
        self.initTencentLBS(args:call.arguments, result: result)
        break
      case "getLocationOnce":
        resultList.append(result)
        self.getLocationOnce()
        break
      case "getLocation":
        resultList.append(result)
        self.getLocation(args: call.arguments as! Dictionary<String,Any>)
        break
      case "stopLocation":
        self.stopLocation()
        break
      default:
        result(FlutterMethodNotImplemented)
      }
    }
    
    // 地图定位的更新回调
    public func tencentLBSLocationManager(_ manager: TencentLBSLocationManager, didUpdate location: TencentLBSLocation) {
      self.sendLocationToFlutter(value: self.createLocationValue(location: location))
    }
    
    // 定位失败处理
    public func tencentLBSLocationManager(_ manager: TencentLBSLocationManager, didFailWithError error: Error) {
      let code = (error as NSError).code
      self.sendLocationToFlutter(value: self.createErrorResult(code: code), isSuccess: false)
    }
    
    /// 初始化定位
    public func initTencentLBS(args: Any?, result: FlutterResult) {
      let options = InitOptions(dictionary: args as! Dictionary<String, Any>)
      self.locationManager=TencentLBSLocationManager.init()
      self.locationManager?.delegate = self
      self.locationManager?.apiKey = options.key
      self.locationManager?.requestLevel = options.requestLevel
      self.locationManager?.coordinateType = options.coordinateType
      self.locationManager?.enableAntiMockLocation = options.mockEnable
    }
    
    /// 获取一次定位
    public func getLocationOnce() {
      self.locationManager?.requestLocation(completionBlock: { (location: TencentLBSLocation?,e: Error?) in
        if (e != nil) {
          let code = (e! as NSError).code
          self.sendLocationToFlutter(value: self.createErrorResult(code: code), isSuccess: false)
        } else {
          self.sendLocationToFlutter(value: self.createLocationValue(location: location))
        }
      })
    }
    
    /// 获取定位
    public func getLocation(args: Dictionary<String,Any>){
      if(isListenLocationUpdates) {
        return
      }
      isListenLocationUpdates = true
        
        for (key, value) in args {
            print("\(key): \(value)")
        }
        
      if (args["backgroundLocation"] as! Bool) {
        self.locationManager?.allowsBackgroundLocationUpdates = true
        self.locationManager?.pausesLocationUpdatesAutomatically = false
      }
      self.locationManager?.locationCallbackInterval = args["interval"] as! UInt64
      self.locationManager?.startUpdatingLocation()
    }
    
    /// 停止定位
    public func stopLocation() {
      isListenLocationUpdates = false
      self.locationManager?.stopUpdatingLocation()
    }
    
    /// native to flutter
    public func sendSuccessLocationToFlutter(result: FlutterResult, value: Dictionary<String,Any>) {
      result(value)
    }
    
    public func sendErrorLocationToFlutter(result: FlutterResult, value: Dictionary<String,Any>) {
      result(FlutterError.init(code: String(describing: value["code"]), message: "Err", details: value))
    }
    
    public func sendLocationToFlutter(value: Dictionary<String,Any>, isSuccess: Bool = true) {
      for result in self.resultList{
        if(isSuccess) {
          sendSuccessLocationToFlutter(result: result, value: value)
        } else {
          sendErrorLocationToFlutter(result: result, value: value)
        }
      }
        self.resultList.removeAll()
        TencentMapPlugin.channel?.invokeMethod("receiveLocation", arguments: value)
    }
    
    /// 数据转换
    public func createErrorResult(code: Int) -> Dictionary<String,Any> {
      var result=Dictionary<String,Any>.init()
      result["code"] = code
      return result
    }
    
    public func createLocationValue(location: TencentLBSLocation?) -> Dictionary<String,Any> {
      var result = Dictionary<String,Any>.init()
      result["name"] = location?.name
      result["latitude"] = location?.location.coordinate.latitude
      result["longitude"] = location?.location.coordinate.longitude
      result["address"] = location?.address
      result["city"] = location?.city
      result["province"] = location?.province
      result["area"] = location?.district
      result["cityCode"] = location?.code
      result["code"] = LocationCode.ERROR_OK
      return result
    }
    
    
    
    
}
