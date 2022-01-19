import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
//import 'package:flutter_map/flutter_map.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
//import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:location/location.dart';
//import 'package:geocoder/geocoder.dart';
//import "package:latlong/latlong.dart" ;
import 'package:http/http.dart';
import 'map/googleMapScreen.dart';
import 'package:geocode/geocode.dart';

/// Buttons Page Route
class HomeFirebase extends StatefulWidget {
  @override
  _HomeFirebaseState createState() => _HomeFirebaseState();
}
class _HomeFirebaseState extends State<HomeFirebase> {

  dynamic result;

  void _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>  GoogleMapScreen()),
    );
    this.result = result;
    // After the Selection Screen returns a result, hide any previous snackbars
    // and show the new result.
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$result')));
  }
  @override
  Widget build(BuildContext context) {

    void goToSecondScreen()async {
      var result = await Navigator.push(context, new MaterialPageRoute(
        builder: (BuildContext context) =>  GoogleMapScreen(),
        fullscreenDialog: true,)
      );
      Scaffold.of(context).showSnackBar(SnackBar(content: Text("$result"),duration: Duration(seconds: 3),));

    }
    return Container(
      child: ListView(
        children: <Widget>[
          TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.hovered))
                      return Colors.blue.withOpacity(0.04);
                    if (states.contains(MaterialState.focused) ||
                        states.contains(MaterialState.pressed))
                      return Colors.blue.withOpacity(0.12);
                    return null; // Defer to the widget's default.
                  },
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/MapLake');

              },
              child: Text('MapLake')
          ),
          SizedBox(height: 10,),
          TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.hovered))
                      return Colors.blue.withOpacity(0.04);
                    if (states.contains(MaterialState.focused) ||
                        states.contains(MaterialState.pressed))
                      return Colors.blue.withOpacity(0.12);
                    return null; // Defer to the widget's default.
                  },
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/AddUser');

              },
              child: Text('Add User')
          ),
          SizedBox(height: 10,),
          TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.hovered))
                      return Colors.blue.withOpacity(0.04);
                    if (states.contains(MaterialState.focused) ||
                        states.contains(MaterialState.pressed))
                      return Colors.blue.withOpacity(0.12);
                    return null; // Defer to the widget's default.
                  },
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/GetUser');

              },
              child: Text('Get User')
          ),
          SizedBox(height: 10,),
          TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.hovered))
                      return Colors.blue.withOpacity(0.04);
                    if (states.contains(MaterialState.focused) ||
                        states.contains(MaterialState.pressed))
                      return Colors.blue.withOpacity(0.12);
                    return null; // Defer to the widget's default.
                  },
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/AddGarage');

              },
              child: Text('AddGarage')
          ),
          SizedBox(height: 10,),
          TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.hovered))
                      return Colors.blue.withOpacity(0.04);
                    if (states.contains(MaterialState.focused) ||
                        states.contains(MaterialState.pressed))
                      return Colors.blue.withOpacity(0.12);
                    return null; // Defer to the widget's default.
                  },
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/UserInformation');

              },
              child: Text('UserInformation')
          ),
          SizedBox(height: 10,),
          TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.hovered))
                      return Colors.blue.withOpacity(0.04);
                    if (states.contains(MaterialState.focused) ||
                        states.contains(MaterialState.pressed))
                      return Colors.blue.withOpacity(0.12);
                    return null; // Defer to the widget's default.
                  },
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/DataTest');

              },
              child: Text('DataTest')
          ),
          SizedBox(height: 10,),
          TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.hovered))
                      return Colors.blue.withOpacity(0.04);
                    if (states.contains(MaterialState.focused) ||
                        states.contains(MaterialState.pressed))
                      return Colors.blue.withOpacity(0.12);
                    return null; // Defer to the widget's default.
                  },
                ),
              ),
              onPressed: () async {
                //dynamic gmap = await  Navigator.pushNamed(context, '/GoogleMapScreen');
                //_navigateAndDisplaySelection(context);
                goToSecondScreen();
              },
              child: Text('GoogleMapScreen')
          ),
          SizedBox(height: 10,),
          TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.hovered))
                      return Colors.blue.withOpacity(0.04);
                    if (states.contains(MaterialState.focused) ||
                        states.contains(MaterialState.pressed))
                      return Colors.blue.withOpacity(0.12);
                    return null; // Defer to the widget's default.
                  },
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/StationsMap');

              },
              child: Text('StationsMap')
          ),
          SizedBox(height: 10,),
          TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.hovered))
                      return Colors.blue.withOpacity(0.04);
                    if (states.contains(MaterialState.focused) ||
                        states.contains(MaterialState.pressed))
                      return Colors.blue.withOpacity(0.12);
                    return null; // Defer to the widget's default.
                  },
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/GetUserLocation');

              },
              child: Text('GetUserLocation')
          ),
          SizedBox(height: 10,),
          Text('{$result}',
            style: TextStyle(
              fontSize: 10,
              color: Colors.white,
            ),

          ),

        ],
      ) ,
    );
  }
}


/// Map_Lake
class MapLake extends StatefulWidget {
  @override
  State<MapLake> createState() => MapLakeState();
}
class MapLakeState extends State<MapLake> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 0.0,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 0,
      zoom: 19);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text('To the lake!'),
        icon: Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
/// Add_User
class AddUser extends StatelessWidget {
    String fullName = 'khmais';
    String lastName = 'boubtan';
    int phone = 85479632;


