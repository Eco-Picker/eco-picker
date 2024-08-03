import Flutter
import UIKit
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    if let apiKey = ProcessInfo.processInfo.environment["MAP_API_KEY"] {
            GMSServices.provideAPIKey(apiKey)
        } else {
            fatalError("Google Maps API key is missing!")
        }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
