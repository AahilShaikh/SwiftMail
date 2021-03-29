import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lit_firebase_auth/lit_firebase_auth.dart';
import 'package:swift_mail/dataManager.dart';
import 'package:intl/intl.dart';
import 'package:swift_mail/palette.dart';
import 'package:swift_mail/screens/emailViewer.dart';
import 'package:swift_mail/screens/newEmail.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'auth/auth.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget{
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  var user = FirebaseAuth.instance.currentUser;

  Future<void> updateIsRead ({int index})async {
    var ref = FirebaseFirestore.instance.collection('Users').doc(user.email);
    await ref.get().then((DocumentSnapshot docSnapshot){
      List<dynamic> list = List.from(docSnapshot.data()['Emails']);
      list[index]['isRead'] = true;
      ref.update({'Emails': list});
    });

  }
  @override
  Widget build(BuildContext context) {
    UserEmails userEmails = Provider.of<UserEmails>(context);
    setState(() {

    });
    return Scaffold(
      appBar: AppBar(
        title: Text('Swift Mail'),
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Center(child: Text('Swift Mail', style: TextStyle(fontSize: 35,),)),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment(0.8, 0.0),
                    colors: <Color>[
                      Palette.darkGreen,
                      Palette.blue
                    ],
                    tileMode: TileMode.mirror,
                  ),
                ),
              ),
              ListTile(
                title: Text('Home'),
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
                },
              ),
              ListTile(
                title: Text('Settings'),
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
                },
              ),
            ],
          ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, size: 45,),
        onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewEmail()));
        },
      ),
      body: Column(
        children: [
          Container(
            width: 100,
            child: TextButton(
              child: Text('Sign out', style: TextStyle(color: Colors.red),),
              onPressed: (){
                context.signOut();
                Navigator.of(context).pop();
                Navigator.of(context).push(AuthScreen.route);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: userEmails.emails == null || userEmails.emails[0]['Status'] == 'Loading' ? 0 : userEmails.emails.length,
              itemBuilder: (context, index){
                FontWeight bold = FontWeight.bold;

                if(userEmails.emails[index]['isRead'] == false){
                  bold = FontWeight.bold;
                }else if(userEmails.emails[index]['isRead'] == true){
                  bold = FontWeight.normal;
                }
                return InkWell(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.zero,
                          height: 40,
                          width: 40,
                          child: Center(child: Text('${userEmails.emails[index]['Sender']?.toUpperCase()?.substring(0,1)}', style: TextStyle(fontSize: 20))),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.primaries[Random().nextInt(Colors.primaries.length)]
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text('${userEmails.emails[index]['Sender']}', style: TextStyle(fontWeight: bold),),
                              Text('${userEmails.emails[index]['Title']}',style: TextStyle(fontWeight: FontWeight.bold)),
                              Text('${userEmails.emails[index]['Content']}', style: TextStyle(fontWeight: bold),),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Column(
                            children: [
                              Text('${dateFormat?.format(userEmails.emails[index]['Date Sent']?.toDate())}', textAlign: TextAlign.end, style: TextStyle(fontWeight: bold),),
                            ],
                          ),
                        ),

                      ],
                    )
                  ),
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => EmailViewer(content: userEmails.emails[index]['Content'], dateSent: dateFormat?.format(userEmails.emails[index]['Date Sent']?.toDate()), sender: userEmails.emails[index]['Sender'], title: userEmails.emails[index]['Title'])));
                      if(userEmails.emails[index]['isRead'] == false) {
                        updateIsRead(index: index);
                      }
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}