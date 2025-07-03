import Flutter
import UIKit
import QMapKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
//    QMapServices.shared().apiKey = "4LGBZ-T23KZ-UGJXA-ZMAW3-LZD5E-J2BKO"
    QMapServices.shared().apiKey = "3AMBZ-U5U6J-ZLDFX-XHX4V-5G45V-EEBFS"
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