  @override
  Widget build(BuildContext context) {
    // Create a CollectionReference called users that references the firestore collection
    CollectionReference users = FirebaseFirestore.instance.collection('tg_users');

    Future<void> addUser() {
      // Call the user's CollectionReference to add a new user
      return users
          .add({
        'first_name': fullName, // John Doe
        'last_name': lastName, // Stokes and Sons
        'phone': phone // 42
      })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }

    return TextButton(
      onPressed: addUser,
      child: Text(
        "Add User",
      ),
    );
  }
}
/// Add_Garage
class AddGarage extends StatelessWidget {
    String address = 'sidi 3mor';
    double latitude = 14.1547;
    double longitude = 45.2563;


  @override
  Widget build(BuildContext context) {
    // Create a CollectionReference called users that references the firestore collection
    CollectionReference users = FirebaseFirestore.instance.collection('garages');

    Future<void> addUser() {
      // Call the user's CollectionReference to add a new user
      return users.add({
        'address': address, // John Doe
        'latitude': latitude, // Stokes and Sons
        'longitude': longitude // 42
      })
          .then((value) => print("Garage Added"))
          .catchError((error) => print("Failed to add garage: $error"));
    }

    return TextButton(
      onPressed: addUser,
      child: Text(
        "Add Garage",
      ),
    );
  }
}
/// Get_User
class GetUser extends StatelessWidget {
  final String documentId ='kVmA2Mz5OjV3Z7zg8QGE' ;

  //GetUser(this.documentId);

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('tg_users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          return Text("Full Name: ${data['first_name']} ${data['last_name']} Have Phone: ${data['phone']}");
        }

        return Text("loading");
      },
    );
  }
}
/// List_Collection_Items
class UserInformation extends StatefulWidget {
  @override
  _UserInformationState createState() => _UserInformationState();
}
class _UserInformationState extends State<UserInformation> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('tg_users').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return Scaffold(
          body: ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
              return ListTile(
                title: Text(data['first_name']),
                subtitle: Text(data['last_name']),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
/// Data_Test
class DataTest extends StatefulWidget {

  @override
  _DataTestState createState() => _DataTestState();
}
class _DataTestState extends State<DataTest> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("test"),
        ),
        body: FutureBuilder(
          future: getData(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
              return Column(
                children: [
                  Container(
                    padding:EdgeInsets.all(16.0),
                    child: Flexible(
                      //height: 27,
                      //width: MediaQuery.of(context).size.width,
                      child: Text(
                        "Full Name: ${data['first_name']} ${data['last_name']} Have Phone: ${data['phone']}",
                        overflow: TextOverflow.fade,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ],
              );
            }
            else if (snapshot.connectionState == ConnectionState.none) {
              return Text("No data");
            }
            return CircularProgressIndicator();
          },
        ));
  }

  Future<DocumentSnapshot> getData() async {
    return await FirebaseFirestore.instance
        .collection("tg_users")
        .doc("0H5rB8agHSiNTeyjblbP")
        .get();
  }
}
/// Retrieving_Markers
class GetMarkers extends StatefulWidget {
  const GetMarkers({Key? key}) : super(key: key);

  @override
  _GetMarkersState createState() => _GetMarkersState();
}
class _GetMarkersState extends State<GetMarkers> {
  late GoogleMapController myController;
  Map<MarkerId,Marker> markers = <MarkerId,Marker>{};

  void initMarker(specify, specifyId) async {
    //var markerIdVal = specifyId;
    final MarkerId markerId = MarkerId(specifyId);
    final Marker marker = Marker(
      markerId:  markerId,
      position:
        LatLng(specify['coords'].latitude,specify['coords'].longitude),
      infoWindow: InfoWindow(title: 'Garages',snippet: specify['name'])
    );
    setState(() {
      markers[markerId] = marker;
    });
  }

  getMarkerData() async {
    FirebaseFirestore.instance.collection('garages').get().then((myMockData) {
      if (myMockData.docs.isNotEmpty){
        for(int i=0;i<myMockData.docs.length;i++){
          initMarker(myMockData.docs[i].data, myMockData.docs[i].id);
        }
      }
    }
    );
  }
  @override
  void initState() {
    getMarkerData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Set<Marker> getMarker(){
      return <Marker>[
        Marker(
          markerId: MarkerId('Shop'),
          position: LatLng(21.1452,79.1452),
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(title: 'Home')
        )
      ].toSet();
    }
    return Scaffold(
      body: GoogleMap(
        markers: Set<Marker>.of(markers.values),
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(target: LatLng(21.2563,79.2563),zoom: 15.0),
        onMapCreated: (GoogleMapController controller){
          controller = controller;
        },
      ),
    );
  }
}
/// Get_currLocation
class GetUserLocation extends StatefulWidget {
  @override
  _GetUserLocationState createState() => _GetUserLocationState();
}
class _GetUserLocationState extends State<GetUserLocation> {
  LocationData? currentLocation;
  String address = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (currentLocation != null)
                Text(
                    "Location: ${currentLocation?.latitude}, ${currentLocation?.longitude}"),
              if (currentLocation != null) Text("Address: $address"),
              MaterialButton(
                onPressed: () {
                  _getLocation().then((value) {
                    LocationData? location = value;
                    _getAddress(location?.latitude, location?.longitude)
                        .then((value) {
                      setState(() {
                        currentLocation = location;
                        address = value;
                      });
                    });
                  });
                },
                color: Colors.purple,
                child: Text(
                  "Get Location",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<LocationData?> _getLocation() async {
    Location location = new Location();
    LocationData _locationData;

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }


    _locationData = await location.getLocation();

    return _locationData;
  }

  Future<String> _getAddress(double? lat, double? lang) async {
    if (lat == null || lang == null) return "";
    GeoCode geoCode = GeoCode();
    Address address =
    await geoCode.reverseGeocoding(latitude: lat, longitude: lang);
    return "${address.streetAddress}, ${address.city}, ${address.countryName}, ${address.postal}";
  }
}

