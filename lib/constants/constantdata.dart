import 'dart:math';

import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:geomed_assist/Models/user_model.dart';

UserModel? currentUserDocument;

const earthRadius = 6371; // Radius of the Earth in kilometers

double calculateDistance(
    double? lat1, double? lon1, double? lat2, double? lon2) {
  const earthRadius = 6371;
  // Convert latitude and longitude from degrees to radians
  if ((lat1!.isNaN && lon1!.isNaN && lat2!.isNaN && lon2!.isNaN) == false) {
    lat1 = _degreesToRadians(lat1);
    lon1 = _degreesToRadians(lon1!);
    lat2 = _degreesToRadians(lat2!);
    lon2 = _degreesToRadians(lon2!);

    // Haversine formula
    final dlat = lat2 - lat1;
    final dlon = lon2 - lon1;

    final a =
        pow(sin(dlat / 2), 2) + cos(lat1) * cos(lat2) * pow(sin(dlon / 2), 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    // Distance in kilometers
    final distance = earthRadius * c;

    return double.parse(distance.toStringAsFixed(2));
  } else {
    return 0.0;
  }
}

double _degreesToRadians(double degrees) {
  return degrees * (pi / 180);
}

callNumber({required var contactNumber}) {
  FlutterPhoneDirectCaller.callNumber(contactNumber);
}
