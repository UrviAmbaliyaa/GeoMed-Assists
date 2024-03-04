import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geomed_assist/Firebase/firebase_quaries.dart';
import 'package:geomed_assist/Models/user_model.dart';
import 'package:geomed_assist/User_flow/BottonTabbar.dart';
import 'package:geomed_assist/User_flow/doctoreDetail.dart';
import 'package:geomed_assist/User_flow/shopDetailScreen.dart';
import 'package:geomed_assist/constants/Appcolors.dart';
import 'package:geomed_assist/constants/constantWidgets.dart';
import 'package:geomed_assist/constants/constantdata.dart';
import 'package:geomed_assist/constants/customTextField.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  TextEditingController searchController = TextEditingController();
  Set<Marker> markers = Set();
  List<UserModel> shops_doctores = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMarkers();
  }

  Future<void> getMarkers() async {
    await Permission.location.request();
    await Permission.locationAlways.request();
    await Permission.locationWhenInUse.request();
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    mapController.animateCamera(CameraUpdate.newLatLng(LatLng(
      position.latitude,
      position.longitude,
    )));
    Marker marker1 = addMarker(
      id: "0",
      latlong: LatLng(position.latitude, position.longitude),
      title: "Current Location",
      address: "You are here..",
    );
    markers.add(marker1);
    shops_doctores = await Firebase_Quires()
            .getShopKeepe_Doctore(shopkeeper: true, fromMap: true)
            .first ??
        [];
    shops_doctores.addAll(await Firebase_Quires()
            .getShopKeepe_Doctore(shopkeeper: false, fromMap: true)
            .first ??
        []);
    for (UserModel doc in shops_doctores) {
      LatLng lng = LatLng(doc.latLong!, doc.longitude!);
      var marker = addMarker(
          id: doc.reference.id,
          latlong: lng,
          title: doc.name,
          address: doc.address!,
          data: doc);
      markers.add(marker);
    }
    setState(() {});
  }

  addMarker(
      {required String id,
      required LatLng latlong,
      required String title,
      required String address,
      UserModel? data}) {
    return Marker(
      markerId: MarkerId(id),
      position: latlong,
      infoWindow: InfoWindow(
        title: title,
        snippet: address,
      ),
      onTap: () {
        print("===========================================?");
        id != 0
            ? Navigator.of(context, rootNavigator: true).push(
                CupertinoPageRoute<bool>(
                  fullscreenDialog: true,
                  builder: (BuildContext context) => data!.type == "ShopKeeper"
                      ? shopDetailScreen(data: data)
                      : doctoreDetail(doctor: data),
                ),
              )
            : null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        exit(0);
      },
      child: Scaffold(
        backgroundColor: AppColor.backgroundColor,
        body: SafeArea(
          child: Stack(
            children: [
              GoogleMap(
                onMapCreated: (controller) {
                  mapController = controller;
                  getMarkers();
                },
                markers: markers,
                initialCameraPosition: CameraPosition(
                  target: LatLng(0, 0),
                  zoom: 12.0,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15, left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: customeTextFormField(
                        autofillHint: [],
                        readOnly: false,
                        contoller: searchController,
                        hintTest: 'Enter Zip Code',
                        keybordType: TextInputType.number,
                        password: false,
                        passwordvisiblity: false,
                        sufixIcon: Icon(Icons.location_on_outlined,
                            size: 30, color: AppColor.textColor),
                        validation: (value) {},
                        onchageAction: () =>
                            Future.delayed(Duration(seconds: 3), () async {
                              print("shops_doctores ------>${shops_doctores}");
                          if (searchController.text.trim().length >= 5) {
                            markers.clear();
                            var searchdata = shops_doctores.where((element) {
                              return element.zipCode ==
                                  searchController.text.trim();
                            });
                            selectedZipCode = searchController.text;
                            if (searchdata.length != 0) {
                              for (UserModel doc in searchdata) {
                                LatLng lng =
                                    LatLng(doc.latLong!, doc.longitude!);
                                var marker = addMarker(
                                    id: doc.reference.id,
                                    latlong: lng,
                                    title: doc.name,
                                    address: doc.address!,
                                    data: doc);
                                markers.add(marker);
                              }

                              _searchLocation(
                                  location: LatLng(searchdata.first.latLong!,
                                      searchdata.first.longitude!),
                                  id: searchdata.first.reference.id);
                            }
                          }
                        }),
                      ),
                    ),
                    searchController.text.trim().length > 4
                        ? Container(
                            margin: EdgeInsets.only(left: 10),
                            child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .push(
                                    CupertinoPageRoute<bool>(
                                        fullscreenDialog: true,
                                        builder: (BuildContext context) =>
                                            bottomTabBar()),
                                  );
                                },
                                style: ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(
                                        AppColor.inputTextfill),
                                    padding: MaterialStatePropertyAll(
                                        EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 14)),
                                    shape: MaterialStatePropertyAll(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12)))),
                                child: Text(
                                  "See All",
                                  style: TextStyle(
                                      color: AppColor.textColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                )),
                          )
                        : SizedBox.shrink()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to get the user's current location and set the initial marker.

  // Function to perform the search and update the map.
  void _searchLocation({required LatLng location, required String id}) async {
    LatLng position = LatLng(location.latitude, location.longitude);
    mapController.animateCamera(CameraUpdate.newLatLng(position));
    mapController.showMarkerInfoWindow(MarkerId(id));
    setState(() {});
  }
}
