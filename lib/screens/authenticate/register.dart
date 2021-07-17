import 'package:geolocator/geolocator.dart';
import 'package:live_locator/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:live_locator/shared/loading.dart';
import "package:live_locator/shared/constants.dart";
import 'package:live_locator/services/geolcation.dart';


class Register extends StatefulWidget {
  
  final Function? toggleView;
  Register({this.toggleView});


  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  //loading
  bool loading = false;

  //Form States
  String email = "", password = "", name = "",error = "";
  double lat=0.0 ,long=0.0 ;

  @override
  Widget build(BuildContext context) {
    return loading==true? Loading() : Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        elevation: 0.0,
        title: const Text("Register"),
        actions: [
          TextButton.icon(
            onPressed: () {
              widget.toggleView!();
            }, 
            icon: Icon(Icons.apps_rounded),
            label: Text("Log in"),
            style: TextButton.styleFrom(
              primary: Colors.white
            ),
          ),
        ],
      ),


      body: Container(
        padding: const EdgeInsets.symmetric(horizontal:50,vertical:20),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[

              //user's Name
              SizedBox(height:20,),
              TextFormField(
                validator: (val) {
                  if(val == null || val.isEmpty){
                    return "Name not Entered";
                  }
                  else{
                    return null;
                  }
                },
                onChanged: (val) {
                  setState(() => {name = val});
                },
                decoration: textInputDecoration.copyWith(hintText: "Your Name"),
              ),


              //EMAIL
              SizedBox(height:20,),
              TextFormField(
                validator: (val) {
                  if(val == null || val.isEmpty){
                    return "Enter an Email";
                  }
                  else if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val)){
                    return "Not a valid email";
                  }
                  else{
                    return null;
                  }
                },
                onChanged: (val) {
                  setState(() => {email = val});
                },
                decoration: textInputDecoration.copyWith(hintText: "Email"),
              ),

              //Password
              SizedBox(height:20,),
              TextFormField(
                validator: (val) {
                  if(val == null || val.isEmpty){
                    return "Enter a password";
                  }
                  else if(val.length < 6){
                    return "Password must be atleast 6 characters long";
                  }
                  else
                    return null;
                },
                obscureText: true,
                onChanged: (val) {
                  setState(() => {password = val});
                },
                decoration: textInputDecoration.copyWith(hintText: "Password"),
              ),

              //Submit
              SizedBox(height:20,),
              ElevatedButton(
                onPressed: () async {

                  if(_formKey.currentState!.validate()){
                    setState(() => loading = true);
                    
                    Position userPosition = await determinePosition();
                    lat = userPosition.latitude;
                    long = userPosition.longitude;


                    dynamic result = await _auth.registerWithEmailAndPassword(name, email, password,lat,long);
                    if(result == null){
                      setState(() {
                        error = "Email is invalid or already taken";
                        loading = false;
                      });
                    }
        
                  }

                },
                child: Text("Register"),
                style: ElevatedButton.styleFrom(
                  primary: Colors.pink,
                  onPrimary: Colors.white,
                ),
              ),


              //Error
              SizedBox(height: 14),
              Text(error,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.red,
                ),
              ),
            ],
          )
        )
      ),
    );
  }
}