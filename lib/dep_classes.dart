import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
//import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:location/location.dart';
//import 'package:geocoder/geocoder.dart';
//import "package:latlong/latlong.dart" as LatLng;
import 'package:http/http.dart';





//depricated
/*
/*
class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late StreamSubscription _locationSubscription;
  Location _locationTracker = Location();
  late Marker marker ;
  late Circle circle;
  GoogleMapController _controller;

  String location = '';
  RxList mapList = <OffersModel>[];
  var isLoading = true;

  final allOfferCollection = FirebaseFirestore.instance.collection('all-offers');

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{
  };

  void initState() {
    getMarkerData();
    super.initState();
  }

  void initOffer(specify, specifyId) async
  {
    var p=specify['location'];
    var markerIdVal = specifyId;
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
        markerId: markerId,
        position: LatLng(p['location'].latitude, p['location'].longitutde),
        infoWindow: InfoWindow(title: specify['name'], snippet: specify['location'])
    );
    setState(() {
      markers[markerId] = marker;
    });
  }

  Future<DocumentReference> getMarkerData() async {
    try {
      allOfferCollection.get().then((snapshot) {
        print(snapshot);
        if(snapshot.docs.isNotEmpty){
          for(int i= 0; i < snapshot.docs.length; i++)
          {
            initOffer(snapshot.docs[i].data, snapshot.docs[i].id);
          }
        }
        snapshot.docs
            .where((element) => element["location"] == location)
            .forEach((element) {
          if (element.exists) {
            mapList.add(OffersModel.fromJson(element.data(), element.id));
          }
        });
      });
    } finally {
      isLoading(false);
    }
  }

  static final CameraPosition initialLocation = CameraPosition(
    target: LatLng(36.723062, 3.087800),
    zoom: 14.4746,
    // zoom: 14,

  );

  Future<Uint8List> getMarker() async {
    ByteData byteData = await DefaultAssetBundle.of(context).load("assets/marker.png");
    return byteData.buffer.asUint8List();
  }

  void updateMarkerAndCircle(LocationData newLocalData, Uint8List imageData) {
    LatLng latlng = LatLng(newLocalData.latitude, newLocalData.longitude);
    this.setState(() {
      marker = Marker(
          markerId: MarkerId("home"),
          position: latlng,
          rotation: newLocalData.heading,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(imageData));

    });
  }

  // void getCurrentLocation() async {
  //   try {
  //
  //     Uint8List imageData = await getMarker();
  //     var location = await _locationTracker.getLocation();
  //
  //     updateMarkerAndCircle(location, imageData);
  //
  //     if (_locationSubscription != null) {
  //       _locationSubscription.cancel();
  //     }
  //
  //     _locationSubscription = _locationTracker.onLocationChanged().listen((newLocalData) {
  //       if (_controller != null) {
  //         _controller.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
  //             bearing: 192.8334901395799,
  //             target: LatLng(newLocalData.latitude, newLocalData.longitude),
  //             tilt: 0,
  //             zoom: 18.00
  //         )));
  //         updateMarkerAndCircle(newLocalData, imageData);
  //       }
  //     });
  //
  //   } on PlatformException catch (e) {
  //     if (e.code == 'PERMISSION_DENIED') {
  //       debugPrint("Permission Denied");
  //     }
  //   }
  // }

  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: initialLocation,
          markers: Set.of((marker != null) ? [marker] : []),
          // circles: Set.of((circle != null) ? [circle] : []),
          onMapCreated: (GoogleMapController controller) {
            setState(() {
              _controller = controller;
            });
          },
          myLocationEnabled: true,
          compassEnabled: true,

        ),
      ),
    );
  }
}

*/


class GetMarkers extends StatefulWidget {
  const GetMarkers({Key? key}) : super(key: key);

  @override
  _GetMarkersState createState() => _GetMarkersState();
}
class _GetMarkersState extends State<GetMarkers> {

  Completer<GoogleMapController> mapController = Completer();
  Set<Marker> markers = Set();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Location").snapshots(),
        builder: (context, snapshot) {
          print(snapshot);
          if (snapshot.hasData) {
            //Extract the location from document
            GeoPoint location = snapshot.data.docs.first.get("location");

            // Check if location is valid
            if (location == null) {
              return Text("There was no location data");
            }

            // Remove any existing markers
            markers.clear();

            final latLng = LatLng(location.latitude, location.longitude);

            // Add new marker with markerId.
            markers
                .add(Marker(markerId: MarkerId("location"), position: latLng));

            // If google map is already created then update camera position with animation
            mapController?.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(
                target: latLng,
                zoom: 1,
              ),
            ));

