import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:live_locator/models/user.dart';
import 'package:live_locator/screens/wrapper.dart';
import 'package:live_locator/services/auth.dart';
import 'package:provider/provider.dart';

void main() async {
   WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp();
   runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Live Locator',
      home: StreamProvider<MyUser?>.value(
        value: AuthService().user,
        initialData: null,
        child: const MaterialApp(
          home: Wrapper(),
        )
      ),
    );
  }
}

