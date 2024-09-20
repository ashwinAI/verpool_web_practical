import 'dart:async';
import 'dart:math';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../helper/all.dart';

class MapController extends GetxController {
  LatLng? currentLocation;
  List<Marker> markers = <Marker>[];
  String? distance;

  GoogleMapController? newController;
  final double startLatitude = 37.7749; // Example: San Francisco
  final double startLongitude = -122.4194;
  final double endLatitude = 34.0522; // Example: Los Angeles
  final double endLongitude = -118.2437;

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      Get.snackbar(
        'Location services are disabled.',
        'Location services are disabled.',
        borderRadius: 10,
        snackPosition: SnackPosition.TOP,
        colorText: Colors.white,
        backgroundColor: Colors.redAccent,
        titleText: const SizedBox(),
      );
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  void _add() {
    markers.add(
      Marker(
        markerId: const MarkerId('abc'),
        position: LatLng(
          currentLocation!.latitude,
          currentLocation!.longitude,
        ),
        onTap: () {
          launchGoogleMaps();
        },
      ),
    );
    update();
  }

  void launchGoogleMaps() async {
    final String googleMapsUrl =
        "https://www.google.com/maps/dir/?api=1&origin=${currentLocation?.latitude},${currentLocation
        ?.longitude}&destination=21.15054616873055, 72.77308464156695&travelmode=driving";

    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      throw 'Could not launch $googleMapsUrl';
    }
  }

  CameraPosition initialCameraPosition() {
    return CameraPosition(
      target: LatLng(currentLocation!.latitude, currentLocation!.longitude),
      zoom: 19.151926040649414,
    );
  }

  String areaName = '';

  @override
  void onInit() {
    _determinePosition().then(
          (value) async {
        currentLocation = LatLng(value.latitude, value.longitude);
        List<Placemark> placemarks = await placemarkFromCoordinates(value.latitude, value.longitude);
        Placemark placemark = placemarks[0];
        distance = calculateDistance(value.latitude, value.longitude, 21.15054616873055, 72.77308464156695).toStringAsFixed(2);
        areaName = '${placemark.name ?? ""},${placemark.subLocality},${placemark.locality},${placemark.administrativeArea},${placemark.country}';
        print('placemarks----------------->>>>>>${areaName}');
        _add();
        update();
      },
    );

    super.onInit();
  }
}

double calculateDistance(lat1, lon1, lat2, lon2) {
  var p = 0.017453292519943295;
  var c = cos;
  var a = 0.5 - c((lat2 - lat1) * p) / 2 + c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
  return 12742 * asin(sqrt(a));
}
