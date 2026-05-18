import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppEnv {
  static String _required(String key) {
    final value = dotenv.env[key];
    if (value == null || value.isEmpty) {
      throw StateError('Missing required env var: $key');
    }
    return value;
  }

  static String get firebaseApiKey => _required('FIREBASE_API_KEY');

  static String get firebaseAppId => _required('FIREBASE_APP_ID');

  static String get firebaseMessagingSenderId =>
      _required('FIREBASE_MESSAGING_SENDER_ID');

  static String get firebaseProjectId => _required('FIREBASE_PROJECT_ID');

  static String get firebaseStorageBucket => _required('FIREBASE_STORAGE_BUCKET');
}