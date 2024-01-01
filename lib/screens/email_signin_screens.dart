import 'package:auth_app/widgets/user_image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

final _firebase = FirebaseAuth.instance;

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});
  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  File? _selectImage;
  var _globalkey = GlobalKey<FormState>();
  var enteredEmail = '';
  var enteredPass = '';
  var isLogin = true;
  var isuploading = false;
  void submitdata() async {
    final isValid = _globalkey.currentState!.validate();
    if (!isValid || !isLogin && _selectImage == null) {
      return;
    }
    _globalkey.currentState!.save();
    if (isLogin) {
      try {
        setState(() {
        isuploading = true;
        });
        final UserCredentials = await _firebase.signInWithEmailAndPassword(
            email: enteredEmail, password: enteredPass);
      } on FirebaseAuthException catch (error) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message ?? 'Authentication failed. '),
          ),
        );
        setState(() {
          isuploading = false;
        });
      }
    } else {
      try {
        setState(() {
        isuploading = true;
        });
        final user_credentials = await _firebase.createUserWithEmailAndPassword(
            email: enteredEmail, password: enteredPass);
        final storagefile = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('${user_credentials.user!.uid}.jpg');
        await storagefile.putFile(_selectImage!);
        final stringurl = await storagefile.getDownloadURL();

        await FirebaseFirestore.instance.collection('users').doc(user_credentials.user!.uid).set({
          'username': '',
          'email': enteredEmail,
          'image_url' : stringurl,
        });


      } on FirebaseAuthException catch (error) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message ?? 'Authentication failed. '),
          ),
        );
        setState(() {
          isuploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.blueGrey,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 600,
          width: double.infinity,
          alignment: Alignment.center,
          child: Form(
            key: _globalkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!isLogin)
                  UserImagePicker(
                    onPickImage: (imgp) {
                      _selectImage = imgp;
                    },
                  ),
                TextFormField(
                  maxLength: 100,
                  autocorrect: false,
                  decoration: InputDecoration(
                      label: Text('Enter the email'),
                      hintText: 'abc@gmail.com',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(3)))),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty ||
                        !value.contains('@')) {
                      return 'please enter a valid email-address';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    enteredEmail = value!;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  maxLength: 100,
                  autocorrect: false,
                  decoration: InputDecoration(
                      label: Text('Enter the Password'),
                      hintText: 'abc',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(3)))),
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.trim().length < 6) {
                      return 'please enter a password with atleast 6 characters';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    enteredPass = value!;
                  },
                ),
                if(isuploading)
                  CircularProgressIndicator(),

                if(!isuploading)
                  ElevatedButton(
                    onPressed: submitdata,
                    child: Text(isLogin ? 'Login' : 'sign-up')),
                  SizedBox(
                    height: 10,
                  ),
                if(!isuploading)
                  TextButton(
                      onPressed: () {
                        setState(() {
                          isLogin = !isLogin;
                        });
                      },
                      child: Text(isLogin
                          ? 'Sign-Up/Create an account'
                          : 'I already have an account')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
