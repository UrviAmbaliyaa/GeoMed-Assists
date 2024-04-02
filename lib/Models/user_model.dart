import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geomed_assist/constants/constantdata.dart';

class UserModel {
  String? address;
  String? gender;
  double? latLong;
  double? longitude;
  double? rate;
  int? ratedUser;
  String? imagePath; // Nullable
  String name;
  String? weight;
  String type;
  String email;
  String? age;
  String? degree;
  String? exp;
  String? aboutUs;
  String? contact;
  String? startTime;
  String? breckstartTime;
  String? endTime;
  String? breckendTime;
  String? lunchTime;
  String? zipCode;
  String? cancelReason;
  String approve;
  String? specialist;
  double? distanc;
  List? availableSlot;
  DateTime register;
  DocumentReference reference;
  List<DocumentReference>? favoriteReference;

  UserModel({
    this.address,
    this.gender,
    this.latLong,
    this.longitude,
    this.rate,
    this.availableSlot,
    this.ratedUser,
    this.imagePath,
    this.zipCode,
    required this.name,
    this.weight,
    required this.type,
    required this.email,
    this.age,
    this.degree,
    this.exp,
    this.aboutUs,
    this.specialist,
    this.contact,
    this.startTime,
    this.breckstartTime,
    this.endTime,
    this.breckendTime,
    this.lunchTime,
    this.cancelReason,
    required this.approve,
    this.distanc,
    required this.reference,
    required this.register,
    this.favoriteReference = const [],
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    print("json['register']-------->${json['register']}");
    return UserModel(
      address: json['address'] ?? '',
      gender: json['gender'],
      latLong: json['latLong'] != null? json['latLong'].toDouble() : 0.0,
      longitude: json['longitude'] != null ?json['longitude'].toDouble() : 0.0,
      rate: json['rate'] != null ? json['rate']?.toDouble() : 0.0,
      ratedUser: json['ratedUser'] ?? 0,
      imagePath: json['imagePath'],
      name: json['name'],
      weight: json['weight'],
      type: json['type'],
      zipCode: json['zipCode'],
      email: json['email'],
      age: json['age'],
      degree: json['degree'],
      exp: json['exp'],
      aboutUs: json['about_us'],
      contact: json['cantact'],
      startTime: json['startTime'] ?? '',
      breckstartTime: json['breckstartTime'] ?? '',
      endTime: json['endtime'] ?? '',
      breckendTime: json['breckendTime'] ?? '',
      lunchTime: json['lunchTime'],
      cancelReason: json['cancelReason'] ?? '',
      specialist: json['specialist'] ?? '',
      approve: json['approve'],
      distanc: json['latLong'] != null ? currentUserDocument != null
          ? calculateDistance(
              currentUserDocument!.latLong,
              currentUserDocument!.longitude,
              json['latLong'].toDouble(),
              json['longitude'].toDouble())
          : 0 ?? 0.0:0.0,
      reference: json['reference'],
      register: json['register'] != null ? json['register'].runtimeType != DateTime ? json['register'].toDate():json['register'] :currentUserDocument!.register,
      availableSlot:json['availableSlot'] ?? [],
      favoriteReference: List<DocumentReference>.from(
              json['favoriteReference']?.map((x) => x) ?? []) ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'gender': gender,
      'latLong': latLong,
      'longitude': longitude,
      'rate': rate,
      'ratedUser': ratedUser,
      'imagePath': imagePath,
      'name': name,
      'weight': weight,
      'type': type,
      'email': email,
      'age': age,
      'zipCode': zipCode,
      'degree': degree,
      'specialist': specialist,
      'exp': exp,
      "availableSlot":availableSlot,
      'about_us': aboutUs,
      'cantact': contact,
      'startTime': startTime,
      'breckstartTime': breckstartTime,
      'endtime': endTime,
      'breckendTime': breckendTime,
      'lunchTime': lunchTime,
      'cancelReason': cancelReason,
      'approve': approve,
      'distanc': distanc,
      'reference': reference,
      'register': register,
      'favoriteReference': favoriteReference!.map((x) => x) ?? [],
    };
  }
}
