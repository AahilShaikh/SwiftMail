import 'package:flutter/material.dart';
import 'package:lit_firebase_auth/lit_firebase_auth.dart';
import '../palette.dart';
import 'Home.dart';
import 'auth/auth.dart';

class AccountPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Page'),
      ),
      drawer: Drawer(
        child: ListView(
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
              title: Text('Account Settings'),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => AccountPage()));
              },
            ),
          ],
        ),
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
        ],
      ),
    );
  }

}
