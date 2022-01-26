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


/// Gmap test
class TestGmap extends StatefulWidget {
  const TestGmap({Key? key}) : super(key: key);

  @override
  _TestGmapState createState() => _TestGmapState();
}
class _TestGmapState extends State<TestGmap> {

  static final LatLng _kMapCenter =
  LatLng(19.018255973653343, 72.84793849278007);

  static final CameraPosition _kInitialPosition =
  CameraPosition(target: _kMapCenter, zoom: 11.0, tilt: 0, bearing: 0);

  late GoogleMapController _controller ;

  Future<void> onMapCreated(GoogleMapController controller) async {
    _controller = controller;
    String value = await DefaultAssetBundle.of(context)
        .loadString('assets/map_style.json');
    if (_controller != null) {
      _controller.setMapStyle(value);
    }
  }
  Set<Marker> _createMarker() {
    return {
      Marker(
          markerId: MarkerId("marker_1"),
          position: _kMapCenter,
          infoWindow: InfoWindow(title: 'Marker 1'),
          rotation: 90),
      Marker(
        markerId: MarkerId("marker_2"),
        position: LatLng(18.997962200185533, 72.8379758747611),
      ),
    };
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Maps Demo'),
      ),
      body: GoogleMap(
        initialCameraPosition: _kInitialPosition,
        onMapCreated: onMapCreated,
        mapType: MapType.satellite,
        myLocationEnabled: true,
        markers: _createMarker(),
      ),
    );
  }
}
/// Direction
class Directions extends StatefulWidget {
  @override
  _DirectionsState createState() => _DirectionsState();
}
class _DirectionsState extends State<Directions> {

  final FirebaseFirestore _database = FirebaseFirestore.instance;

  //GoogleMapController? mapController;// change to this
  Completer<GoogleMapController> mapController = Completer();
  // late  LatLng _initialPosition;
  // static  LatLng _lastMapPosition = _initialPosition;

  bool finishMarkersLoad =false;
  double _currentPositionLat = 0.0 ;
  double _currentPositionLng = 0.0;
  double _endPositionLat = 35.836117;
  double _endPositionLng = 10.633774;

  final List<LatLng> polyPoints = []; // For holding Co-ordinates as LatLng
  final Set<Polyline> polyLines = {}; // For holding instance of Polyline
  final Set<Marker> markers = {}; // For holding instance of Marker
  var data;
  Map<MarkerId , Marker> fBMarkers = <MarkerId , Marker>{};

  //static final LatLng _kMapCenter = LatLng(35.836117, 10.733774); // make the initial cam point at this point
  //static final LatLng LatLng(_currentPositionLat, _currentPositionLng); // make the initial cam point at this point
  //static final CameraPosition _kInitialPosition =  CameraPosition(target: _kMapCenter, zoom: 11.0, tilt: 0, bearing: 0);

  /// Initialization
  @override
  void initState() {
    getMarkerData();
    getCurrentLocation();
    //getJsonData(_currentPositionLat,_currentPositionLng,_endPositionLat,_endPositionLng);
    super.initState();
  }

