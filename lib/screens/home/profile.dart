import 'package:flutter/material.dart';
import 'package:live_locator/models/user.dart';
import 'package:live_locator/services/database.dart';
import 'package:live_locator/shared/constants.dart';
import 'package:live_locator/shared/loading.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({ Key? key }) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  final _formKey = GlobalKey<FormState>();
  

  //Form Values
  String? _currentName;

  @override
  Widget build(BuildContext context) {

    final currUser = Provider.of<MyUser?>(context);

    return Container(
      color: Colors.blue[100],
      child: StreamBuilder<UserData>(
        stream: DatabaseService(uid: currUser!.uid).userData,
        builder: (context, snapshot) {
          
          if(snapshot.hasData){
            UserData? userData = snapshot.data;

            return Form(
              key: _formKey,
              child: Column(
                children: <Widget>[

                  //Drawer Header
                  Row(
                    children: [
                      Expanded(
                        child: DrawerHeader(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                          ),
                          child: Center(
                            child: Text('My Profile',
                              style: TextStyle(
                                fontSize: 24,
                                letterSpacing: 1.5,
                                color: Colors.white
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        SizedBox(height : 40),
                        //Name
                        TextFormField(
                          initialValue: userData?.name,
                          decoration: textInputDecoration2.copyWith(labelText: "Name"),
                          validator: (val) {
                            if(val == null || val.isEmpty)
                              return "Please Enter a name";
                            else
                              return null;
                          },
                          onChanged: (val) => setState(() => _currentName = val),
                        ),

                      

                        //Email
                        SizedBox(height : 20),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 35, vertical: 20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.grey,width: 2),
                                ),
                                child : Text("${userData?.email}",
                                  style: TextStyle(fontSize: 16),

                                ),
                              ),
                            ),
                          ],
                        ),

                        //location
                        SizedBox(height : 20),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 35, vertical: 20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.grey,width: 2),
                                ),
                                child : Text("Latitude:   ${userData?.lat}\nLongitude:   ${userData?.long}",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        ),

                        //Submit
                        SizedBox(height : 20),
                        ElevatedButton(
                          onPressed: () async {
                            if(_formKey.currentState!.validate()){
                              await DatabaseService(uid: currUser.uid).updateUserData(
                                _currentName ?? "${userData!.name}",
                                "${userData!.email}",
                                userData.lat ?? 20.5937,
                                userData.long ?? 78.9629,
                                // userData.userPosition,
                              );

                              Navigator.pop(context);
                            }
                          }, 
                          child: Text("Update"),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.pink[400],
                            onPrimary: Colors.white
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          }else{
            return Loading();
          }
        }
      ),
    );
  }
}