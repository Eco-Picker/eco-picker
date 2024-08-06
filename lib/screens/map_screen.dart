import 'package:eco_picker/utils/toastbox.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:eco_picker/api/api_garbage_service.dart';
import 'package:eco_picker/components/category_legend.dart';
import 'package:eco_picker/data/garbage.dart';
import 'package:eco_picker/utils/geolocator_utils.dart';
import 'package:eco_picker/utils/get_json_file.dart';
import 'package:eco_picker/utils/resize_image.dart';
import 'package:eco_picker/utils/styles.dart';

import '../components/Map_Bottom_Sheet.dart';

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
        showToast('Unavailable to retrieve your location data.', 'error');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      showToast('Unavailable to retrieve your location data.', 'error');
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
      final markerIcon = BitmapDescriptor.fromBytes(await getBytesFromAsset(
          'assets/images/${garbage.garbageCategory}.png', 100));

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

    getJsonFile('assets/map_style.json')
        .then((value) => mapController.setMapStyle(value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
        titleTextStyle: headingTextStyle(),
      ),
      body: Stack(
        children: [
          _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
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
                  myLocationEnabled: true,
                  markers: _markers != null
                      ? _markers!
                      : {
                          Marker(
                            markerId: MarkerId("default"),
                            position: LatLng(0, 0),
                          ),
                        },
                  padding: const EdgeInsets.only(bottom: 60),
                ),
          CategoryLegend(),
          MapBottomSheet(garbageLocation: _garbageLocation),
        ],
      ),
    );
  }
}
