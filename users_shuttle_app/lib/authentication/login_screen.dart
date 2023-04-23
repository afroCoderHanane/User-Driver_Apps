import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:users_app/authentication/signup_screen.dart';
import '../global/global.dart';
import '../splashScreen/splash_screen.dart';
import '../widget/progress_dialog.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  validateForm() {
    if (!emailTextEditingController.text.endsWith("@cmc.edu")) {
      Fluttertoast.showToast(
        msg: "Email address is not valid",
      );
    } else if (passwordTextEditingController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please, enter a valid password",
      );
    } else {
      loginUserNow();
    }
  }

  _resetPassword(BuildContext context) async {
    String? email = emailTextEditingController.text.trim();
    if (email.isEmpty || !email.endsWith("@cmc.edu")) {
      Fluttertoast.showToast(
        msg: "Please, enter a valid email address",
      );
      return;
    }

    try {
      await fAuth.sendPasswordResetEmail(email: email);
      Fluttertoast.showToast(
        msg: "A password reset link has been sent to your email",
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error resetting password: ${e.toString()}",
      );
    }
  }

  loginUserNow() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c) {
          return ProgressDialog(
            message: "Loading, please wait ...",
          );
        });

    final User? firebaseUser = (await fAuth
            .signInWithEmailAndPassword(
      email: emailTextEditingController.text.trim(),
      password: passwordTextEditingController.text.trim(),
    )
            // ignore: body_might_complete_normally_catch_error
            .catchError((msg) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Invalid credentials: $msg");
    }))
        .user;

    if (firebaseUser != null) {
      DatabaseReference usersRef =
          FirebaseDatabase.instance.ref().child("users");
      usersRef.child(firebaseUser.uid).once().then((userKey) {
        final snap = userKey.snapshot;
        if (snap.value != null) {
          currentFirebaseUser = firebaseUser;
          Fluttertoast.showToast(msg: " Login Successful");
          Navigator.push(context,
              MaterialPageRoute(builder: (c) => const MySplashScreen()));
        } else {
          Fluttertoast.showToast(msg: "Driver Record does not exist");
          fAuth.signOut();
          Navigator.push(context,
              MaterialPageRoute(builder: (c) => const MySplashScreen()));
        }
      });
    } else {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: """
Authentication Error""");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(
                height: 12,
              ),
              Padding(
                padding: const EdgeInsets.all(35.0),
                child: Image.asset("images/cmclogo.png"),
              ),
              const SizedBox(
                height: 12,
              ),
              const Text(
                "USER LOGIN",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "Please Login down below",
                style: TextStyle(fontSize: 15, color: Colors.black45),
              ),
              TextField(
                controller: emailTextEditingController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.black87),
                decoration: const InputDecoration(
                  labelText: "Email",
                  hintText: "Enter your e-mail",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black87),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black87),
                  ),
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                  labelStyle: TextStyle(
                    color: Colors.black87,
                    fontSize: 15,
                  ),
                ),
              ),
              TextField(
                controller: passwordTextEditingController,
                keyboardType: TextInputType.text,
                obscureText: true,
                style: const TextStyle(color: Colors.black87),
                decoration: const InputDecoration(
                  labelText: "Password",
                  hintText: "Enter your Password",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black87),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black87),
                  ),
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                  labelStyle: TextStyle(
                    color: Colors.black87,
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              ElevatedButton(
                onPressed: () {
                  validateForm();
                  //Navigator.push(context, MaterialPageRoute(builder: (c)=>CarInfoScreen()));
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade900),
                child: const Text(
                  "Login",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              // Add this line below the ElevatedButton
              TextButton(
                child: const Text(
                  "Forgot Password?",
                  style: TextStyle(color: Colors.blueGrey),
                ),
                onPressed: () {
                  _resetPassword(context);
                },
              ),

              TextButton(
                child: const Text(
                  "Don't have an Account? Sign up",
                  style: TextStyle(color: Colors.blueGrey),
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => const SignUpScreen()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
