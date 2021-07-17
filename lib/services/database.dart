import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:live_locator/models/user.dart';
import 'package:geolocator/geolocator.dart';

class DatabaseService{

  //constructor
  final String? uid;
  DatabaseService({this.uid});

  //Collection Reference
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection("users");

  //Add - update users
  Future updateUserData(String name,String email,double lat, double long) async {

    print("updateUserData in database.dart  :  $lat , $long");
    return await usersCollection.doc(uid).set({
      'name' : name,
      'email' : email,
      'lat' : lat,
      'long': long,
    });
  }

  //Get users stream
  Stream<QuerySnapshot> get users {
    return usersCollection.snapshots();
  }

  //userData from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot){
    
    return UserData(
      uid: uid,
      name: snapshot.get("name"),
      email: snapshot.get("email"),
      lat: snapshot.get("lat").toDouble(),
      long: snapshot.get("long").toDouble(),
    );
  }

  //user doc Stream
  Stream<UserData> get userData{
    return usersCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  
}