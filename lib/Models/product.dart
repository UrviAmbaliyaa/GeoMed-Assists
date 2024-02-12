import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String name;
  final String image;
  final String category;
  final double price;
  final String about;
  final DocumentReference shopReference;

  Product({
    required this.image,
    required this.name,
    required this.category,
    required this.price,
    required this.about,
    required this.shopReference,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      image: json['image'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      about: json['about'] ?? '',
      shopReference: json['shoprefe'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'name': name,
      'category': category,
      'price': price,
      'about': about,
      'shoprefe': shopReference,
    };
  }
}
