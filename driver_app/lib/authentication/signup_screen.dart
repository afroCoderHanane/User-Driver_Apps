import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../global/global.dart';
import '../widgets/progress_dialog.dart';
import 'car_info_screen.dart';
import 'login_screen.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController confirmpasswordTextEditingController = TextEditingController();

  validateForm(){
    if(nameTextEditingController.text.length < 3){
      Fluttertoast.showToast(msg: "Please, enter a valid name",);
    }else if(!emailTextEditingController.text.endsWith("@cmc.edu")){
      Fluttertoast.showToast(msg: "Please, enter your cmc email",);
    }else if(phoneTextEditingController.text.length <10){
      Fluttertoast.showToast(msg: "Please, enter a valid phone number",);
    }else if(!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$').hasMatch(passwordTextEditingController.text) ){
      Fluttertoast.showToast(msg: "Please, Enter a valid password: Minimum 1 Upper case, 1 lowercase,1 Numeric Number, 1 Special Character,Common Allow Character ( ! @ #  & * ~ )",);
    }else if(passwordTextEditingController.text != confirmpasswordTextEditingController.text ){
      Fluttertoast.showToast(msg: "Password does not match",);
    }
    else{
      saveDriverInfoNow();
    }
  }

  saveDriverInfoNow() async{

    showDialog(context: context,
        barrierDismissible: false,
        builder: (BuildContext c){
          return ProgressDialog(message: "Saving user",);
        });

    final User? firebaseUser = (
        await fAuth.createUserWithEmailAndPassword(email: emailTextEditingController.text.trim(), password: passwordTextEditingController.text.trim(),
        ).catchError((msg){
          Navigator.pop(context);
          Fluttertoast.showToast(msg: "Error: $msg");

        })
    ).user;

    if (firebaseUser != null){
      Map driverMap = {
        "id": firebaseUser.uid,
        "name": nameTextEditingController.text.trim(),
        "email": emailTextEditingController.text.trim(),
        "phone": phoneTextEditingController.text.trim(),
      };

      DatabaseReference driverRef = FirebaseDatabase.instance.ref().child("drivers");
      driverRef.child(firebaseUser.uid).set(driverMap);
      currentFirebaseUser= firebaseUser;

      Fluttertoast.showToast(msg: " Account created");
      Navigator.push(context, MaterialPageRoute(builder: (c)=>CarInfoScreen()));

    }else{
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error: Account not created");
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
              children: [

                // const SizedBox(height: 12,),

                Padding(
                  padding: const EdgeInsets.all(35.0),
                  child: Image.asset("images/logo-color.png"),
                ),
                // const SizedBox(height: 12,),

                const Text(
                  "REGISTRATION",
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "Please Register down below",
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.black45
                  ),
                ),
                TextField(
                  controller: nameTextEditingController,
                  style: const TextStyle(
                      color: Colors.black87
                  ),
                  decoration: const InputDecoration(
                    labelText: "Name",
                    hintText: "Enter your full name",
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
                  controller: phoneTextEditingController,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(
                      color: Colors.black87
                  ),
                  decoration: const InputDecoration(
                    labelText: "Phone",
                    hintText: "Enter your phone number",
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

                TextField(
                  controller: confirmpasswordTextEditingController,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  style: const TextStyle(
                      color: Colors.black87
                  ),
                  decoration: const InputDecoration(
                    labelText: "Confirm Password",
                    hintText: "Retype your Password",
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
                const SizedBox(height: 20,),

                ElevatedButton(
                  onPressed: (){
                    validateForm();
                    //Navigator.push(context, MaterialPageRoute(builder: (c)=>CarInfoScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors. grey
                  ),
                  child: const Text(
                    "Create Account",
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 18
                    ),
                  ),
                ),

                TextButton(
                  child: const Text(
                    "Already have an Account? Sign in",
                    style: TextStyle(color: Colors.blueGrey),
                  ) ,
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (c)=>LoginScreen()));
                  },
                ),
              ]
          ),
        ),
      ),
    );
  }
}