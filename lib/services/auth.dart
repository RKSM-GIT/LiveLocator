import "package:firebase_auth/firebase_auth.dart";
import 'package:geolocator/geolocator.dart';
import 'package:live_locator/models/user.dart';
import 'package:live_locator/services/database.dart';

class AuthService{

  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Create user object from firebaseUser
  MyUser? _userFromFirebaseUser(User? x){
    return x != null ? MyUser(uid : x.uid) : null;
  }

  //auth changes user stream
  Stream<MyUser?> get user {
    return _auth.authStateChanges().map( _userFromFirebaseUser);
  }
  

  //sign in with email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      print(user);
      return _userFromFirebaseUser(user);

    } catch(e) {
        return null;
    }
  }

  //register with email & password
  Future registerWithEmailAndPassword(String name,String email, String password,double lat, double long) async {
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      print("auth.dart   :  $lat , $long");
      //Create a new document for user using uid
      await DatabaseService(uid: user!.uid).updateUserData(name,email,lat,long);

      return _userFromFirebaseUser(user);

    } catch(e) {
        return null;
    }
  }

  //sign out
  Future signOut() async {
    try{
      return _auth.signOut();
    }catch(e) {
      print(e.toString());
      return null;
    }
  }

  //update Email
  Future updateUserEmail(String email, String password) async {
    try{
      AuthCredential credential = EmailAuthProvider.credential(email: email, password: password);
      await FirebaseAuth.instance.currentUser!.reauthenticateWithCredential(credential);



    } catch(e){
      return null;
    }
  }
}