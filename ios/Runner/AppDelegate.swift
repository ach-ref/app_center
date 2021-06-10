import UIKit
import Flutter

import AppCenter
import AppCenterAnalytics
import AppCenterCrashes

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    // app center
    AppCenter.start(withAppSecret: "9adbb840-86dc-49e8-bde0-a138990a7adf", services:[
      Analytics.self,
      Crashes.self
    ])
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
