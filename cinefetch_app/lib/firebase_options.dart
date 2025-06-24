import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyBCny6i7PTfQFGkc52pbLtB6X71pp2s4hg',
    appId: '1:838367836113:web:277e21e84b117db591d2f0',
    messagingSenderId: '838367836113',
    projectId: 'cinefetch-movie-downloader-app',
    authDomain: 'cinefetch-movie-downloader-app.firebaseapp.com',
    storageBucket: 'cinefetch-movie-downloader-app.firebasestorage.app',
    measurementId: 'G-T02KSECL26',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDarU8Krkp9hkmA_ZES4_odZARHb056TGQ',
    appId: '1:838367836113:android:6dbe9df5d9e2c8aa91d2f0',
    messagingSenderId: '838367836113',
    projectId: 'cinefetch-movie-downloader-app',
    storageBucket: 'cinefetch-movie-downloader-app.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDOf19llcFAks1IzauiU7a4nhqE0bLmPj4',
    appId: '1:838367836113:ios:bd3b0063e953aba391d2f0',
    messagingSenderId: '838367836113',
    projectId: 'cinefetch-movie-downloader-app',
    storageBucket: 'cinefetch-movie-downloader-app.firebasestorage.app',
    iosBundleId: 'com.example.cinefetchApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDOf19llcFAks1IzauiU7a4nhqE0bLmPj4',
    appId: '1:838367836113:ios:bd3b0063e953aba391d2f0',
    messagingSenderId: '838367836113',
    projectId: 'cinefetch-movie-downloader-app',
    storageBucket: 'cinefetch-movie-downloader-app.firebasestorage.app',
    iosBundleId: 'com.example.cinefetchApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBCny6i7PTfQFGkc52pbLtB6X71pp2s4hg',
    appId: '1:838367836113:web:5975a0d5fb50fdb991d2f0',
    messagingSenderId: '838367836113',
    projectId: 'cinefetch-movie-downloader-app',
    authDomain: 'cinefetch-movie-downloader-app.firebaseapp.com',
    storageBucket: 'cinefetch-movie-downloader-app.firebasestorage.app',
    measurementId: 'G-7LP0XWJSCN',
  );
}