            return GoogleMap(
              initialCameraPosition: CameraPosition(
                  target: LatLng(location.latitude, location.longitude)),
              // Markers to be pointed
              markers: markers,
              onMapCreated: (GoogleMapController controller) {
                mapController.complete(controller);
              },
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

void _currentLocation() async {
    final GoogleMapController controller = await _controller.future;
    LocationData currentLocation;
    var location = new Location();
    try {
      currentLocation = await location.getLocation();
    } on Exception {
      currentLocation = null;
    }

    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(currentLocation.latitude, currentLocation.longitude),
        zoom: 17.0,
      ),
    ));
  }
getUserLocation() async {//call this async method from whereever you need

    LocationData myLocation;
    String error;
    Location location = Location();
    try {
      myLocation = await location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'please grant permission';
        print(error);
      }
      if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error = 'permission denied- please enable it from app settings';
        print(error);
      }
      myLocation = null;
    }
    currentLocation = myLocation;
    final coordinates = new Coordinates(
        myLocation.latitude, myLocation.longitude);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(
        coordinates);
    var first = addresses.first;
    print(' ${first.locality}, ${first.adminArea},${first.subLocality}, ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}');
    return first;
  }


class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}
class _MapScreenState extends State<MapScreen> {

  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Geoflutterfire geo = Geoflutterfire();
  late GoogleMapController mapController;

  void onMapCreated(GoogleMapController controller) async {
    setState(() {
      Location _location = Location();
      mapController = controller;
      _location.onLocationChanged.listen((l) {
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(l.latitude?? 40.730610, l.longitude?? -73.935242), zoom: 16.0),
          ),
        );
      });
    });
  }

  initMarker(request, requestId) {
    var p = request['location'];
    var d = request['name'];
    var markerIdVal = requestId;
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
        markerId: markerId,
        position: LatLng(p.latitude, p.longitude),
        infoWindow: InfoWindow(
          title: d['name']
            ));
    setState(() {
      _markers[markerId] = marker;
    });
  }

  _populateMarks() {
    FirebaseFirestore.instance.collection('markers').get().then((docs) {
      if (docs.docs.isNotEmpty) {
        for (int i = 0; i < docs.docs.length; ++i) {
          initMarker(docs.docs[i].data, docs.docs[i].id);
        }
      }
    });
  }

  CameraPosition _initialCamera = CameraPosition(
    target: LatLng(59.334591, 18.063240),
    zoom: 10.0000,
  );

  @override
  void initState() {
    _populateMarks();
    super.initState();
  }
//####################################################################
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: <Widget>[
      GoogleMap(
        markers: Set<Marker>.of(_markers.values),
        onMapCreated: onMapCreated,
        mapType: MapType.terrain,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        initialCameraPosition: _initialCamera,
      )
    ]));
  }
}


class RetrievingMarkers extends StatefulWidget {
  const RetrievingMarkers({Key? key}) : super(key: key);

  @override
  _RetrievingMarkersState createState() => _RetrievingMarkersState();
}
class _RetrievingMarkersState extends State<RetrievingMarkers> {
  List<Marker> allMarkers = [];

  setMarker() {
    return allMarkers;
  }

  addToList() async {
    final query = "Englewood, New York";
    var adresses = await Geocoder.local.findAddressesFromQuery(query);
    var first = adresses.first;
    setState(() {
      allMarkers.add(Marker(
        width: 45.0,
        height: 45.0,
        point: LatLng.LatLng(first.coordinates.latitude, first.coordinates.longitude),
        builder: (context) => Container(
          child: IconButton(
            icon: Icon(Icons.location_on),
            color: Colors.green,
            iconSize: 45.0,
            onPressed: () {
              print(first.featureName);
            },
          ),
        ),
      ));
    });
  }

