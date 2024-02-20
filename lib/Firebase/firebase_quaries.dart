import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geomed_assist/Models/ChatModel.dart';
import 'package:geomed_assist/Models/ProductRequest.dart';
import 'package:geomed_assist/Models/categoryModel.dart';
import 'package:geomed_assist/Models/product.dart';
import 'package:geomed_assist/Models/rateModel.dart';
import 'package:geomed_assist/Models/user_model.dart';
import 'package:geomed_assist/Store_flow/addProducts.dart';

import '../constants/constantdata.dart';

class Firebase_Quires {
  Stream<List<UserModel>?> getFavoritesdata({required bool shopkeeper}) async* {
    try {
      List<UserModel> userList = [];
      var data = await currentUserDocument!.reference.get();
      var favoritesList = List<DocumentReference>.from(
              data['favoriteReference']?.map((x) => x) ?? []) ??
          [];
      for (var doc in favoritesList) {
        var user = await doc.get();
        if (user.data() != null) {
          Map<String, dynamic> data = user.data() as Map<String, dynamic>;
          data.addAll({'reference': user.reference});
          var docdata = await UserModel.fromJson(data);
          shopkeeper && docdata.type == "ShopKeeper" && docdata.approve == true
              ? userList.add(docdata)
              : null;
          !shopkeeper && docdata.type == "Doctore" && docdata.approve == true
              ? userList.add(docdata)
              : null;
        }
      }
      yield userList;
    } catch (e) {
      print("Error fetching products: $e");
      yield null;
    }
  }

  Stream<UserModel?> getuserInfo({required DocumentReference refId}) async* {
    try {
      var docData = await refId.get();
      Map<String, dynamic> data = docData.data() as Map<String, dynamic>;
      data.addAll({'reference': refId});
      var doc = await UserModel.fromJson(data);
      yield doc;
    } catch (e) {
      print("Error fetching products: $e");
      yield null;
    }
  }

  Stream<Product?> getProduct({required DocumentReference refId}) async* {
    try {
      var docData = await refId.get();
      Map<String, dynamic> data = docData.data() as Map<String, dynamic>;
      data.addAll({'reference': refId});
      var doc = await Product.fromJson(data);
      yield doc;
    } catch (e) {
      print("Error fetching products: $e");
      yield null;
    }
  }
  Stream<ProductList?> getAllProducts() async* {
    try {
      var productListFromFB = await FirebaseFirestore.instance
          .collection("product")
          .get();
      List<Product> productList = [];
      for (var doc in productListFromFB.docs) {
        Map<String, dynamic> data = doc.data();
        DocumentReference category = doc.get('categoryRef');
        var categorydoc = await category.get();
        data.addAll({"referenace": doc.reference,'category' : categorydoc.get('name')});
        var product = Product.fromJson(data);
        currentUserDocument!.type != "Admin" && product.status == "Accept" ?productList.add(product):null;
        currentUserDocument!.type == "Admin" ?productList.add(product):null;
      }
      ProductList productListInstance = ProductList(products: productList);
      yield productListInstance;
    } catch (e) {
      print("Error fetching products: $e");
      yield null;
    }
  }
  Stream<ProductList?> getProductDocuments(
      {required DocumentReference shopRef, required bool available, required bool forCategories,String? cateName}) async* {
    try {
      print("productListFromFB ================================>");
      var productListFromFB = await FirebaseFirestore.instance
          .collection("product")
          .where(forCategories?"categoryRef": "shopReference", isEqualTo: shopRef)
          .get();
      print("productListFromFB ------>$productListFromFB");
      List<Product> productList = [];
      for (var doc in productListFromFB.docs) {
        Map<String, dynamic> data = doc.data();
        var categoryName;
        if(!forCategories){
          DocumentReference category = doc.get('categoryRef');
          var categorydoc = await category.get();
          categoryName = categorydoc.get('name');
        }
        else{
          categoryName = cateName;
        }
        data.addAll({"referenace": doc.reference,'category' : forCategories ? cateName : categoryName});
        var product = Product.fromJson(data);
        currentUserDocument!.type != "Admin" && product.status == "Accept" ?productList.add(product):null;
        currentUserDocument!.type == "Admin" ?productList.add(product):null;
      }
      ProductList productListInstance = ProductList(products: productList);
      yield productListInstance;
    } catch (e) {
      print("Error fetching products: $e");
      yield null;
    }
  }

  Stream<List<categoryModel>?> getCategory() async* {
    try {
      var category =
          await FirebaseFirestore.instance.collection("category").get();
      List<categoryModel> categorytList = [];
      for (var doc in category.docs) {
        Map<String, dynamic> docdata = doc.data();
        docdata.addAll({"refereance":doc.reference});
        categorytList
            .add(categoryModel.fromJson(docdata));
      }
      yield categorytList;
    } catch (e) {
      print("Error fetching products: $e");
      yield null;
    }
  }


