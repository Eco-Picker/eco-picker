import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class GeolocatorUtil {
  Future<Position?> getCurrentLocation() async {
    // 위치 서비스가 활성화되어 있는지 확인
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // 위치 서비스가 활성화되어 있지 않음, 위치 서비스 설정 열기
      await Geolocator.openLocationSettings();
      return null;
    }

    // 위치 권한 확인 및 요청
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // 권한 요청
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // 권한 거부됨
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // 권한이 영구적으로 거부됨, 설정에서 수동으로 권한 허용 필요
      openAppSettings();
      return null;
    }

    // 위치 권한이 허용된 경우 현재 위치 가져오기
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
}
