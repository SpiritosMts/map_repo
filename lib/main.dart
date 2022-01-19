import 'package:flutter/material.dart';
import 'package:map_firebase/testFile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


import 'map/googleMapScreen.dart';
import 'mapFirebase.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Map Firebase',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      // Start the app with the "/" named route. In this case, the app starts
      // on the FirstScreen widget.
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) =>  HomeFirebase(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/MapLake': (context) =>  MapLake(),
        '/AddUser': (context) =>  AddUser(),
        '/AddGarage': (context) =>  AddGarage(),
        '/GetUser': (context) =>  GetUser(),
        '/UserInformation': (context) =>  UserInformation(),
        '/DataTest': (context) =>  DataTest(),
        '/GoogleMapScreen': (context) =>  GoogleMapScreen(),
        '/StationsMap': (context) =>  StationsMap(),
        '/GetUserLocation': (context) =>  GetUserLocation(),
      },    );
  }
}

