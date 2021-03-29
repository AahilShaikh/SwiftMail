import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lit_firebase_auth/lit_firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:swift_mail/screens/Home.dart';

class NewEmail extends StatefulWidget{
  @override
  _NewEmailState createState() => _NewEmailState();
}

class _NewEmailState extends State<NewEmail> {
  TextEditingController _subjectController = TextEditingController(text: '');
  TextEditingController _recipientController = TextEditingController(text: '');
  TextEditingController _contentController = TextEditingController(text: '');

  @override
  void dispose() {
    _contentController.dispose();
    _recipientController.dispose();
    _subjectController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    var user = context.getSignedInUser();
    user.when((user) => (){
    }, 
        empty: (){
        }, 
        initializing: (){
          firebaseUser.reload();
        });
    return Scaffold(
      appBar: AppBar(
        title: Text('New Email'),
      ),
      persistentFooterButtons: [
        IconButton(icon: Icon(Icons.send, size: 40,),
            onPressed: (){
              final options = SetOptions(merge: true);

              if(_subjectController.text == null || _subjectController.text == '') {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Subject cannot be empty'),));
              } else if(_recipientController.text == null || _recipientController.text == '') {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please provide a recipient'),));
              }else if((_subjectController.text != null || _subjectController.text != '') && (_recipientController.text != null || _recipientController.text != '')){
                FirebaseFirestore.instance.collection('Users').doc(_recipientController.text).set({'Emails': FieldValue.arrayUnion(
                    [{'Title': _subjectController.text, 'Sender': firebaseUser.email, 'Content': _contentController.text, 'Date Sent': DateTime.now(), 'isRead': false}]
                ), }, options);
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
              }
            }
        )
      ],
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text('Subject: '),
                    Expanded(
                      child: TextField(
                        controller: _subjectController,
                      ),
                    )
                  ],
                ),
                Divider(),
                Row(
                  children: [
                    Text('Recipient: '),
                    Expanded(
                      child: TextField(
                        controller: _recipientController,
                      ),
                    )
                  ],
                ),
                Divider(),
                TextFormField(
                  minLines: 10,
                  maxLines: 100,
                  controller: _contentController,
                  decoration: new InputDecoration(
                    isDense: true,
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                      ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}