import 'package:cloud_firestore/cloud_firestore.dart';

class categoryModel {
  final String name;
  final int index;
  final String description;
  final String imageUrl;
  final DocumentReference refereance;

  categoryModel({
    required this.name,
    required this.index,
    required this.description,
    required this.imageUrl,
    required this.refereance,
  });

  factory categoryModel.fromJson(Map<String, dynamic> json) {
    return categoryModel(
      name: json['name'],
      index: json['index'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      refereance: json['refereance'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'index': index,
      'description': description,
      'imageUrl': imageUrl,
      'refereance': refereance,
    };
  }
}