  Future addMarker() async {
    await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text(
              'Add Marker',
              style: TextStyle(
                fontSize: 17.0,
              ),
            ),
            children: <Widget>[
              SimpleDialogOption(
                child: Text(
                  'Add It',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
                onPressed: () {
                  addToList();
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Firebase Coords'),
        leading: IconButton(
          icon: Icon(Icons.add),
          onPressed:() {
            addMarker();
          },
        ),
        centerTitle: true,
      ),
      body: FlutterMap(
        options: MapOptions(center: LatLng.LatLng(40.71, -74.00), minZoom: 10.0),
        layers: [
          TileLayerOptions(urlTemplate: "http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", subdomains: ['a', 'b', 'c']),
          MarkerLayerOptions(markers: setMarker())
        ],
      ),
    );
  }
}

/// Retrieving_Markers_2
class GetMarkers2 extends StatefulWidget {

  @override
  _GetMarkers2State createState() => _GetMarkers2State();
}
class _GetMarkers2State extends State<GetMarkers2> {
  late StreamSubscription _locationSubscription;
  Location _locationTracker = Location();
  late Marker marker;
  late Circle circle;
  late GoogleMapController _controller;

  late String location;
  RxList mapList = <OffersModel>[].obs;
  var isLoading = true.obs;

  final allOfferCollection = FirebaseFirestore.instance.collection('all-offers');

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{
  };

  void initState() {
    getMarkerData();
    super.initState();
  }

  void initOffer(specify, specifyId) async
  {
    var p=specify['location'];
    var markerIdVal = specifyId;
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
        markerId: markerId,
        position: LatLng(p['location'].latitude, p['location'].longitutde),
        infoWindow: InfoWindow(title: specify['name'], snippet: specify['location'])
    );
    setState(() {
      markers[markerId] = marker;
    });
  }

  Future<DocumentReference> getMarkerData() async {
    try {
      allOfferCollection.get().then((snapshot) {
        print(snapshot);
        if(snapshot.docs.isNotEmpty){
          for(int i= 0; i < snapshot.docs.length; i++)
          {
            initOffer(snapshot.docs[i].data, snapshot.docs[i].id);
          }
        }
        snapshot.docs
            .where((element) => element["location"] == location)
            .forEach((element) {
          if (element.exists) {
            mapList.add(OffersModel.fromJson(element.data(), element.id));
          }
        });
      });
    } finally {
      isLoading(false);
    }
  }

  static final CameraPosition initialLocation = CameraPosition(
    target: LatLng(36.723062, 3.087800),
    zoom: 14.4746,
    // zoom: 14,

  );

  Future<Uint8List> getMarker() async {
    ByteData byteData = await DefaultAssetBundle.of(context).load("assets/marker.png");
    return byteData.buffer.asUint8List();
  }

  void updateMarkerAndCircle(LocationData newLocalData, Uint8List imageData) {
    LatLng latlng = LatLng(newLocalData.latitude ?? 0.0, newLocalData.longitude ?? 0.0);
    this.setState(() {
      marker = Marker(
          markerId: MarkerId("home"),
          position: latlng,
          rotation: newLocalData.heading ?? 0.0,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(imageData));

    });
  }

  void getCurrentLocation() async {
    try {

      Uint8List imageData = await getMarker();
      var location = await _locationTracker.getLocation();

      updateMarkerAndCircle(location, imageData);

      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }

      _locationSubscription = _locationTracker.onLocationChanged.listen((newLocalData) {
        if (_controller != null) {
          _controller.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
              bearing: 192.8334901395799,
              target: LatLng(newLocalData.latitude ?? 0.0, newLocalData.longitude ?? 0.0),
              tilt: 0,
              zoom: 18.00
          )));
          updateMarkerAndCircle(newLocalData, imageData);
        }
      });

    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: initialLocation,
          markers: Set.of((marker != null) ? [marker] : []),
          // circles: Set.of((circle != null) ? [circle] : []),
          onMapCreated: (GoogleMapController controller) {
            setState(() {
              _controller = controller;
            });
          },
          myLocationEnabled: true,
          compassEnabled: true,

        ),
      ),
    );
  }
}

  /// Converting.. { Coords <=> Adress }
  void _getAdressFromLatLng({double? pLat,double? pLng,String? pAddress}) async {
    List<geocod.Placemark> newPlace = await geocod.placemarkFromCoordinates(pLat??0.0, pLng??0.0);
    List<geocod.Location> newPos = await geocod.locationFromAddress(pAddress??'noInputAddress..');
    geocod.Placemark placeMark = newPlace[0];
    geocod.Location adressMark = newPos[0];

    String? name = placeMark.name;
    String? subLocality = placeMark.subLocality;
    String? locality = placeMark.locality;
    String? administrativeArea = placeMark.administrativeArea;
    String? postalCode = placeMark.postalCode;
    String? street = placeMark.street;

    double? _addressToLat = adressMark.latitude;
    double? _addressToLng = adressMark.longitude;

    String address = "ADRESS = name:${name}/ subLocality:${subLocality}/ locality:${locality}/ administrativeArea:${administrativeArea}/ postalCode:${postalCode}/ street:{$street}/";
    String position = "POSITION = latitude:${_addressToLat}/ longitude:${_addressToLng}";

    setState(() {
      coordsToAddress = address; // update _address
      addressToLat = _addressToLat; // update lat
      addressToLat = _addressToLat; // update lng
    });
  }
 */