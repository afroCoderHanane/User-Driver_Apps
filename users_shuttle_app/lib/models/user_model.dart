import 'package:firebase_database/firebase_database.dart';

class UserModel{
  String? phone;
  String? email;
  String? id;
  String? name;

  UserModel({this.phone, this.email, this.id, this.name});
  UserModel.fromSnapshot(DataSnapshot snap){
    phone = (snap.value as dynamic)["phone"];
    name = (snap.value as dynamic)["name"];
    id = snap.key;
    email = (snap.value as dynamic)["email"];
  }
}