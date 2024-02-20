import 'package:cloud_firestore/cloud_firestore.dart';

class RateList {
  final List<RateModel> rate;
  RateList({required this.rate});

  factory RateList.fromJson(List<dynamic> json) {
    List<RateModel> productList = [];
    for (var item in json) {
      productList.add(RateModel.fromJson(item));
    }
    return RateList(rate: productList);
  }

  List<Map<String, dynamic>> toJson() {
    return rate.map((product) => product.toJson()).toList();
  }
}



class RateModel {
  final String image;
  final String name;
  final double rate;
  final String description;
  final DateTime date;
  final DocumentReference userReference;

  RateModel({
    required this.image,
    required this.name,
    required this.rate,
    required this.description,
    required this.date,
    required this.userReference,
  });

  factory RateModel.fromJson(Map<String, dynamic> json) {
    return RateModel(
      image: json['image'],
      name: json['name'],
      rate: json['rate'].toDouble(),
      description: json['description'],
      date: json['date'].toDate(),
      userReference: json['userReference'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'name': name,
      'rate': rate,
      'description': description,
      'date': date.toIso8601String(),
      'userReference': userReference,
    };
  }
}
