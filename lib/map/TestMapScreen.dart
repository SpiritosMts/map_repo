import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:typed_data';

class SimpleMap2 extends StatefulWidget {
  @override
  _SimpleMap2 createState() => _SimpleMap2();
}
class _SimpleMap2 extends State<SimpleMap2> {
  static GoogleMapController? _googleMapController;
  Set<Marker> markers = Set();

  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  late GoogleMapController newGoogleMapController;

  //Direction? _info;

  List<LatLng> pointsNew = [];

  late LatLng latLng;
  late LatLng latLatPosition;
  late Position currentPosition;
  var geoLocator = Geolocator();
  double bottomPaddingOfMap = 0;

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  static const CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(40.7956, 29.4420),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("coords").snapshots(),
            builder: (context, snapshot) {
              // ignore: avoid_print;

                print(snapshot);
                if (snapshot.hasData) {
                  //Extract the location from document
                  var locationList = snapshot.data!.docs.toList();
                  //GeoPoint location = snapshot.data!.docs.first.get("location");

                  List<GeoPoint> createLocationList = [];
                  for (int i = 0; i < locationList.length; i++) {
                    GeoPoint findLocation = locationList[i].get("pos");

                    createLocationList.add(findLocation);
                  }

                  // Check if location is valid
                  // ignore: unnecessary_null_comparison
                  if (createLocationList[0] == null) {
                    return const Text("There was no location data");
                  }

                  // Remove any existing markers
                  markers.clear();

                  for (int i = 0; i < createLocationList.length; i++) {
                    //createLocationList

                    latLng = LatLng(createLocationList[i].latitude, createLocationList[i].longitude);

                    String? title1 = locationList[i].get("title");
                    String? snippet1 = locationList[i].get("title");

                    markers.add(Marker(
                      markerId: const MarkerId("location"),
                      position: latLng,
                      infoWindow: InfoWindow(title: title1, snippet: snippet1),
                    ));
                  }
                  _googleMapController?.animateCamera(CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: latLng,
                      zoom: 1,
                    ),
                  ));
                  return Stack(alignment: Alignment.center, children: [
                    GoogleMap(
                        padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
                        mapType: MapType.normal,
                        myLocationButtonEnabled: true,
                        markers: markers,
                        initialCameraPosition: _kGooglePlex,
                        myLocationEnabled: true,
                        zoomGesturesEnabled: true,
                        zoomControlsEnabled: true,
                        onMapCreated: (GoogleMapController controller) {
                          _controllerGoogleMap.complete(controller);
                          newGoogleMapController = controller;
                        })
                  ]);
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
            },
        )
    );
  }
}

class SimpleMap extends StatefulWidget {

  @override
  _SimpleMapState createState() => _SimpleMapState();
}
class _SimpleMapState extends State<SimpleMap> {


  bool finishMarkersLoad =false;
  double _currentPositionLat = 0.0 ;
  double _currentPositionLng = 0.0;

  Completer<GoogleMapController> _googleMapController = Completer();
  //Set<Marker> markers = Set();
  Map<MarkerId , Marker> fBMarkers = <MarkerId , Marker>{};
  final FirebaseFirestore _database = FirebaseFirestore.instance;

  getMarkerData() async {
    _database.collection('garages').get().then((docs) {
      if(docs.docs.isNotEmpty) {
        for(int i = 0; i < docs.docs.length ; i++){
          initMarker(docs.docs[i].data , docs.docs[i].id);
        }
      }
    });
  }

  void initMarker(specify , specifyId) async {
    var markerIdVal = specifyId;
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
        markerId: markerId,
        position: LatLng(specify['latitude'] , specify['longitude']),
        //infoWindow: InfoWindow(title: 'New Marker' , snippet: specify['address']),
        infoWindow: InfoWindow(title: 'New Marker' , snippet: 'snippet'),

    );
    setState(() {
      fBMarkers[markerId] = marker;
    });
  }
  void getCurrentLocation() async {
    /*
    Position _currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPositionLat = _currentPosition.latitude;
      _currentPositionLng = _currentPosition.longitude;
      //_initialPosition = LatLng(_currentPositionLat, _currentPositionLng);
    });
    */

    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((currloc) {
      setState(() {
        _currentPositionLat = currloc.latitude;
        _currentPositionLng = currloc.longitude;
        finishMarkersLoad = true;
      });
    });
  }
@override
  void initState() {

    getMarkerData();
    getCurrentLocation();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder(
        stream: _database.collection("garages").snapshots(),
        builder: (context, snapshot) {
          print(snapshot);
          if (snapshot.hasData) {
            // GeoPoint location = (snapshot.data! as QuerySnapshot).docs.first.get("pos");
            // if (location == null) {
            //   return Text("There was no location data");
            // }
            // markers.clear();
            // final latLng = LatLng(location.latitude, location.longitude);

            //markers.add(Marker(markerId: MarkerId("pos"), position: latLng));
/*
            // If google map is already created then update camera position with animation
            _googleMapController?.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(
                target: latLng,
                zoom: 1,
              ),
            ));
*/
            return
              Container(
                child:  (finishMarkersLoad =false)? Center(child: CircularProgressIndicator()):
                GoogleMap(
                initialCameraPosition: CameraPosition(
                    target: LatLng(18, 2)),
                // Markers to be pointed
                markers: Set<Marker>.of(fBMarkers.values),
                onMapCreated: (GoogleMapController controller) {
                  _googleMapController.complete(controller);
                },
            ),
              );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