  getMarkerData() async {
    _database.collection('garages').get().then((docs) {
      if(docs.docs.isNotEmpty) {
        for(int i = 0; i < docs.docs.length ; i++){
          initMarker(docs.docs[i].data , docs.docs[i].id);
          // if(i==docs.docs.length){
          //   setState(() {
          //     finishMarkersLoad =true;
          //   });
          //}
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
      onTap: () {
        getJsonData(_currentPositionLat,_currentPositionLng,specify['latitude'],specify['longitude']);
        goToUserPosition(17);
      }
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

  /*
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    setMarkers();
  }


   Future<void> _onMapCreated(Completer<GoogleMapController> controller) async {
    mapController = controller;
    setMarkers();
  }
  */

  /// go to current user position
  void goToUserPosition(double zoom) async{
    final CameraPosition cameraPosition = CameraPosition(
      target: LatLng(_currentPositionLat, _currentPositionLng),
      zoom: zoom,
    );

    final GoogleMapController controller = await mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  /// add markers to the markers list
  void setMarkers() async {
    // markers.add(
    //   Marker(
    //     markerId: MarkerId("Home"),
    //     position: LatLng(_currentPositionLat, _currentPositionLng),
    //     infoWindow: InfoWindow(
    //       title: "Home",
    //       snippet: "Home Sweet Home",
    //     ),
    //   ),
    // );

    markers.add(Marker(
      markerId: MarkerId("Destination"),
      position: LatLng(_endPositionLat, _endPositionLng),
      infoWindow: InfoWindow(
        title: "Masjid",
        snippet: "5 star ratted place",
      ),
      onTap: () {
        getJsonData(_currentPositionLat,_currentPositionLng,_endPositionLat,_endPositionLng);
        goToUserPosition(17);
      }

    ));
     markers.add(Marker(
      markerId: MarkerId("Destination1"),
      position: LatLng(35.840269, 10.632557),
      infoWindow: InfoWindow(
        title: "Masjid",
        snippet: "5 star ratted place",
      ),
    ));
     markers.add(Marker(
      markerId: MarkerId("Destination2"),
      position: LatLng(35.844703, 10.622080),
      infoWindow: InfoWindow(
        title: "Masjid",
        snippet: "5 star ratted place",
      ),
    ));

    setState(() {});
  }



  void getJsonData(double startLat, double startLng, double endLat, double endLng,) async {
    // Create an instance of Class NetworkHelper which uses http package
    // for requesting data to the server and receiving response as JSON format

    NetworkHelper network = NetworkHelper(
      startLat: startLat,
      startLng: startLng,
      endLat: endLat,
      endLng: endLng,
    );

    try {
      // getData() returns a json Decoded data
      data = await network.getData();

      // We can reach to our desired JSON data manually as following
      LineString ls = LineString(data['features'][0]['geometry']['coordinates']);

      for (int i = 0; i < ls.lineString.length; i++) {
        polyPoints.add(LatLng(ls.lineString[i][1], ls.lineString[i][0]));
      }

      if (polyPoints.length == ls.lineString.length) {
        setPolyLines();
      }
    } catch (e) {
      print(e);
    }
  }
  setPolyLines() {
    Polyline polyline = Polyline(
      polylineId: PolylineId("polyline"),
      color: Colors.lightBlue,
      points: polyPoints,
    );
    polyLines.add(polyline);
    setState(() {});
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Polyline Demo'),
          backgroundColor: Colors.green[700],
        ),
        body: Container(
          child: Stack(
            alignment: Alignment.bottomCenter,

            children: [((_currentPositionLat == 0.0) && (finishMarkersLoad =false))?
              Center(child: CircularProgressIndicator()):
              GoogleMap(
                myLocationButtonEnabled: true,
                myLocationEnabled: true,
                zoomControlsEnabled: false,
                compassEnabled: false,
                mapToolbarEnabled: false,
                tiltGesturesEnabled: false,
                //padding: EdgeInsets.fromLTRB(0, 0, 0, 80),
                onMapCreated: (GoogleMapController controller) {
                  mapController.complete(controller);
                  //setMarkers();
                  goToUserPosition(16);
                },
                initialCameraPosition:CameraPosition(
                  target: LatLng(_currentPositionLat, _currentPositionLng),
                  zoom: 11.0,
                  tilt: 0,
                  bearing: 0),
                //onCameraMove: _onCameraMove;

                markers: Set.of((fBMarkers != null) ? Set<Marker>.of(fBMarkers.values) : []),
                //markers: Set<Marker>.of(fBMarkers.values),
                //markers: markers,
                polylines: polyLines,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 70, vertical: 20),
                child: ElevatedButton(
                  onPressed: () {
                    //getJsonData(_currentPositionLat,_currentPositionLng,_endPositionLat,_endPositionLng);
                  },
                  child: Container(
                    child: Text('refresh'),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//Create a new class to hold the Co-ordinates we've received from the response data
class LineString {
  LineString(this.lineString);
  List<dynamic> lineString;
}
// networking class
class NetworkHelper{
  NetworkHelper({required this.startLng,required this.startLat,required this.endLng,required this.endLat});

  final String url ='https://api.openrouteservice.org/v2/directions/';
  final String apiKey = '5b3ce3597851110001cf62485af3fd03c6b644f9946787e5d2e93eb8';
  final String journeyMode = 'driving-car'; // Change it if you want or make it variable
  final double startLng;
  final double startLat;
  final double endLng;
  final double endLat;

  Future getData() async{
    http.Response response = await http.get(Uri.parse('$url$journeyMode?api_key=$apiKey&start=$startLng,$startLat&end=$endLng,$endLat'));
    print("$url$journeyMode?$apiKey&start=$startLng,$startLat&end=$endLng,$endLat");

    if(response.statusCode == 200) {
      String data = response.body;
      return jsonDecode(data);

    }
    else{
      print(response.statusCode);
    }
  }
}


