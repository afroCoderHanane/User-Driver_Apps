import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../global/global.dart';
import '../widget/progress_dialog.dart';
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
  TextEditingController confirmpasswordTextEditingController =
      TextEditingController();

  validateForm() {
    if (nameTextEditingController.text.length < 3) {
      Fluttertoast.showToast(
        msg: "Please, enter a valid name",
      );
    } else if (!emailTextEditingController.text.endsWith("@cmc.edu") ) {
      Fluttertoast.showToast(
        msg: "Please, enter your cmc email",
      );
    } else if (phoneTextEditingController.text.length < 10) {
      Fluttertoast.showToast(
        msg: "Please, enter a valid phone number",
      );
    } else if (!RegExp(
            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?\d)(?=.*?[!@#$&*~]).{6,}$')
        .hasMatch(passwordTextEditingController.text)) {
      Fluttertoast.showToast(
        msg:
            "Please, Enter a valid password: Minimum 1 Upper case, 1 lowercase,1 Numeric Number, 1 Special Character,Common Allow Character ( ! @ #  & * ~ )",
      );
    } else if (passwordTextEditingController.text !=
        confirmpasswordTextEditingController.text) {
      Fluttertoast.showToast(
        msg: "Password does not match",
      );
    } else {
      saveUserInfoNow();
    }
  }

  sendEmailVerification() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
      Fluttertoast.showToast(
          msg: "Verification email sent. Please check your inbox.");
    } else {
      Fluttertoast.showToast(msg: "Failed to send the verification email.");
    }
  }


  saveUserInfoNow() async {

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c) {
          return ProgressDialog(
            message: "Saving User, please wait ...",
          );
        });

    UserCredential userCredential;
    try {
      userCredential = await fAuth.createUserWithEmailAndPassword(
        email: emailTextEditingController.text.trim(),
        password: passwordTextEditingController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error: ${e.message}");
      return;
    }

    final User? firebaseUser = userCredential.user;

    if (firebaseUser != null) {
      await sendEmailVerification();
      Map userMap = {
        "id": firebaseUser.uid,
        "name": nameTextEditingController.text.trim(),
        "email": emailTextEditingController.text.trim(),
        "phone": phoneTextEditingController.text.trim(),
      };

      DatabaseReference driverRef =
          FirebaseDatabase.instance.ref().child("users");
      driverRef.child(firebaseUser.uid).set(userMap);
      currentFirebaseUser = firebaseUser;
      // Fluttertoast.showToast(msg: " Account created");
      Navigator.push(context, MaterialPageRoute(builder: (c) => LoginScreen()));
    } else {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error: Account not created");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
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
                "USER REGISTRATION",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "Please Register down below",
                style: TextStyle(fontSize: 15, color: Colors.black45),
              ),
              TextField(
                controller: nameTextEditingController,
                style: const TextStyle(color: Colors.black87),
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
                controller: phoneTextEditingController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: Colors.black87),
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
              TextField(
                controller: confirmpasswordTextEditingController,
                keyboardType: TextInputType.text,
                obscureText: true,
                style: const TextStyle(color: Colors.black87),
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
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  validateForm();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => LoginScreen()));
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade900),
                child: const Text(
                  "Create Account",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              TextButton(
                child: const Text(
                  "Already have an Account? Sign in",
                  style: TextStyle(color: Colors.blueGrey),
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => LoginScreen()));
                },
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
