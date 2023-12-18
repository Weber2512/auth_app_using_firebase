import 'package:auth_app/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:auth_app/screens/email_signin_screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    home: StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(), builder: (ctx,snapshot){
      if(snapshot.hasData){
        return Home();
      }
      return SignInPage();
    }),
  ));
}

