import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart'; //import from pub.dev
import 'package:google_maps_flutter/google_maps_flutter.dart'; //import from pub.dev
import 'geoLocator.dart'; // get current position
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as geocod;
import 'package:flutter/services.dart';
import 'package:geocode/geocode.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class GoogleMapScreen extends StatefulWidget {

  final bool editable;
  final Position? previouslySavedPosition;

  GoogleMapScreen({this.editable = false, this.previouslySavedPosition});

  @override
  _GoogleMapScreenState createState() => _GoogleMapScreenState();
}
class _GoogleMapScreenState extends State<GoogleMapScreen> {

  /// default marker location sousse
  static double initLat = 35.821430;
  static double initLng = 10.634422;
  static String theAddress = ""; // create this variable
  static String theAddressGeocode = ""; // create this variable

  /// markers array
  final Map<String, Marker> _markers = {};
  Completer<GoogleMapController> _controller = Completer();

  // Create a CollectionReference called users that references the firestore collection
  CollectionReference garages = FirebaseFirestore.instance.collection('garages');

  Future<void> addGarage() {
    // Call the user's CollectionReference to add a new user
    return garages.add({
      'address(Geo)': theAddressGeocode, // John Doe
      'address': theAddress, // John Doe
      'latitude': initLat, // Stokes and Sons
      'longitude': initLng // 42
    })
        .then((value) => print("Garage Added"))
        .catchError((error) => print("Failed to add garage: $error"));
  }

  @override
  void initState() {
    super.initState();
    _markers.clear();

    /// update lat & long with old data
    if (widget.previouslySavedPosition != null) {
      setMarker(widget.previouslySavedPosition!.latitude, widget.previouslySavedPosition!.longitude, widget.editable);
    } else {
      /// get current position
      determinePosition().then((newPosition) {
        if (newPosition != null) {
          /// update lat & long with new data from map
          setMarker(newPosition.latitude, newPosition.longitude, widget.editable);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            /// the main google map card
            GoogleMap(
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              onTap: (p) => setMarker(p.latitude, p.longitude, true),
              onMapCreated: (GoogleMapController controller) => _controller.complete(controller),
              initialCameraPosition: CameraPosition(target: LatLng(initLat, initLng), zoom: 16.0),
              markers: _markers.values.toSet(),
            ),

            /// a save button that returns chosen position
            Container(
              margin: EdgeInsets.symmetric(horizontal: 70, vertical: 20),
              child: ElevatedButton(
                onPressed: () {
                  Fluttertoast.showToast(msg: '$theAddressGeocode');
                  //Fluttertoast.showToast(msg: 'position = $lat - $lng');
                  Navigator.pop(context, 'hiii!');
                  addGarage();
                },
                child: Container(
                  child: Text('save position'),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// set marker on map with coordinates
  void setMarker(double lat, double long, bool editable) async {
    /// create a new marker
    final marker = Marker(
      draggable: editable,
      onDragEnd: (value) => setMarker(value.latitude, value.longitude, editable),
      markerId: MarkerId('curr_loc'),
      position: LatLng(lat, long),
    );



    /// save the position and marker to the State
    setState(() {
      ///update the address string
      _getAdressFromLatLng(lat,long);
      _getAdressFromLatLngGeocode(lat,long);
      initLat = lat;
      initLng = long;
      _markers.clear();
      _markers['Current Location'] = marker;
    });

    /// update map camera position // get th last setted marker if its setted, else set sousse location
    final CameraPosition cameraPosition = CameraPosition(
      target: LatLng(lat, long),
      zoom: 18,
    );

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }


  void _getAdressFromLatLng(double lat,double lng) async {
    List<geocod.Placemark> newPlace = await geocod.placemarkFromCoordinates(lat, lng);

    // this is all you need
    geocod.Placemark placeMark = newPlace[0];
    String? name = placeMark.name;
    String? subLocality = placeMark.subLocality;
    String? locality = placeMark.locality;
    String? administrativeArea = placeMark.administrativeArea;
    String? postalCode = placeMark.postalCode;
    String? street = placeMark.street;
    String address = "ADRESS = name:${name}/ subLocality:${subLocality}/ locality:${locality}/ administrativeArea:${administrativeArea}/ postalCode:${postalCode}/ street:{$street}/";

    print(address);

    setState(() {
      theAddress = address; // update _address
    });
  }

  Future<String> _getAdressFromLatLngGeocode(double? lat, double? lang) async {
    if (lat == null || lang == null) return "Null_Adress";
    GeoCode geoCode = GeoCode();
    Address address = await geoCode.reverseGeocoding(latitude: lat, longitude: lang);
    String _address ="ADRESS(Geocode) = streetAddress:${address.streetAddress}/ city:${address.city}/ region:${address.region}/ postal:${address.postal}/ streetNumber:${address.streetNumber}/";
    print(_address);
    setState(() {
      theAddressGeocode = _address; // update _address
    });
    return _address;
  }
}
