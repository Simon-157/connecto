import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:connecto/controllers/location_controller.dart';
import 'package:connecto/services/location_service.dart';
import 'package:location/location.dart';

class MapWidget extends StatefulWidget {
  final List<LatLng> locations;

  const MapWidget({super.key, required this.locations});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  static const LatLng _kMapCenter = LatLng(5.7603, 0.2199);
  late GoogleMapController _controller;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  final LocationController _locationController = Get.put(LocationController());
  final LocationService _locationService = LocationService.instance;
  StreamSubscription? _locationSubscription;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
    _initializeMarkersAndPolylines();
  }

  @override
  void dispose() {
    // Cancel the subscription to location updates
    _locationSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initializeLocation() async {
    // Use the Rx stream directly from LocationController
    _locationSubscription = _locationController.userLocation.listen((locationData) {
      if (mounted) {
        if (locationData != null) {
          setState(() {
            _updatePolylines(locationData);
          });
        } else if (_locationController.errorDescription.value.isNotEmpty) {
          Get.snackbar(
            "Location Error",
            _locationController.errorDescription.value,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      }
    });

    // Trigger location retrieval
    await _locationService.getUserLocation(controller: _locationController);
  }

  void _initializeMarkersAndPolylines() {
    widget.locations.forEach((LatLng location) {
      _markers.add(Marker(
        markerId: MarkerId(location.toString()),
        position: location,
      ));
    });

    if (_locationController.userLocation.value != null) {
      _updatePolylines(_locationController.userLocation.value!);
    }
  }

  void _updatePolylines(LocationData currentLocation) {
    _polylines.clear();
    widget.locations.forEach((LatLng location) {
      _polylines.add(Polyline(
        polylineId: PolylineId(location.toString()),
        points: [
          LatLng(currentLocation.latitude!, currentLocation.longitude!),
          location,
        ],
        color: Colors.blue,
        width: 2,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      height: 300,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.grey,
      ),
      child: Obx(() {
        if (_locationController.isAccessingLocation.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (_locationController.userLocation.value == null) {
          return const Center(child: CircularProgressIndicator());
        } else {
          final currentLocation = _locationController.userLocation.value;
          return GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _kMapCenter,
              zoom: 13,
            ),
            markers: _markers,
            polylines: _polylines,
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
              _controller.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: LatLng(
                     currentLocation?.latitude ?? 5.574548042290121,
                      currentLocation?.longitude ?? -0.19716657097514453,
                    ),
                    zoom: 13,
                  ),
                ),
              );
            },
          );
        }
      }),
    );
  }
}
