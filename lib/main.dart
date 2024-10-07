import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:itx/authentication/LoginScreen.dart';
import 'package:itx/uploadCerts/Regulator.dart';
import 'package:itx/authentication/SplashScreen.dart';
import 'package:itx/firebase_options.dart';
import 'package:itx/state/AppBloc.dart';
import 'package:itx/global/GlobalsHomepage.dart';
import 'package:itx/requests/HomepageRequest.dart';
import 'package:itx/web/HomePageWeb.dart';
import 'package:itx/web/authentication/SignUp.dart';
import 'package:itx/web/authentication/SignInWeb.dart';
import 'package:itx/web/authentication/WebSplash.dart';
import 'package:itx/web/state/Webbloc.dart';
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
      providers: [
        ChangeNotifierProvider(create: (context) => CurrentUserProvider()),
        ChangeNotifierProvider(create: (context) => appBloc()),
        ChangeNotifierProvider(create: (context)=>Webbloc())
      ],
      child: MaterialApp(home: GetPlatform()),
    );
  }
}

class GetPlatform extends StatefulWidget {
  const GetPlatform({super.key});

  @override
  State<GetPlatform> createState() => _GetPlatformState();
}

class _GetPlatformState extends State<GetPlatform> {
  @override
  Widget build(BuildContext context) {
    final appBloc bloc = context.watch<appBloc>();
    // Web platform
    if (kIsWeb) {
      return  HomePageWeb(title: "title");
      
      
      // bloc.token == "" ? SplashScreenWeb() :  SignInWeb();
    }
    // Android or iOS platform
    else if (Platform.isAndroid || Platform.isIOS) {
      return bloc.token == "" ?   Splashscreen():GlobalsHomePage();
    
      // Regulators() : Regulators(); 
      // Splashscreen():GlobalsHomePage();
      
      // Regulators() : Regulators();
    } else {
      // Fallback for unsupported platforms
      return Scaffold(
          body: Center(
        child: Text('Unsupported Platform'),
      ));
    }
  }
}
