
import 'package:flutter/material.dart';
import 'package:lit_firebase_auth/lit_firebase_auth.dart';
import 'package:swift_mail/screens/auth/sign_in_up_bar.dart';
import 'package:swift_mail/screens/auth/title.dart';

import '../../palette.dart';
import 'decoration_functions.dart';

class SignIn extends StatelessWidget{
  const SignIn({Key key, @required this.onRegisteredCallback}) : super(key: key);

  final VoidCallback onRegisteredCallback;

  @override
  Widget build(BuildContext context) {
    final isSubmitting = context.isSubmitting();
    return SignInForm(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerLeft,
                child: LoginTitle(
                  title: 'Welcome\nBack',
                ),

              ),
            ),
            Expanded(
              flex: 5,
              child: ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: EmailTextFormField(
                      decoration: signInInputDecoration(hintText: 'Email'),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: PasswordTextFormField(
                      decoration: signInInputDecoration(hintText: 'Password'),
                    ),
                  ),
                  SignInBar(
                    isLoading: isSubmitting,
                    label: 'Sign in',
                    onPressed: (){
                      context.signInWithEmailAndPassword();
                    },
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      splashColor: Colors.white,
                      onTap: (){
                        onRegisteredCallback?.call();
                    },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                          color: Palette.darkGreen,
                        ),
                      )
                    ),
                  )
                ],
              ),
            )

          ],
        ),
      ),
    );
  }

}