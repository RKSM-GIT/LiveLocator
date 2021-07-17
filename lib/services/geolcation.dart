import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:live_locator/services/database.dart';
import 'package:provider/provider.dart';
import 'package:live_locator/models/user.dart';

//Find Location
Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;


  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }
  
  if (permission == LocationPermission.deniedForever) {
    return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.');
  } 

  return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
}


//Show on Map
class MyMap extends StatefulWidget {
  const MyMap({ Key? key }) : super(key: key);

  @override
  _MyMapState createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {

  GoogleMapController? myController;

  @override
  Widget build(BuildContext context) {

    final currUser = Provider.of<MyUser?>(context);

    // double? myLat,myLong;
    // Marker marker = Marker(
    //   markerId: ,
    //   position: LatLng(
    //     myLat ?? 20.5937,
    //     myLong ?? 78.9629
    //   ),
    // );

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: currUser!.uid).userData,
      builder: (context, snapshot) {
        UserData? userData = snapshot.data;
        // setState(() {
        //   myLat = userData?.lat;
        //   myLong = userData?.long;
        // });
        return Container(
          
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(userData!.lat ?? 20.5937,userData.long ?? 78.9629),
              zoom: 10.0
            ),
            compassEnabled: true,
            // markers: ,
          ),
        );
      }
    );
  }
}