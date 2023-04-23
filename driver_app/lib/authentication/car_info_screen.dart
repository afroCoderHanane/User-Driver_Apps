import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_database/firebase_database.dart';

import '../global/global.dart';
import '../splashScreen/splash_screen.dart';

class CarInfoScreen extends StatefulWidget {

  @override
  State<CarInfoScreen> createState() => _CarInfoScreenState();
}

class _CarInfoScreenState extends State<CarInfoScreen> {


  TextEditingController carModelTextEditingController = TextEditingController();
  TextEditingController carNumberTextEditingController = TextEditingController();
  TextEditingController carColorTextEditingController = TextEditingController();

  List<String>carTypesList = ["shuttle", "bus"];
  String? selectedCarType;

  saveCarInfo(){
    Map driverCarInfoMap = {
      "car_color": carColorTextEditingController.text.trim(),
      "car_number": carNumberTextEditingController.text.trim(),
      "car_model": carModelTextEditingController.text.trim(),
      "car_type": selectedCarType,
    };

    DatabaseReference driverRef = FirebaseDatabase.instance.ref().child("drivers");
    driverRef.child(currentFirebaseUser!.uid).child("car_details").set(driverCarInfoMap);

    Fluttertoast.showToast(msg: "Car detail saved! Enjoy the App");

    Navigator.push(context, MaterialPageRoute(builder: (c)=>const MySplashScreen()));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [

              const SizedBox(height: 12,),

              Padding(
                padding: const EdgeInsets.all(35.0),
                child: Image.asset("images/logo-color.png"),
              ),

              const SizedBox(height: 12,),

              const Text(
                "REGISTER CAR",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),

              TextField(
                controller: carModelTextEditingController,
                style: const TextStyle(
                    color: Colors.black87
                ),
                decoration: const InputDecoration(
                  labelText: "Car Model",
                  hintText: "Enter the car Model",
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
                controller: carNumberTextEditingController,
                keyboardType: TextInputType.text,
                style: const TextStyle(
                    color: Colors.black87
                ),
                decoration: const InputDecoration(
                  labelText: "Car Number",
                  hintText: "Enter the car number",
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
                controller: carColorTextEditingController,
                keyboardType: TextInputType.text,
                style: const TextStyle(
                    color: Colors.black87
                ),
                decoration: const InputDecoration(
                  labelText: "Shuttle number",
                  hintText: "Enter shuttle number",
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

              DropdownButton(

                dropdownColor: Colors.grey,

                hint: const Text(
                  " Choose car Type",
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey,
                  ),
                ),
                value: selectedCarType,
                onChanged: (newValue){
                  setState(() {
                    selectedCarType = newValue.toString();
                  });
                },
                items: carTypesList.map((car){
                  return DropdownMenuItem(value: car,child: Text(car,
                  ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 20,),

              ElevatedButton(
                onPressed: (){
                  if (carColorTextEditingController.text.isNotEmpty &&
                      carNumberTextEditingController.text.isNotEmpty &&
                      carModelTextEditingController.text.isNotEmpty &&
                      selectedCarType != null ){
                    saveCarInfo();
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors. grey
                ),
                child: const Text(
                  "Next",
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18
                  ),
                ),
              ),
            ],
          ),
        ) ,
      ) ,
    );
  }
}