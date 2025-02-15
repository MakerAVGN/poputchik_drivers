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
///
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
        return windows;
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
    apiKey: 'AIzaSyAnGUgt3LfYJQ2QWJ5JwwzoL8kZzwTz4uw',
    appId: '1:674584804485:web:dc0bd99530bf4705617dec',
    messagingSenderId: '674584804485',
    projectId: 'poputchik-7827e',
    authDomain: 'poputchik-7827e.firebaseapp.com',
    databaseURL: 'https://poputchik-7827e-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'poputchik-7827e.appspot.com',
    measurementId: 'G-XGSK23VXHK',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCiXB657JrmqwGVO3-Wy5t8jeNMeVZSr24',
    appId: '1:674584804485:android:2f2c97b29e32c4ea617dec',
    messagingSenderId: '674584804485',
    projectId: 'poputchik-7827e',
    databaseURL: 'https://poputchik-7827e-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'poputchik-7827e.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAzBqmXjO72gOx18IqNIT1QMeU26RkM1Vo',
    appId: '1:674584804485:ios:713b8ad9a3a64a35617dec',
    messagingSenderId: '674584804485',
    projectId: 'poputchik-7827e',
    databaseURL: 'https://poputchik-7827e-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'poputchik-7827e.appspot.com',
    iosBundleId: 'com.example.poputchik',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAzBqmXjO72gOx18IqNIT1QMeU26RkM1Vo',
    appId: '1:674584804485:ios:713b8ad9a3a64a35617dec',
    messagingSenderId: '674584804485',
    projectId: 'poputchik-7827e',
    databaseURL: 'https://poputchik-7827e-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'poputchik-7827e.appspot.com',
    iosBundleId: 'com.example.poputchik',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAnGUgt3LfYJQ2QWJ5JwwzoL8kZzwTz4uw',
    appId: '1:674584804485:web:c85109547264fadb617dec',
    messagingSenderId: '674584804485',
    projectId: 'poputchik-7827e',
    authDomain: 'poputchik-7827e.firebaseapp.com',
    databaseURL: 'https://poputchik-7827e-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'poputchik-7827e.appspot.com',
    measurementId: 'G-LE8M6SYXQE',
  );
}
