import 'package:eco_picker/utils/get_address.dart';
import 'package:eco_picker/utils/toastbox.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:eco_picker/api/api_garbage_service.dart';
import 'package:eco_picker/data/garbage.dart';
import 'package:eco_picker/utils/geolocator_utils.dart';
import 'package:eco_picker/utils/get_json_file.dart';
import 'package:eco_picker/utils/resize_image.dart';
import 'package:eco_picker/utils/styles.dart';
import 'package:provider/provider.dart';
import '../components/map_bottom_sheet.dart';
import '../main.dart';

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
  final _sheetController = DraggableScrollableController();

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
        });
      } else {
        showToast('Unavailable to retrieve your location data.', 'error');
      }
    } catch (e) {
      showToast('Unavailable to retrieve your location data.', 'error');
      print("Error getting location: $e");
    }
  }

  void generateMarkers({String? categoryFilter}) async {
    if (_garbageLocation == null) {
      print('Error: _garbageLocation is null');
      return;
    }

    var localMarkers = <Marker>{};
    LatLngBounds? bounds;

    for (var garbage in _garbageLocation!.garbageLocations) {
      if (categoryFilter == null ||
          categoryFilter == 'Display All' ||
          garbage.garbageCategory == categoryFilter) {
        final markerIcon = BitmapDescriptor.fromBytes(await getBytesFromAsset(
            'assets/images/${garbage.garbageCategory}.png', 100));

        final marker = Marker(
          markerId: MarkerId(garbage.garbageId.toString()),
          position: LatLng(garbage.latitude, garbage.longitude),
          icon: markerIcon,
          onTap: () async {
            try {
              final garbageDetails =
                  await _apiGarbageService.getGarbageByID(garbage.garbageId);
              if (mounted) {
                showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (context) {
                    return MapBottomSheet(
                      garbageDetail: garbageDetails,
                      onCategorySelected: generateMarkers,
                    );
                  },
                );
              }
            } catch (e) {
              if (e == 'LOG_OUT') {
                showToast('User token expired. Logging out.', 'error');
                final appState =
                    Provider.of<MyAppState>(context, listen: false);
                appState.signOut(context);
              } else {
                showToast('Error analyzing garbage: $e', 'error');
              }
            }
          },
        );

        localMarkers.add(marker);

        // Calculate bounds
        if (bounds == null) {
          bounds = LatLngBounds(
            southwest: LatLng(garbage.latitude, garbage.longitude),
            northeast: LatLng(garbage.latitude, garbage.longitude),
          );
        } else {
          bounds = bounds.extend(LatLng(garbage.latitude, garbage.longitude));
        }
      }
    }

    if (mounted) {
      setState(() {
        _markers = localMarkers;
      });

      // Move the map camera to fit the bounds if there are markers
      if (bounds != null) {
        mapController.animateCamera(
          CameraUpdate.newLatLngBounds(bounds, 50), // Padding added
        );
      }
    }
  }

  void _onCameraMove(CameraPosition position) {
    // Close the sheet when the map is moved or interacted with
    _sheetController.animateTo(
      0.1,
      duration: const Duration(milliseconds: 40),
      curve: Curves.easeIn,
    );
  }

  Future<void> fetchGarbageLocations() async {
    try {
      final garbageLocations = await _apiGarbageService.getGarbageList();
      setState(() {
        _isLoading = false;
        _garbageLocation = garbageLocations;
      });
      // Generate markers after fetching garbage locations
      generateMarkers();
    } catch (e) {
      if (e == 'LOG_OUT') {
        showToast('User token expired. Logging out.', 'error');
        final appState = Provider.of<MyAppState>(context, listen: false);
        appState.signOut(context);
      } else {
        showToast('Error fetching garbage locations: $e', 'error');
      }
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
                  onCameraMove: _onCameraMove,
                  initialCameraPosition: _currentPosition != null
                      ? CameraPosition(
                          target: _currentPosition!,
                          zoom: 16.0,
                        )
                      : CameraPosition(
                          target: LatLng(0, 0),
                          zoom: 16.0,
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
                  padding: const EdgeInsets.only(bottom: 70),
                ),
          MapBottomSheet(
            controller: _sheetController,
            onCategorySelected: generateMarkers,
          ),
        ],
      ),
    );
  }
}
