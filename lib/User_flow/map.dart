import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geomed_assist/Firebase/firebase_quaries.dart';
import 'package:geomed_assist/Models/user_model.dart';
import 'package:geomed_assist/constants/Appcolors.dart';
import 'package:geomed_assist/constants/constantWidgets.dart';
import 'package:geomed_assist/constants/customTextField.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  }

  Future<void> getMarkers() async {
    print("==========================================");

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
        address: "You are here..");
    markers.add(marker1);
    shops_doctores =
        await Firebase_Quires().getShopKeepe_Doctore(shopkeeper: true).first ??
            [];
    shops_doctores.addAll(
        await Firebase_Quires().getShopKeepe_Doctore(shopkeeper: false).first ??
            []);
    for (UserModel doc in shops_doctores) {
      LatLng lng = LatLng(doc.latLong, doc.longitude);
      var marker = addMarker(
          id: doc.reference.id,
          latlong: lng,
          title: doc.name,
          address: doc.address);
      markers.add(marker);
    }
    setState(() {});
  }

  addMarker(
      {required String id,
      required LatLng latlong,
      required String title,
      required String address}) {
    print("latlong ---->${latlong}");

    return Marker(
      markerId: MarkerId(id),
      position: latlong,
      infoWindow: InfoWindow(
        title: title,
        snippet: address,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(bottom: 50),
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
                  zoom: 13.0,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                child: customeTextFormField(
                  autofillHint: [AutofillHints.fullStreetAddress],
                  readOnly: false,
                  contoller: searchController,
                  hintTest: 'Search Location',
                  keybordType: TextInputType.streetAddress,
                  password: false,
                  passwordvisiblity: false,
                  sufixIcon: Icon(Icons.location_on_outlined,
                      size: 30, color: AppColor.textColor),
                  validation: (value) {},
                  onchageAction: () =>
                      Future.delayed(Duration(seconds: 1), () async {
                    if (searchController.text.trim().length != 0) {
                      var searchdata = shops_doctores.where((element) {
                        return element.address.toUpperCase().contains(
                                searchController.text.trim().toUpperCase()) ||
                            element.name.toUpperCase().contains(
                                searchController.text.trim().toUpperCase());
                      });
                      if (searchController.text
                          .toUpperCase()
                          .contains("CURRENT")) {
                        Position position = await Geolocator.getCurrentPosition(
                          desiredAccuracy: LocationAccuracy.high,
                        );

                        _searchLocation(
                            location: LatLng(position.latitude,
                                position.longitude),
                            id: "0");
                      }
                      searchdata.length != 0
                          ? _searchLocation(
                              location: LatLng(searchdata.first.latLong,
                                  searchdata.first.longitude),
                              id: searchdata.first.reference.id)
                          : null;
                    }
                  }),
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
