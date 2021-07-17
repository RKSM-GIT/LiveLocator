import 'package:live_locator/models/user.dart';
import 'package:flutter/material.dart';
import 'home/home.dart';
import 'authenticate/authenticate.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    //getting the user from provider
    final user = Provider.of<MyUser?>(context);

    //return either Home() or Authenticate()
    if(user == null){
      return const Authenticate();
    }else{
      return Home();
    }
  }
}