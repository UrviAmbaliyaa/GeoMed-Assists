import 'package:cloud_firestore/cloud_firestore.dart';

class ProductList {
  final List<Product> products;
  ProductList({required this.products});

  factory ProductList.fromJson(List<dynamic> json) {
    List<Product> productList = [];
    for (var item in json) {
      productList.add(Product.fromJson(item));
    }
    return ProductList(products: productList);
  }

  List<Map<String, dynamic>> toJson() {
    return products.map((product) => product.toJson()).toList();
  }
}

class Product {
  final String image;
  final String name;
  final double price;
  final String description;
  final bool available;
  final String category;
  final String status;
  final String? cancelReason;
  final DocumentReference referenace;
  final DocumentReference shopReference;
  final DocumentReference categoryRef;

  Product({
    required this.image,
    required this.name,
    required this.price,
    required this.status,
    required this.description,
    required this.available,
    required this.category,
    this.cancelReason,
    required this.referenace,
    required this.shopReference,
    required this.categoryRef,
  });

  // Factory method to create a Product instance from a map (JSON)
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      image: json['image'],
      name: json['name'],
      status: json['status'],
      price: double.parse(json['price']),
      description: json['description'],
      available: json['available'],
      cancelReason: json['cancelReason'] ?? '',
      category: json['category'],
      referenace: json['referenace'],
      shopReference: json['shopReference'],
      categoryRef: json['categoryRef'],
    );
  }

  // Method to convert a Product instance to a map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'name': name,
      'price': price,
      'status': status,
      'description': description,
      'available': available,
      'category': category,
      'cancelReason': cancelReason,
      'referenace': referenace,
      'shopReference': shopReference,
      'categoryRef': categoryRef,
    };
  }
}


