import 'dart:developer';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';

Future<Position?> getLocation(BuildContext context) async {
  Position? position;
  bool granted = false;

  while (!granted) {
    LocationPermission permission = await _requestLocationPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      log('Location: $position');
      granted = true; // Permission granted, exit loop
    } else {
      // Show modal bottom sheet to request permission again
      position = await showLocationPermissionBottomSheet(context);
      granted = position != null;
    }
  }
  return position;
}

Future<LocationPermission> _requestLocationPermission() async {
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }
  return permission;
}

Future<Position?> showLocationPermissionBottomSheet(
    BuildContext context) async {
  return showModalBottomSheet<Position?>(
    context: context,
    isDismissible: false, // Prevent the user from dismissing the sheet
    builder: (context) {
      return Container(
        height: 200,
        margin: const EdgeInsets.all(16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Location permission is required for the app to work. Please grant permission.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                getLocation(context).then((value) {
                  Navigator.pop(context, value);
                });
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 12.0),
                textStyle: const TextStyle(fontSize: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text('Grant Permission'),
            ),
          ],
        ),
      );
    },
  );
}
