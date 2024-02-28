import 'package:cloud_firestore/cloud_firestore.dart';

class categoryModel {
  final String name;
  final String description;
  final String imageUrl;
  final DocumentReference refereance;

  categoryModel({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.refereance,
  });

  factory categoryModel.fromJson(Map<String, dynamic> json) {
    return categoryModel(
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      refereance: json['refereance'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'refereance': refereance,
    };
  }
}
