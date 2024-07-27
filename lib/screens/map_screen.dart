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
  late GoogleMapController mapController;
  LatLng? _currentPosition;
  bool _isLoading = true;
  final GeolocatorUtil _geolocatorUtil = GeolocatorUtil();
  Set<Marker>? _markers = <Marker>{};
  late BitmapDescriptor myMarker;

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  void setMarkerIcon() async {
    myMarker = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(50, 50)), 'loginlogo.png');
  }

  Future<void> getLocation() async {
    var status = await Permission.locationWhenInUse.status;
    if (!status.isGranted) {
      await Permission.locationWhenInUse.request();
    }

    final position = await _geolocatorUtil.getCurrentLocation();
    if (position != null) {
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _isLoading = false;
      });
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
              child: CircularProgressIndicator(),
            )
          : GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _currentPosition!,
                zoom: 16.0,
              ),
              myLocationEnabled: true, // Show the user's current location
              markers: {
                const Marker(
                  markerId: const MarkerId("Sydney"),
                  position: LatLng(-33.86, 151.20),
                )
              },
              // markers: _markers!,
            ),
    );
  }
}
