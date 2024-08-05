import 'package:eco_picker/api/api_garbage_service.dart';
import 'package:eco_picker/data/garbage.dart';
import 'package:eco_picker/utils/geolocator_utils.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../utils/styles.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final ApiGarbageService _apiGarbageService = ApiGarbageService();
  late GoogleMapController mapController;
  LatLng? _currentPosition;
  bool _isLoading = true;
  final GeolocatorUtil _geolocatorUtil = GeolocatorUtil();
  Set<Marker>? _markers = <Marker>{};
  late BitmapDescriptor myMarker;
  GarbageLocation? _garbageLocation;

  @override
  void initState() {
    super.initState();
    getLocation();
    fetchGarbageLocations();
  }

  Future<void> getLocation() async {
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
  }

  void generateMarkers() async {
    if (_garbageLocation == null) {
      print('Error: _garbageLocation is null');
      return;
    }

    var localMarkers = <Marker>{};

    for (var garbage in _garbageLocation!.garbageLocations) {
      // 카테고리별로 다른 마커 아이콘을 로드
      final markerIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(50, 50)),
        'assets/images/${garbage.garbageCategory}.png',
      );

      // 마커 추가
      localMarkers.add(Marker(
        markerId: MarkerId(garbage.garbageId.toString()),
        position: LatLng(garbage.latitude, garbage.longitude),
        icon: markerIcon,
        infoWindow: InfoWindow(
          title: garbage.garbageCategory,
          snippet: 'Garbage ID: ${garbage.garbageId}',
        ),
      ));
    }

    if (mounted) {
      setState(() {
        _markers = localMarkers;
      });
    }
  }

  Future<void> fetchGarbageLocations() async {
    try {
      final garbageLocations = await _apiGarbageService.getGarbageList();
      setState(() {
        _garbageLocation = garbageLocations;
      });
      generateMarkers();
    } catch (e) {
      print('Error fetching garbage locations: $e');
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;

    if (_garbageLocation != null) {
      generateMarkers();
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      target: LatLng(0, 0),
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
