import 'package:cloud_firestore/cloud_firestore.dart';

class ProductRequest {
  DocumentReference userReference;
  DocumentReference productReference;
  DocumentReference shopReference;
  DocumentReference reference;
  String description;
  String status;
  DateTime time;

  ProductRequest({
    required this.userReference,
    required this.productReference,
    required this.shopReference,
    required this.reference,
    required this.description,
    required this.status,
    required this.time
  });

  factory ProductRequest.fromJson(Map<String, dynamic> json) {
    return ProductRequest(
      userReference: json['userReference'],
      productReference: json['productReference'],
      shopReference: json['shopReference'],
      reference: json['refereance'],
      description: json['description'] ?? '',
      status: json['status'] ?? "false",
      time: json['time'].toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userReference': userReference,
      'productReference': productReference,
      'shopReference': shopReference,
      'reference': reference,
      'description': description,
      'status': status,
      'time': time,
    };
  }
}
