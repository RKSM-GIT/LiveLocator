import 'package:flutter/material.dart';
import 'package:live_locator/services/geolcation.dart';

class MyLocation extends StatefulWidget {
  const MyLocation({ Key? key }) : super(key: key);

  @override
  _MyLocationState createState() => _MyLocationState();
}

class _MyLocationState extends State<MyLocation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],

      //appbar
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: const Text("My Location"),
        elevation: 0.0,
      ),

      //body
      body: MyMap(),
    );
  }
}