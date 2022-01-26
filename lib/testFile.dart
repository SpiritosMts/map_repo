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
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart' as geocod;
import 'package:flutter/services.dart';

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
      MaterialPageRoute(builder: (context) => GoogleMapScreen()),
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
    void goToSecondScreen() async {
      var result = await Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (BuildContext context) => GoogleMapScreen(),
            fullscreenDialog: true,
          ));
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("$result"),
        duration: Duration(seconds: 3),
      ));
    }

    return Container(
      child: ListView(
        children: <Widget>[
/*
          TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.hovered)) return Colors.blue.withOpacity(0.04);
                    if (states.contains(MaterialState.focused) || states.contains(MaterialState.pressed)) return Colors.blue.withOpacity(0.12);
                    return null; // Defer to the widget's default.
                  },
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/MapLake');
              },
              child: Text('MapLake')),
          SizedBox(
            height: 10,
          ),
          TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.hovered)) return Colors.blue.withOpacity(0.04);
                    if (states.contains(MaterialState.focused) || states.contains(MaterialState.pressed)) return Colors.blue.withOpacity(0.12);
                    return null; // Defer to the widget's default.
                  },
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/AddUser');
              },
              child: Text('Add User')),
          SizedBox(
            height: 10,
          ),
          TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.hovered)) return Colors.blue.withOpacity(0.04);
                    if (states.contains(MaterialState.focused) || states.contains(MaterialState.pressed)) return Colors.blue.withOpacity(0.12);
                    return null; // Defer to the widget's default.
                  },
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/GetUser');
              },
              child: Text('Get User')),
          SizedBox(
            height: 10,
          ),
          TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.hovered)) return Colors.blue.withOpacity(0.04);
                    if (states.contains(MaterialState.focused) || states.contains(MaterialState.pressed)) return Colors.blue.withOpacity(0.12);
                    return null; // Defer to the widget's default.
                  },
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/AddGarage');
              },
              child: Text('AddGarage')),
          SizedBox(
            height: 10,
          ),
          TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.hovered)) return Colors.blue.withOpacity(0.04);
                    if (states.contains(MaterialState.focused) || states.contains(MaterialState.pressed)) return Colors.blue.withOpacity(0.12);
                    return null; // Defer to the widget's default.
                  },
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/UserInformation');
              },
              child: Text('UserInformation')),
          SizedBox(
            height: 10,
          ),
          TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.hovered)) return Colors.blue.withOpacity(0.04);
                    if (states.contains(MaterialState.focused) || states.contains(MaterialState.pressed)) return Colors.blue.withOpacity(0.12);
                    return null; // Defer to the widget's default.
                  },
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/DataTest');
              },
              child: Text('DataTest')),
          SizedBox(
            height: 10,
          ),
          TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.hovered)) return Colors.blue.withOpacity(0.04);
                    if (states.contains(MaterialState.focused) || states.contains(MaterialState.pressed)) return Colors.blue.withOpacity(0.12);
                    return null; // Defer to the widget's default.
                  },
                ),
              ),
              onPressed: () async {
                //dynamic gmap = await  Navigator.pushNamed(context, '/GoogleMapScreen');
                //_navigateAndDisplaySelection(context);
                goToSecondScreen();
              },
              child: Text('GoogleMapScreen')),
          SizedBox(
            height: 10,
          ),
          TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.hovered)) return Colors.blue.withOpacity(0.04);
                    if (states.contains(MaterialState.focused) || states.contains(MaterialState.pressed)) return Colors.blue.withOpacity(0.12);
                    return null; // Defer to the widget's default.
                  },
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/StationsMap');
              },
              child: Text('StationsMap')),
          SizedBox(
            height: 10,
          ),
*/
          TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.hovered)) return Colors.blue.withOpacity(0.04);
                    if (states.contains(MaterialState.focused) || states.contains(MaterialState.pressed)) return Colors.blue.withOpacity(0.12);
                    return null; // Defer to the widget's default.
                  },
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/AddNewGarage');
              },
              child: Text('AddNewGarage')),
          SizedBox(
            height: 10,
          ),
          TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.hovered)) return Colors.blue.withOpacity(0.04);
                    if (states.contains(MaterialState.focused) || states.contains(MaterialState.pressed)) return Colors.blue.withOpacity(0.12);
                    return null; // Defer to the widget's default.
                  },
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/OsmMap');
              },
              child: Text('OsmMap')),
          SizedBox(
            height: 10,
          ),
          TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.hovered)) return Colors.blue.withOpacity(0.04);
                    if (states.contains(MaterialState.focused) || states.contains(MaterialState.pressed)) return Colors.blue.withOpacity(0.12);
                    return null; // Defer to the widget's default.
                  },
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/TestGmap');
              },
              child: Text('TestGmap')),
          SizedBox(
            height: 10,
          ),
          TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.hovered)) return Colors.blue.withOpacity(0.04);
                    if (states.contains(MaterialState.focused) || states.contains(MaterialState.pressed)) return Colors.blue.withOpacity(0.12);
                    return null; // Defer to the widget's default.
                  },
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/Directions');
              },
              child: Text('Directions')),
          SizedBox(
            height: 10,
          ),
          TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.hovered)) return Colors.blue.withOpacity(0.04);
                    if (states.contains(MaterialState.focused) || states.contains(MaterialState.pressed)) return Colors.blue.withOpacity(0.12);
                    return null; // Defer to the widget's default.
                  },
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/SimpleMap');
              },
              child: Text('SimpleMap')),
          SizedBox(
            height: 10,
          ),
          TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.hovered)) return Colors.blue.withOpacity(0.04);
                    if (states.contains(MaterialState.focused) || states.contains(MaterialState.pressed)) return Colors.blue.withOpacity(0.12);
                    return null; // Defer to the widget's default.
                  },
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/SimpleMap2');
              },
              child: Text('SimpleMap2')),
          SizedBox(
            height: 10,
          ),
        ],
      ),
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

  static final CameraPosition _kLake = CameraPosition(bearing: 0.0, target: LatLng(37.43296265331129, -122.08832357078792), tilt: 0, zoom: 19);

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
      return users
          .add({
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
  final String documentId = 'kVmA2Mz5OjV3Z7zg8QGE';

  //GetUser(this.documentId);

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('tg_users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentId).get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
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
                    padding: EdgeInsets.all(16.0),
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
            } else if (snapshot.connectionState == ConnectionState.none) {
              return Text("No data");
            }
            return CircularProgressIndicator();
          },
        ));
  }

  Future<DocumentSnapshot> getData() async {
    return await FirebaseFirestore.instance.collection("tg_users").doc("0H5rB8agHSiNTeyjblbP").get();
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
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  void initMarker(specify, specifyId) async {
    //var markerIdVal = specifyId;
    final MarkerId markerId = MarkerId(specifyId);
    final Marker marker = Marker(
        markerId: markerId,
        position: LatLng(specify['coords'].latitude, specify['coords'].longitude),
        infoWindow: InfoWindow(title: 'Garages', snippet: specify['name']));
    setState(() {
      markers[markerId] = marker;
    });
  }

  getMarkerData() async {
    FirebaseFirestore.instance.collection('garages').get().then((myMockData) {
      if (myMockData.docs.isNotEmpty) {
        for (int i = 0; i < myMockData.docs.length; i++) {
          initMarker(myMockData.docs[i].data, myMockData.docs[i].id);
        }
      }
    });
  }

  @override
  void initState() {
    getMarkerData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Set<Marker> getMarker() {
      return <Marker>[
        Marker(
            markerId: MarkerId('Shop'),
            position: LatLng(21.1452, 79.1452),
            icon: BitmapDescriptor.defaultMarker,
            infoWindow: InfoWindow(title: 'Home'))
      ].toSet();
    }

    return Scaffold(
      body: GoogleMap(
        markers: Set<Marker>.of(markers.values),
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(target: LatLng(21.2563, 79.2563), zoom: 15.0),
        onMapCreated: (GoogleMapController controller) {
          controller = controller;
        },
      ),
    );
  }
}
/*
/// get coords from address
class Address extends StatefulWidget {

    @override
    _AddressState createState() => _AddressState();
  }
class _AddressState extends State<Address> {
    TextEditingController addresstextController = TextEditingController();

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: Text('Address Page')),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Padding(
              padding: const EdgeInsets.all(32.0),
              child: TextField(
                onChanged: (text){
                  _getAdressFromLatLng(pAddress: text); // you can put this when AdresstextField is changing...
                },
                controller: addresstextController,
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                ),
              ),
            ),

            RaisedButton(
              child: Text(
                'Save',
                style: TextStyle(fontSize: 24),
              ),
              onPressed: () {
                //_getAdressFromLatLng(pAddress: addresstextController.text); // you can put this when AdresstextField is changing...

                _sendDataBack(context);
              },
            )

          ],
        ),
      );
    }


    String coordsToAddress = "";
    //static String theAddressGeocode = "";
    double addressToLat = 0.0 ;
    double addressToLng = 0.0 ;
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
    /// send Data back
    void _sendDataBack(BuildContext context) {
      Map<String,dynamic> data = Map<String,dynamic>();
      data['lat'] = addressToLat;
      data['lng'] = addressToLng;
      //data['phone'] = 65487125;
      Navigator.pop(context, data);
    }

  }

*/

