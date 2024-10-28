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
