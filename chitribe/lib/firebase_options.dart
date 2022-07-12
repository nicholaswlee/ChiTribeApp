// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCnGGHY0ibiYgQtbPByA-auNpxcMZ4AJDM',
    appId: '1:349174942739:web:6e0ccfa2174d65eab343e6',
    messagingSenderId: '349174942739',
    projectId: 'chitribe-app',
    authDomain: 'chitribe-app.firebaseapp.com',
    storageBucket: 'chitribe-app.appspot.com',
    measurementId: 'G-M24WEJ9HGD',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAkMB_5Um3qf3GIM6daSjbGrtZ2kvem3is',
    appId: '1:349174942739:android:58ad967879454db3b343e6',
    messagingSenderId: '349174942739',
    projectId: 'chitribe-app',
    storageBucket: 'chitribe-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDRkdmU4TsNJl_JgkBbRWwYC5MAbPY_LpQ',
    appId: '1:349174942739:ios:e7a0b2f7c6b58f1db343e6',
    messagingSenderId: '349174942739',
    projectId: 'chitribe-app',
    storageBucket: 'chitribe-app.appspot.com',
    iosClientId: '349174942739-6v7vf2hf58707b9qpllmi99a70phnrkt.apps.googleusercontent.com',
    iosBundleId: 'com.example.chitribe',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDRkdmU4TsNJl_JgkBbRWwYC5MAbPY_LpQ',
    appId: '1:349174942739:ios:e7a0b2f7c6b58f1db343e6',
    messagingSenderId: '349174942739',
    projectId: 'chitribe-app',
    storageBucket: 'chitribe-app.appspot.com',
    iosClientId: '349174942739-6v7vf2hf58707b9qpllmi99a70phnrkt.apps.googleusercontent.com',
    iosBundleId: 'com.example.chitribe',
  );
}