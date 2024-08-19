import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:itx/Contracts/Contracts.dart';
import 'package:itx/Contracts/LiveAuction.dart';
import 'package:itx/Contracts/SpotItem.dart';
import 'package:itx/Contracts/SpotTrader.dart';
import 'package:itx/authentication/Login.dart';
import 'package:itx/fromWakulima/AppBloc.dart';
import 'package:itx/fromWakulima/firebase_options.dart';
import 'package:itx/global/AppBloc.dart';
import 'package:itx/global/MyScafold.dart';
import 'package:itx/global/app.dart';
import 'package:provider/provider.dart';

void main() async{
WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
              ChangeNotifierProvider(create: (context)=>CurrentUserProvider()),
              ChangeNotifierProvider(create: (context) => appBloc())],
            child: MaterialApp(home: MyHomepage())));
  }
}
