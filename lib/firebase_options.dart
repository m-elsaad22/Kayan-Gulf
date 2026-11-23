// ============================================================
// KAYAN — Firebase Configuration
// Generated equivalent of: flutterfire configure
//
// Firebase Project : Kayan App
// Project ID       : gen-lang-client-0346607969
// Android App ID   : 1:615945882751:android:9e87bbf13f6ce2fc8a434a
// Package Name     : sa.kayan.app
//
// To regenerate this file with FlutterFire CLI:
//   dart pub global activate flutterfire_cli
//   flutterfire configure --project=gen-lang-client-0346607969
// ============================================================

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web. '
        'Run FlutterFire CLI to add web support.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for iOS. '
          'Add GoogleService-Info.plist and run FlutterFire CLI.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC9hHPi4rOE-YYh6a6a9D0TwpCFkq50PtY',
    appId: '1:615945882751:android:9e87bbf13f6ce2fc8a434a',
    messagingSenderId: '615945882751',
    projectId: 'gen-lang-client-0346607969',
    storageBucket: 'gen-lang-client-0346607969.firebasestorage.app',
  );
}
