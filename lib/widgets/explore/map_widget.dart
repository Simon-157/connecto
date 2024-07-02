import 'dart:async';

// import 'package:connecto/models/job_feed_model.dart';
// import 'package:connecto/models/user_model.dart';
import 'package:connecto/utils/data.dart';
import 'package:connecto/widgets/explore/feeds_found_modal.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:connecto/controllers/location_controller.dart';
import 'package:connecto/services/location_service.dart';
import 'package:location/location.dart';

class MapWidget extends StatefulWidget {
  final List<LatLng> locations;

  const MapWidget({Key? key, required this.locations}) : super(key: key);

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
    // Cancel subscription to location updates
    _locationSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initializeLocation() async {
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

    // location retrieval
    await _locationService.getUserLocation(controller: _locationController);
  }

  void _initializeMarkersAndPolylines() {
    List<Color> polylineColors = Colors.primaries;

    _markers.clear();
    _polylines.clear();

    for (int i = 0; i < widget.locations.length; i++) {
      LatLng location = widget.locations[i];

      Color markerColor = polylineColors[i % polylineColors.length];

      _markers.add(Marker(
        markerId: MarkerId(location.toString()),
        position: location,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        onTap: () {
          _showFoundFeedModal(location);
        },
      ));

      _polylines.add(Polyline(
        polylineId: PolylineId(location.toString()),
        points: [
          LatLng(_locationController.userLocation.value!.latitude!, _locationController.userLocation.value!.longitude!),
          location,
        ],
        color: markerColor,
        width: 2,
      ));
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

  void _showFoundFeedModal(LatLng location) {

    // List<JobFeed> jobFeeds = dummyJobFeeds.where((feed) => feed.latlong['latitude'] == location.latitude && feed.latlong['longitude'] == location.longitude).toList();
    // List<User> mentors = dummyMentors.where((mentor) => mentor.latlong['latitude'] == location.latitude && mentor.latlong['longitude'] == location.longitude).toList(); 

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FoundFeedModal(
          jobFeeds: jobFeedDataList.sublist(0, 4),
          mentors: userDataList.sublist(0, 4),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
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
            return SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: GoogleMap(
                initialCameraPosition: const CameraPosition(
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
                gestureRecognizers: Set()..add(Factory<EagerGestureRecognizer>(() => EagerGestureRecognizer())),
              ),
            );
          }
        }),
      ),
    );
  }
}
