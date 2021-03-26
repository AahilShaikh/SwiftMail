import 'package:flutter/material.dart';
import 'package:lit_firebase_auth/lit_firebase_auth.dart';

import 'auth/auth.dart';

class HomePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Swift Mail'),
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