/// Get_currLocation
enum PosMethod { Address, Map }
class AddNewGarage extends StatefulWidget {

  @override
  _AddNewGarageState createState() => _AddNewGarageState();
}
class _AddNewGarageState extends State<AddNewGarage> {


  Map<String, dynamic> resultsCoords = Map<String, dynamic>();
  Map<String, dynamic> resultsAdress = Map<String, dynamic>();
  TextEditingController addresstextController = TextEditingController();
  TextEditingController nameTextController = TextEditingController();
  TextEditingController ciretTextController = TextEditingController();
  PosMethod? _method = PosMethod.Address;


  /// wait data
/*
  void _awaitReturnValueFromNextScreen(BuildContext context,pResults,) async {

    // named method to push screen
    //final _results = await Navigator.pushNamed(context, '/Address');  //don't use this
    // material method to push screen
    final _results = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Address(),
        ));

    setState(() {
      pResults = _results;
    });
  }
*/

  String coordsToAddress = "";
  /// Converting.. { Coords => Adress }
  void _getAdressFromLatLng(double? pLat, double? pLng) async {
    List<geocod.Placemark> newPlace = await geocod.placemarkFromCoordinates(pLat ?? 0.0, pLng ?? 0.0);
    geocod.Placemark placeMark = newPlace[0];

    String? name = placeMark.name;
    String? subLocality = placeMark.subLocality;
    String? locality = placeMark.locality;
    String? administrativeArea = placeMark.administrativeArea;
    String? postalCode = placeMark.postalCode;
    String? street = placeMark.street;

    String address =
        "ADRESS = name:${name}/ subLocality:${subLocality}/ locality:${locality}/ administrativeArea:${administrativeArea}/ postalCode:${postalCode}/ street:{$street}/";

    setState(() {
      coordsToAddress = address; // update _address
    });
  }
  double addressToLat = 0.0;
  double addressToLng = 0.0;
  /// Converting.. { Coords <= Adress }
  void _getLatLngFromAdress(String? pAddress) async {
    List<geocod.Location> newPos = await geocod.locationFromAddress(pAddress ?? 'noInputAddress..');
    geocod.Location adressMark = newPos[0];

    double? _addressToLat = adressMark.latitude;
    double? _addressToLng = adressMark.longitude;

    String position = "POSITION = latitude:${_addressToLat}/ longitude:${_addressToLng}";

    setState(() {
      addressToLat = _addressToLat; // update lat
      addressToLng = _addressToLng; // update lng
    });
  }
  /// save returned data in map
  void _awaitReturnValueFromNextScreen(BuildContext context) async {

    // start the SecondScreen and wait for it to finish with a result
    final _results = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GoogleMapScreen(),
        ));

    // after the SecondScreen result comes back update the Text widget with it
    setState(() {
      //Map<String,dynamic> data = Map<String,dynamic>();
      resultsAdress = _results;
    });
  }

  //#################################################################################
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Add New Garage'),
          centerTitle: true,
      ),
      body: Center(
        child: ListView(
          scrollDirection: Axis.vertical, // Axis.horizontal for horizontal list view.

          //shrinkWrap: true, // important

          children: [
            // name_input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: TextFormField(
                controller: nameTextController,
                style: TextStyle(

                  fontSize: 24,
                  color: Color(0xFFFA9F42),
                ),
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Nom',
                ),

              ),
            ),
            // N°ciret_input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: TextFormField(
                controller: ciretTextController,
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                ),
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'N°Ciret',
                ),
              ),
            ),

            // choose setting position method

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                    padding: const EdgeInsets.only(left: 22),
                    //padding: EdgeInsets.all(20),
                    child: Text('Set Position By :'),
                  ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Radio(
                        value: PosMethod.Address,
                        groupValue: _method,
                        onChanged: (PosMethod? value) {
                          setState(() {
                            _method = value;
                            FocusScope.of(context).unfocus();

                          });
                        },
                          ),
                      Expanded(
                          child: Text('Address'),
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Radio(
                        value: PosMethod.Map,
                        groupValue: _method,
                        onChanged: (PosMethod? value) {
                          setState(() {
                            _method = value;
                            FocusScope.of(context).unfocus();

                          });
                        },
                          ),
                      Expanded(
                        child: Text('Map'),
                      )
                    ],
                  ),
                ),
              ],
            ),
            _method == PosMethod.Address
            //if address ratio is active
                ? Center(
                child: Column(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: TextField(

                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                        border: OutlineInputBorder(),
                        labelText: 'Adress',
                        labelStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      controller: addresstextController,
                    ),
                  ),

                  /// save
                  RaisedButton(
                    child: Text(
                      'Get Position',
                      style: TextStyle(fontSize: 24),
                    ),
                    onPressed: () {
                      _getLatLngFromAdress(addresstextController.text); // you can put this when AdresstextField is changing...
                      setState(() {});

                      // _sendDataBack(context);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Text(
                      'latitude : ${addressToLat}\nlongitude : ${addressToLng}',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                ]))
            //if map ratio is active
                : Center(
              child: Column(
                children: <Widget>[
                  RaisedButton(
                    child: Text(
                      'Set Marker',
                      style: TextStyle(fontSize: 24),
                    ),
                    onPressed: () {
                      _awaitReturnValueFromNextScreen(context);
                      //setState(() {});

                      // _sendDataBack(context);
                    },
                  ),
                  //address
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text('address : ${resultsAdress['street']}',
                       style: TextStyle(
                         fontSize: 19,
                       ),
                    ),
                  ),
                ],
              ),

            ),
          ],
        ),
      ),
    );
  }
}
