import 'package:eco_picker/utils/get_address.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:eco_picker/api/api_garbage_service.dart';
import 'package:eco_picker/data/garbage.dart';
import 'package:eco_picker/utils/geolocator_utils.dart';
import 'package:eco_picker/utils/get_json_file.dart';
import 'package:eco_picker/utils/resize_image.dart';
import 'package:eco_picker/utils/styles.dart';
import 'package:eco_picker/utils/toastbox.dart';
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

  Future<void> generateMarkers({String? categoryFilter}) async {
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
        _isLoading = false;
      });

      if (bounds != null) {
        mapController.animateCamera(
          CameraUpdate.newLatLngBounds(bounds, 50),
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
      if (mounted) {
        setState(() {
          _garbageLocation = garbageLocations;
        });
        generateMarkers();
      }
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
    print('MapController initialized');

    if (_garbageLocation != null) {
      print('controller generated');
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
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
              ),
            )
          else
            GoogleMap(
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
              markers: _markers ?? {},
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
