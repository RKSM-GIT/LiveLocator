import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:live_locator/models/user.dart';
import 'package:live_locator/screens/home/search1.dart';
import 'package:live_locator/services/database.dart';
import 'package:live_locator/shared/loading.dart';
import 'package:provider/provider.dart';

class Groups extends StatefulWidget {
  const Groups({ Key? key }) : super(key: key);

  @override
  _GroupsState createState() => _GroupsState();
}

class _GroupsState extends State<Groups> {
  @override
  Widget build(BuildContext context) {

    final currUser = Provider.of<MyUser?>(context);


    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: currUser!.uid).userData,
      builder: (context, snapshot1) {

        if(snapshot1.data != null){
          UserData? userData = snapshot1.data;
          
          
          


          return Scaffold(
            backgroundColor: Colors.blue[100],

            //appbar
            appBar: AppBar(
              backgroundColor: Colors.blue[800],
              title: const Text("Choose a Group"),
              elevation: 0.0,
              actions: [],
            ),

            //floating button
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) => Search()));
              },
              child: Icon(Icons.add,
                color: Colors.white,
                size: 30,
              )
            ),

            
            //body
            body: StreamBuilder(
              stream: FirebaseFirestore.instance
                .collection('groups')
                .where('users', arrayContains: userData!.name)
                .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot2) {

                if(snapshot2.hasData){
                  
                  List<Map<String,dynamic>> myList = [];
                  snapshot2.data!.docs.forEach((element) {
                    myList.add({
                      "groupName": element.get("groupname"),
                      "users" : element.get("users"),
                    });
                  });

                  return ListView.builder(
                    itemCount: myList.length,
                    itemBuilder: (context,index){

                      int n = myList[index]["users"].length;
                      return Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Card(
                          margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 25.0,
                              backgroundColor: Colors.black,
                              child: Text(myList[index]["groupName"][0].toUpperCase(),
                                style: TextStyle(
                                  fontSize: 30,
                                ),
                              ),
                            ),
                            title: Text(myList[index]["groupName"]),
                            subtitle: Text("Admin : ${myList[index]["users"][n-1]}"),
                          )
                        ),
                      );
                    },

                  );
                } else{
                  return Loading();
                }
              }
            ),
          );
        }else {
          return Loading();
        }
      }
    );
  }
}