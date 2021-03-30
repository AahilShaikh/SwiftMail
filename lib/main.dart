import 'package:flutter/material.dart';

// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:lit_firebase_auth/lit_firebase_auth.dart';
import 'package:swift_mail/dataManager.dart';
import 'package:swift_mail/palette.dart';
import 'package:swift_mail/screens/splash.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}

class App extends StatelessWidget {
  // Create the initialization Future outside of `build`:

  @override
  Widget build(BuildContext context) {
    return LitAuthInit(
        child: MultiProvider(

          providers: [
            StreamProvider<UserEmails>.value(catchError: (_, __) => UserEmails(emails: [{'Status' : 'Loading'}]), initialData: UserEmails(emails: [{'Status': 'Loading'}]), value: DB().emails),

          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Scouting App',
            theme: ThemeData(
                visualDensity: VisualDensity.adaptivePlatformDensity,
                secondaryHeaderColor: Palette.blue,
                appBarTheme: const AppBarTheme(
                  brightness: Brightness.dark,
                  color: Palette.blue,
                ),

                snackBarTheme: const SnackBarThemeData(
                    backgroundColor: Palette.blue
                )
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              primarySwatch: Colors.blue
            ),
            //Splash screen switches between Home or AuthScreen based on whether signed in with a transition
            home: SplashScreen(),
          ),
        )
    );
  }
}