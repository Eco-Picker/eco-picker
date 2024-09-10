import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class GeolocatorUtil {
  Future<Position?> getCurrentLocation() async {
    // Check if location service is enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Not enabled, open location service setting
      await Geolocator.openLocationSettings();
      return null;
    }

    // Check location permition
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Request permition
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permition denied
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permition denied forever, need to open app settings
      openAppSettings();
      return null;
    }

    // Permition accepted, get current position
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
}
