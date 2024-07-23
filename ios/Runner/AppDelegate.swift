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
    if let googleMapsAPIKey = Bundle.main.infoDictionary?["MAP_API"] as? String {
            GMSServices.provideAPIKey(googleMapsAPIKey)
        } else {
            fatalError("Google Maps API Key not found.")
        }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
