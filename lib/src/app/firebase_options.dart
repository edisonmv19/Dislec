import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  const DefaultFirebaseOptions._();

  static FirebaseOptions get currentPlatform {
    if (kIsWeb) throw UnsupportedError('Unsupported platform');
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return _android;
      case TargetPlatform.fuchsia:
        throw UnsupportedError('Unsupported platform');
      case TargetPlatform.iOS:
        throw UnsupportedError('Unsupported platform');
      case TargetPlatform.linux:
        throw UnsupportedError('Unsupported platform');
      case TargetPlatform.macOS:
        throw UnsupportedError('Unsupported platform');
      case TargetPlatform.windows:
        throw UnsupportedError('Unsupported platform');
    }
  }

  static const FirebaseOptions _android = FirebaseOptions(
    apiKey: 'AIzaSyBtMx7-aFFNHT1egnDom4qFHsuNajzOijY',
    appId: '1:885209556024:android:0d2db2d8fb66b1745ef2cd',
    messagingSenderId: '885209556024',
    projectId: 'dislec-login',
  );
}
