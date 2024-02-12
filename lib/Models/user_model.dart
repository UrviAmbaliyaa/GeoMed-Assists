import 'package:cloud_firestore/cloud_firestore.dart';

class user_model {
  String address;
  String? gender;
  double latLong;
  double longitude;
  String? imagePath; // Nullable
  String name;
  String? weight;
  String type;
  String email;
  String? age;
  String? degree;
  String? exp;
  String? about_us;
  String? cantact;
  DocumentReference reference;

  user_model(
      {required this.address,
      this.gender,
      required this.latLong,
      required this.longitude,
      this.imagePath,
      required this.name,
      this.weight,
      required this.type,
      required this.email,
      this.age,
      this.degree,
      this.exp,
      this.about_us,
      this.cantact,
      required this.reference});

  factory user_model.fromJson(Map<String, dynamic> json) {
    return user_model(
        address: json['address'],
        gender: json['gender'],
        latLong: json['latLong'].toDouble(),
        longitude: json['longitude'].toDouble(),
        imagePath: json['imagePath'],
        name: json['name'],
        weight: json['weight'],
        type: json['type'],
        email: json['email'],
        age: json['age'],
        degree: json['degree'],
        exp: json['exp'],
        about_us: json['about_us'],
        cantact: json['cantact'],
        reference: json['reference']);
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'gender': gender,
      'latLong': latLong,
      'longitude': longitude,
      'imagePath': imagePath,
      'name': name,
      'weight': weight,
      'type': type,
      'email': email,
      'age': age,
      'degree': degree,
      'exp': exp,
      'about_us': about_us,
      'cantact': cantact,
      'reference': reference
    };
  }
}
