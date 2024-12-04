import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:itx/Temp/forwards.dart';
import 'package:itx/Temp/htmltest.dart';
import 'package:itx/backgroundEvents/SSE.dart';
import 'package:itx/testlab/TestLab.dart';
import 'package:itx/authentication/LoginScreen.dart';
import 'package:itx/authentication/SignUp.dart';
import 'package:itx/chatbox/ChatBox.dart';
import 'package:itx/chatbox/ChatList.dart';
import 'package:itx/rss/RSSFEED.dart';
import 'package:itx/testlab/chatTest.dart';
import 'package:itx/testlab/googleme.dart';
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
import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    print('Error: ${details.exception}');
    print('Stack trace: ${details.stack}');
  };

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // runApp(TestLab());
  runApp(MyApp());
}


// void _initializeWebViewPlatform() {
//     // AndroidWebViewPlatform.registerWith();
//   // // Check and initialize platform-specific WebView
//   if (WebViewPlatform.instance is WebKitWebViewPlatform) {
//     // iOS-specific initialization
//     WebKitWebViewPlatform.registerWith();
//   }
  
//   if (WebViewPlatform.instance is AndroidWebViewPlatform) {
//     // Android-specific initialization
//     AndroidWebViewPlatform.registerWith();
//   }
// }


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
      child: MaterialApp(home: GetPlatform()
      // HTMLViewerPage()
      // GetPlatform()
      // HTMLViewerPage()
      // GetPlatform()
      //  testChat()
      
      // GetPlatform()
      // HTMLViewerPage()
      // GetPlatform()
          //  SSEBackgroundServiceExample()
          //  SignInDemo()
          //  GetPlatform()
          //  ForwardContractWidget()

          // ForwardContractWidget()
          // GetPlatform()

          ),
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
      return Splashscreen();
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
