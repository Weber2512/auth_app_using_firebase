// import 'package:auth_app/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firebase = FirebaseAuth.instance;

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});
  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  var _globalkey = GlobalKey<FormState>();
  var enteredEmail = '';
  var enteredPass = '';
  var isLogin = true;
  void submitdata() async {
    final isValid = _globalkey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _globalkey.currentState!.save();
    if (isLogin) {
      try{
        final UserCredentials = await _firebase.signInWithEmailAndPassword(email: enteredEmail, password: enteredPass);
        print(UserCredentials);
      }
      on FirebaseAuthException catch(error){
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message ?? 'Authentication failed. '),
          ),);
      }


    } else {
      try {
        final user_credentials = await _firebase.createUserWithEmailAndPassword(
            email: enteredEmail, password: enteredPass);
        print(user_credentials);
      } on FirebaseAuthException catch (error) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message ?? 'Authentication failed. '),
          ),
        );
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
                // Text('data'),
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
                ElevatedButton(
                    onPressed: submitdata,
                    child: Text(isLogin ? 'Login' : 'sign-up')),
                SizedBox(
                  height: 10,
                ),
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
