
import 'package:driver_app/authentication/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../global/global.dart';
import '../splashScreen/splash_screen.dart';
import '../widgets/progress_dialog.dart';



class LoginScreen extends StatefulWidget {



  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  validateForm(){
    if(!emailTextEditingController.text.endsWith("@cmc.edu")){
      Fluttertoast.showToast(msg: "Email address is not valid",);
    } else if(passwordTextEditingController.text.isEmpty){
      Fluttertoast.showToast(msg: "Please, enter a valid password",);
    }
    else{
      loginDriverNow();
    }
  }

  loginDriverNow() async{

    showDialog(context:context,
        barrierDismissible: false,
        builder: (BuildContext c){
          return ProgressDialog(message: "Loading, please wait ...",);
        });

    final User? firebaseUser = (
        await fAuth.signInWithEmailAndPassword(email: emailTextEditingController.text.trim(), password: passwordTextEditingController.text.trim(),
        ).catchError((msg){
          Navigator.pop(context);
          Fluttertoast.showToast(msg: "Invalid credentials: $msg");
        })
    ).user;

    if (firebaseUser != null){
      DatabaseReference driversRef = FirebaseDatabase.instance.ref().child("drivers");
      driversRef.child(firebaseUser.uid).once().then((driverKey){
        final snap = driverKey.snapshot;
        if(snap.value!= null){
          currentFirebaseUser= firebaseUser;
          Fluttertoast.showToast(msg: " Login Successful");
          Navigator.push(context, MaterialPageRoute(builder: (c)=>const MySplashScreen()));
        } else{
          Fluttertoast.showToast(msg: "Driver Record does not exist");
          fAuth.signOut();
          Navigator.push(context, MaterialPageRoute(builder: (c)=>const MySplashScreen()));
        }
      });
    }else{
      Navigator.pop(context);
      Fluttertoast.showToast(msg: """
Authentication Error""");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // const SizedBox(height: 12,),

              Padding(
                padding: const EdgeInsets.all(35.0),
                child: Image.asset("images/logo-color.png"),
              ),
              // const SizedBox(height: 12,),

              const Text(
                "LOGIN",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Text(
                "Please Login down below",
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.black45
                ),
              ),

              TextField(
                controller: emailTextEditingController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(
                    color: Colors.black87
                ),
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
                style: const TextStyle(
                    color: Colors.black87
                ),
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

              const SizedBox(height: 12,),

              ElevatedButton(
                onPressed: (){

                  validateForm();
                  //Navigator.push(context, MaterialPageRoute(builder: (c)=>CarInfoScreen()));
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors. grey
                ),
                child: const Text(
                  "Login",
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18
                  ),
                ),
              ),

              TextButton(
                child: const Text(
                  "Don't have an Account? Sign up",
                  style: TextStyle(color: Colors.blueGrey),
                ) ,
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (c)=>SignUpScreen()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}