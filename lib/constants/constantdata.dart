import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:geomed_assist/Models/user_model.dart';

UserModel? currentUserDocument;

String selectedZipCode = '';


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
    final distance = (earthRadius * c)*0.62;

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

// sendNotification(String title,String body, String body1) async {
//   FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   var userToken = await _firebaseMessaging.getToken();
//   // await FirebaseMessaging.instance.sendMessage(
//   //   to: userToken,
//   //   data: {
//   //     'title': title,
//   //     'body': body,
//   //   },
//   // );
//   if (userToken != null) {
//     sendNotification(userToken, title, body);
//     print('Notification sent successfully');
//   } else {
//     print('Failed to get user FCM token');
//   }
// }
