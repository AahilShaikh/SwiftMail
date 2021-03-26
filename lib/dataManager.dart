import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserEmails{
  List<dynamic> emails;

  UserEmails({this.emails});

  var user = FirebaseAuth.instance.currentUser;
  //send data to fire store
  void writeWeightData({@required List<Map<String, dynamic>> value}){
    FirebaseFirestore.instance.collection('Users').doc(user.email).update({'Emails': FieldValue.arrayUnion(value)});
  }
}


class DB{
  var user = FirebaseAuth.instance.currentUser;
  final _db = FirebaseFirestore.instance;

  Stream<UserEmails> get emails {
    return _db.collection('Users').doc(user?.email).snapshots().map((DocumentSnapshot documentSnapshot ) => UserEmails(emails: documentSnapshot.data()['Emails']));
  }

}