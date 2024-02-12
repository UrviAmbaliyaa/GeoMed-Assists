import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              onMapCreated: (controller) {
                mapController = controller;
                // Call a function to get the user's current location and set the initial marker.
                _getUserLocation();
              },
              markers: markers,
              initialCameraPosition: CameraPosition(
                target: LatLng(0, 0),
                zoom: 15.0,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20,left: 20,right: 20),
              child: customeTextFormField(
                autofillHint: [
                  AutofillHints.fullStreetAddress
                ],
                contoller: searchController,
                hintTest: 'Search Location',
                keybordType: TextInputType.streetAddress,
                password: false,
                passwordvisiblity: false,
                sufixIcon: Icon(Icons.location_on_outlined,size: 30,color: AppColor.textColor),
                validation: (value) {
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to get the user's current location and set the initial marker.
  Future<void> _getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    mapController.animateCamera(CameraUpdate.newLatLng(LatLng(
      position.latitude,
      position.longitude,
    )));

    _addMarker(
      LatLng(position.latitude, position.longitude),
      'Current Location',
      'You are here!',
    );
  }

  // Function to add a marker to the map.
  void _addMarker(LatLng position, String title, String snippet) {
    final Marker marker = Marker(
      markerId: MarkerId(position.toString()),
      position: position,
      infoWindow: InfoWindow(
        title: title,
        snippet: snippet,
      ),
    );

    setState(() {
      markers.add(marker);
    });
  }

  // Function to perform the search and update the map.
  void _searchLocation() async {
    String address = searchController.text;
    List<Location> locations =
    await locationFromAddress(address);


    if (locations != null && locations.length != 0 ) {
      Location location = locations.first;
      LatLng position = LatLng(location.latitude, location.longitude);
      mapController.animateCamera(CameraUpdate.newLatLng(position));
      _addMarker(
        position,
        address,
        '',
      );
    }
  }
}