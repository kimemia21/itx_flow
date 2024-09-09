import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:itx/authentication/Login.dart';
import 'package:itx/authentication/SplashScreen.dart';
import 'package:itx/firebase_options.dart';
import 'package:itx/global/AppBloc.dart';
import 'package:itx/web/CreateAccount.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      child: 
    MaterialApp(
      home: _getHomeScreen(),
    ),
      providers: [
      ChangeNotifierProvider(create: (context)=>CurrentUserProvider()),
        ChangeNotifierProvider(create: (context)=>appBloc())
  
    ]);

  }

  Widget _getHomeScreen() {
    // Web platform
    if (kIsWeb) {
      return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            return CreateAccountScreen();
          } else {
            return CreateAccountScreen(); // You can replace this with a different screen if needed
          }
        },
      );
    }
    // Android or iOS platform
    else if (Platform.isAndroid || Platform.isIOS) {
      return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            return Splashscreen(); // Replace with your authenticated home screen
          } else {
            return Splashscreen(); // Replace with your login screen
          }
        },
      );
    } else {
      // Fallback for unsupported platforms
      return Scaffold(
        body: Center(
          child: Text('Unsupported Platform'),
        ),
      );
    }
  }
}
