import 'package:eco_picker/utils/geolocator_util.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../utils/styles.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  LatLng? _currentPosition;
  bool _isLoading = true;
  final GeolocatorUtil _geolocatorUtil = GeolocatorUtil();
  Set<Marker>? _markers = <Marker>{};
  late BitmapDescriptor myMarker;

  @override
  void initState() {
    super.initState();
    setMarkerIcon();
    getLocation();
  }

  void setMarkerIcon() async {
    myMarker = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(50, 50)), 'loginlogo.png');
  }

  Future<void> getLocation() async {
    var status = await Permission.locationWhenInUse.status;
    if (!status.isGranted) {
      status = await Permission.locationWhenInUse.request();
    }

    if (status.isGranted) {
      try {
        final position = await _geolocatorUtil.getCurrentLocation();
        if (position != null) {
          setState(() {
            _currentPosition = LatLng(position.latitude, position.longitude);
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
          // 위치 정보를 가져오지 못했을 때 처리할 코드 추가
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        // 위치 정보를 가져오는 도중 에러가 발생했을 때 처리할 코드 추가
        print("Error getting location: $e");
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      // 권한 요청이 거부되었을 때 처리할 코드 추가
      print("Location permission denied");
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    // generateMarkers();
  }

  void generateMarkers() {
    var localMarkers = <Marker>{};

    // for (var location in locationsList!) {
    //   localMarkers.add(Marker(
    //       markerId: MarkerId(location.id!),
    //       position: LatLng(location.lat!, location.lng!),
    //       icon: myMarker));
    // }

    if (mounted) {
      setState(() {
        _markers = localMarkers;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // setMarkerIcon();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
        titleTextStyle: headingTextStyle(),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
              ),
            )
          : GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: _currentPosition != null
                  ? CameraPosition(
                      target: _currentPosition!,
                      zoom: 16.0,
                    )
                  : CameraPosition(
                      target: LatLng(0, 0), // 기본 위치 설정 (예: LatLng(0, 0))
                      zoom: 2.0,
                    ),
              myLocationEnabled: true, // Show the user's current location
              markers: _markers != null
                  ? _markers!
                  : {
                      Marker(
                        markerId: MarkerId("default"),
                        position: LatLng(0, 0),
                      ),
                    },
            ),
    );
  }
}
