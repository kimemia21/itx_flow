import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:itx/testlab/TestLab.dart';
import 'package:itx/authentication/LoginScreen.dart';
import 'package:itx/authentication/SignUp.dart';
import 'package:itx/chatbox/ChatBox.dart';
import 'package:itx/chatbox/ChatList.dart';
import 'package:itx/rss/RSSFEED.dart';
import 'package:itx/uploadCerts/Regulator.dart';
import 'package:itx/authentication/SplashScreen.dart';
import 'package:itx/firebase_options.dart';
import 'package:itx/state/AppBloc.dart';
import 'package:itx/global/GlobalsHomepage.dart';
import 'package:itx/requests/HomepageRequest.dart';
import 'package:itx/web/authentication/ComOfInterest.dart';
import 'package:itx/web/authentication/WebLogin.dart';

import 'package:itx/web/homepage/WebNav.dart';
import 'package:itx/web/state/Webbloc.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // runApp(TestLab());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return
        // TestLab();

        MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CurrentUserProvider()),
        ChangeNotifierProvider(create: (context) => appBloc()),
        ChangeNotifierProvider(create: (context) => Webbloc())
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
    final appBloc appbloc = context.watch<appBloc>();
    final appBloc setBloc = context.read<appBloc>();
    // Web platform
    if (kIsWeb || Platform.isWindows) {
      setBloc.changePlatform("web");
      //  List<CommoditiesCert> ITEMS = [];
      return Weblogin();
      // WebCommoditiesOfInterest(isWareHouse: false);

      // WebNav();

      // Webregulators(commCerts: ITEMS, isWareHouse: false);
      // WebVerification(
      //     context: context,
      //     email: "email",
      //     isRegistered: false,
      //     isWareHouse: false);
    }
    // Android or iOS platform
    else if (Platform.isAndroid || Platform.isIOS) {
      setBloc.changePlatform("android");
      return  Splashscreen();
          // ChatScreen();
          // MainSignup();
          // ChatListScreen();

   
      //  appbloc.token == "" ? Splashscreen() : GlobalsHomePage();

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
