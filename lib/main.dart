import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:itx/Temp/forwards.dart';
import 'package:itx/backgroundEvents/SSE.dart';
import 'package:itx/testlab/TestLab.dart';
import 'package:itx/authentication/LoginScreen.dart';
import 'package:itx/authentication/SignUp.dart';
import 'package:itx/chatbox/ChatBox.dart';
import 'package:itx/chatbox/ChatList.dart';
import 'package:itx/rss/RSSFEED.dart';
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
  // SSEClient.subscribeToSSE(
  //     method: SSERequestType.GET,
  //     url:
  //         'https://api.coingecko.com/api/v3/simple/price?ids=bitcoin,ethereum&vs_currencies=usd',
  //     header: {
  //       "Cookie":
  //           'jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6InRlc3QiLCJpYXQiOjE2NDMyMTAyMzEsImV4cCI6MTY0MzgxNTAzMX0.U0aCAM2fKE1OVnGFbgAU_UVBvNwOMMquvPY8QaLD138; Path=/; Expires=Wed, 02 Feb 2022 15:17:11 GMT; HttpOnly; SameSite=Strict',
  //       "Accept": "text/event-stream",
  //       "Cache-Control": "no-cache",
  //     }).listen(
  //   (event) {
  //     print('Id: ' + (event.id ?? ""));
  //     print('Event: ' + (event.event ?? ""));
  //     print('Data: ' + (event.data ?? ""));
  //   },
  // );
    // Set preferred orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // runApp(TestLab());
  runApp(MyApp());
}


void _initializeWebViewPlatform() {
    // AndroidWebViewPlatform.registerWith();
  // // Check and initialize platform-specific WebView
  if (WebViewPlatform.instance is WebKitWebViewPlatform) {
    // iOS-specific initialization
    WebKitWebViewPlatform.registerWith();
  }
  
  if (WebViewPlatform.instance is AndroidWebViewPlatform) {
    // Android-specific initialization
    AndroidWebViewPlatform.registerWith();
  }
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
      child: MaterialApp(home: GetPlatform()
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