  Stream<List<ProductRequest>?> getrequestProducts() async* {
    try {
      var category =
      await FirebaseFirestore.instance.collection("ProductRequest").orderBy("time",descending: true).get();
      List<ProductRequest> requestList = [];
      for (var doc in category.docs) {
        Map<String, dynamic> docdata = doc.data();
        docdata.addAll({"refereance":doc.reference});
        requestList
            .add(ProductRequest.fromJson(docdata));
      }
      yield requestList;
    } catch (e) {
      print("Error fetching products: $e");
      yield null;
    }
  }

  Stream<List<UserModel>?> getShopKeepe_Doctore(
      {required bool shopkeeper,required bool fromMap}) async* {
    try {
      var user = !fromMap ? await FirebaseFirestore.instance
          .collection("User")
          .where("approve", isEqualTo: true)
          .where("type", isEqualTo: shopkeeper ? "ShopKeeper" : "Doctore")
          .where('zipCode',isEqualTo: selectedZipCode).get() :
      await FirebaseFirestore.instance
          .collection("User")
          .where("approve", isEqualTo: true)
          .where("type", isEqualTo: shopkeeper ? "ShopKeeper" : "Doctore").get();


      List<UserModel> userList = [];
      for (var doc in user.docs) {
        Map<String, dynamic> data = doc.data();
        data.addAll({"reference": doc.reference});
        userList.add(UserModel.fromJson(data as Map<String, dynamic>));
      }
      userList.sort((a, b) => a.distanc.compareTo(b.distanc));
      yield userList;
    } catch (e) {
      print("Error fetching products: $e");
      yield null;
    }
  }



  crudOperations(
      {required String productID,
      required String image,
      required String name,
      required String price,
      required String description,
      required bool available,
      required String crudType,
      required String status,
      required DocumentReference categoryReferance

      }) async {
    var fb = await FirebaseFirestore.instance.collection("product");
    Map<String, dynamic> mapdata = crudType != "del"
        ? {
            'image': image,
            'name': name,
            'price': price,
            'description': description,
            'available': available,
            'categoryRef': categoryReferance,
            'shopReference': currentUserDocument!.reference,
             'status' : "Accept"
          }
        : {};
    switch (crudType) {
      case "add":
        fb.doc().set(mapdata);
      case "update":
        fb.doc(productID).update(mapdata);
      case "del":
        fb.doc(productID).delete();
    }
  }


  Stream<RateList?> getRateDocuments(
      {required DocumentReference shopRef}) async* {
    try {
      var productListFromFB = await FirebaseFirestore.instance
          .collection("rate")
          .where("userReference", isEqualTo: shopRef)
          .get();
      List<RateModel> ratetList = [];
      for (var doc in productListFromFB.docs) {
        ratetList.add(RateModel.fromJson(doc.data()));
      }
      RateList productListInstance = RateList(rate: ratetList);
      productListInstance.rate.sort((a, b) => a.date.compareTo(b.date));
      yield productListInstance;
    } catch (e) {
      print("Error fetching products: $e");
      yield null;
    }
  }

  Stream<List<ChatModel>?> getchatList() async* {
    try {
      var data = await FirebaseFirestore.instance
          .collection("chat")
          .where(
              "${currentUserDocument!.type == "User" ? "user" : "otherUser"}",
              isEqualTo: currentUserDocument!.reference)
          .get();
      List<ChatModel> chats = [];
      for (var doc in data.docs) {
        Map<String, dynamic> data = doc.data();
        data.addAll({"reference": doc.reference});
        var userDoc = ChatModel.fromJson(data);
        (currentUserDocument!.type == "User" &&
                    userDoc.userMessageList!.length != 0) ||
                (currentUserDocument!.type != "User" &&
                    userDoc.messageList!.length != 0)
            ? chats.add(userDoc)
            : null;
      }
      chats.sort((a, b) => a.lastMessageTime!.compareTo(b.lastMessageTime!));
      yield chats;
    } catch (e) {
      print("Error fetching products: $e");
      yield null;
    }
  }

  Stream<ChatModel?> getchat({required DocumentReference chatRef}) async* {
    try {
      var doc = await chatRef.get();
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data.addAll({"reference": doc.reference});
      print("data ---->$data");
      yield ChatModel.fromJson(data);
    } catch (e) {
      print("Error fetching products: $e");
      yield null;
    }
  }

// senChat(){
//   var mapdata = {
//     "user" : ,
//     "otherUser" : ,
//     "last_message" : ,
//     "last_message_time" : ,
//     "messageList" : [
//       {
//         'sender': ,
//         'receiver': ,
//         'message': ,
//         'messageTime': ,
//         'seenByReceiver': ,
//       }
//     ],
//     "userMessageList":[
//       {
//         'sender': ,
//         'receiver': ,
//         'message': ,
//         'messageTime': ,
//         'seenByReceiver': ,
//       }
//     ]
//   };
// }
}
