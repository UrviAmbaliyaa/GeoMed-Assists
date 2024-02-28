import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geomed_assist/constants/constantWidgets.dart';
import 'package:geomed_assist/constants/constantdata.dart';
import '../Models/user_model.dart';

class firebase_auth{

  Future<String?> uploadImage(File imageFile, {bool? product = false}) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageReference =
      await FirebaseStorage.instance.ref().child('${product!?"Product":"Profiles"}/$fileName.jpg');
      await storageReference.putFile(imageFile, SettableMetadata(
        contentType: "image/jpeg",
      ));
      String imageUrl = await storageReference.getDownloadURL();
      print("imageUrl ----->${imageUrl}");
      return imageUrl;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> signUpWithEmailAndPassword(String email, String password,Map<String, dynamic> mapdata,context) async {
    try {
      var result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
       await FirebaseFirestore.instance.collection("User").doc(result.user!.uid).set(mapdata);
    } catch (e) {
      var message = e.toString().split("]");
      constWidget().showSnackbar(message[1], context);
      print(e);
    }
  }

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      var value =  await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await getUserInfo(id: value.user!.uid);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> SignOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<UserModel?> getUserInfo({required String id}) async {
   var users = await FirebaseFirestore.instance.collection("User").doc(id).get();
   var mapdata = users.data()!;
   mapdata.addAll({"reference":users.reference});
   currentUserDocument = await UserModel.fromJson(mapdata);
   return currentUserDocument;
  }

  updateData({required DocumentReference reference,required Map<String, dynamic> jsondata}) async {
    try{
      await reference.update(jsondata as Map<Object, Object?>);
      Map<String, dynamic> mapdata = jsondata;
      mapdata.addAll({"reference":reference});
      currentUserDocument = await UserModel.fromJson(mapdata);
    }catch(error){
      print("Error =====>${error}");
    }
  }
}
