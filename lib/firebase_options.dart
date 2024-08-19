// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBdDGh1le6yYRjaX9Y_YOuGWtVQfEp0k5Q',
    appId: '1:265728956034:android:fa23b56f24f8deaee6869b',
    messagingSenderId: '265728956034',
    projectId: 'gnovation-wakulima-d5bbc',
    storageBucket: 'gnovation-wakulima-d5bbc.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAwdgORp59Sx4uKiU-ofIS_nYpHe4D7kDA',
    appId: '1:265728956034:ios:33f01adb955668afe6869b',
    messagingSenderId: '265728956034',
    projectId: 'gnovation-wakulima-d5bbc',
    storageBucket: 'gnovation-wakulima-d5bbc.appspot.com',
    androidClientId: '265728956034-3bgebgfk0q6joqtmjbp8tq8eiotd3u30.apps.googleusercontent.com',
    iosClientId: '265728956034-v9r3gcq6fhhfg2ukr3dboea2at7lnj3i.apps.googleusercontent.com',
    iosBundleId: 'com.example.itx',
  );

}