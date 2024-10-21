// import 'dart:developer';
// import 'package:geolocator/geolocator.dart';
// import 'package:flutter/material.dart';

// Future<Position?> getLocation(BuildContext context) async {
//   Position? position;
//   bool granted = false;

//   while (!granted) {
//     LocationPermission permission = await _requestLocationPermission();
//     if (permission == LocationPermission.always ||
//         permission == LocationPermission.whileInUse) {
//       position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//       log('Location: $position');
//       granted = true; // Permission granted, exit loop
//     } else {
//       // Show modal bottom sheet to request permission again
//       position = await showLocationPermissionBottomSheet(context);
//       granted = position != null;
//     }
//   }
//   return position;
// }

// Future<LocationPermission> _requestLocationPermission() async {
//   LocationPermission permission = await Geolocator.checkPermission();
//   if (permission == LocationPermission.denied) {
//     permission = await Geolocator.requestPermission();
//   }
//   return permission;
// }

// Future<Position?> showLocationPermissionBottomSheet(
//     BuildContext context) async {
//   return showModalBottomSheet<Position?>(
//     context: context,
//     isDismissible: false, // Prevent the user from dismissing the sheet
//     builder: (context) {
//       return Container(
//         height: 200,
//         margin: const EdgeInsets.all(16.0),
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text(
//               'Location permission is required for the app to work. Please grant permission.',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 16.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: () {
//                 getLocation(context).then((value) {
//                   Navigator.pop(context, value);
//                 });
//               },
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: 24.0, vertical: 12.0),
//                 textStyle: const TextStyle(fontSize: 16.0),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//               ),
//               child: const Text('Grant Permission'),
//             ),
//           ],
//         ),
//       );
//     },
//   );
// }

import 'dart:developer';
import 'package:geolocator/geolocator.dart';

typedef PermissionRequestCallback = Future<void> Function();

class LocationService {
  /// Requests the current location of the user.
  ///
  /// [onPermissionDenied] is a callback that should handle the permission request UI,
  /// such as showing a dialog or bottom sheet to inform the user why location is needed.
  ///
  /// Returns the [Position] if successful, or `null` if the permission is denied.
  Future<Position?> getCurrentLocation({
    required PermissionRequestCallback onPermissionDenied,
  }) async {
    Position? position;

    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, cannot proceed
      log('Location services are disabled.');
      return null;
    }

    // Check for location permissions
    LocationPermission permission = await Geolocator.checkPermission();

    // If permission is denied, request it
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      // Invoke the permission request callback
      await onPermissionDenied();

      // Re-check the permission after the user has been prompted
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        log('Location permission denied.');
        return null;
      }
    }

    // Permission granted, get the position
    try {
      position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      log('Location obtained: $position');
    } catch (e) {
      log('Error obtaining location: $e');
      return null;
    }

    return position;
  }
}
