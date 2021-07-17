import 'package:live_locator/screens/home/groups.dart';
import 'package:live_locator/screens/home/my_location.dart';
import 'package:live_locator/screens/home/profile.dart';
import 'package:live_locator/screens/home/search1.dart';
import 'package:live_locator/services/database.dart';
import 'package:live_locator/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatelessWidget {
  Home({ Key? key }) : super(key: key);

  //Get the _auth
  final AuthService _auth = AuthService();


  @override
  Widget build(BuildContext context) {


    return StreamProvider<QuerySnapshot?>.value(
      initialData: null,
      value: DatabaseService().users,
      child: Scaffold(
        backgroundColor: Colors.blue[100],

        //Drawer
        drawer: Drawer(
          child: Profile(),
        ),

        //App Bar
        appBar: AppBar(
          backgroundColor: Colors.blue[800],
          title: const Text("Home"),
          elevation: 0.0,
          actions: <Widget>[

            //Add Group
            // TextButton.icon(
            //   onPressed: () async {
                
            //   }, 
            //   icon: Icon(Icons.add), 
            //   label: Text("Add"),
            //   style: TextButton.styleFrom(
            //     primary: Colors.black,
            //   ),
            // ),


            //Signout
            TextButton.icon(
              onPressed: () async {
                await _auth.signOut();
              }, 
              icon: Icon(Icons.person ), 
              label: Text("Sign Out"),
              style: TextButton.styleFrom(
                primary: Colors.grey[200],
              ),
            ),

            //Settings
          
          ],
        ),

        //Body
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              
              //Heading
              Text("Welcome \n  to Live \n Locator",
                style: TextStyle(
                  fontSize: 40,
                  letterSpacing: 2.5,
                  color: Colors.blue[800],
                ),
              ),
              SizedBox(height: 100),

              //my location
              GestureDetector(
                onTap: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => MyLocation())),
                child: Text("Get My Location",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.pink[400],
                    letterSpacing: 2.0,
                  ),
                ),
              ),
              SizedBox(height: 20,),

              //Groups
              GestureDetector(
                onTap: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => Groups())),
                child: Text("Groups",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.pink[400],
                    letterSpacing: 2.0,
                  ),
                ),
              ),
              SizedBox(height: 20,),

              //Search
              GestureDetector(
                onTap: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => Search())),
                child: Text("Search",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.pink[400],
                    letterSpacing: 2.0,
                    
                  ),
                ),
              ),
              SizedBox(height: 80),

            ],
          ),
        ),
      ),
    );
  }
}