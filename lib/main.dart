import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:itx/Contracts/Contracts.dart';
import 'package:itx/Contracts/LiveAuction.dart';
import 'package:itx/Contracts/SpotItem.dart';
import 'package:itx/Contracts/SpotTrader.dart';
import 'package:itx/authentication/Login.dart';
import 'package:itx/authentication/SplashScreen.dart';
import 'package:itx/fromWakulima/AppBloc.dart';
import 'package:itx/fromWakulima/firebase_options.dart';
import 'package:itx/global/AppBloc.dart';
import 'package:itx/global/MyScafold.dart';
import 'package:itx/global/app.dart';
import 'package:itx/web/CreateAccount.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: MultiProvider(
            providers: [
          ChangeNotifierProvider(create: (context) => CurrentUserProvider()),
          ChangeNotifierProvider(create: (context) => appBloc())
        ],
            child: CreateAccountScreen()
            //     StreamBuilder<User?>(
            //   stream: FirebaseAuth.instance.authStateChanges(),
            //   builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
            //     if (snapshot.connectionState == ConnectionState.waiting) {
            //       return Center(
            //         child: LoadingAnimationWidget.hexagonDots(
            //             color: Colors.green, size: 30),
            //       );
            //     } else if (snapshot.hasData) {
            //       return CreateAccountScreen();
            //     } else {
            //       return  CreateAccountScreen();
            //     }
            //   },
            // )
          )
            );
  }
}
