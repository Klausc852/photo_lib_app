import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvironmentService {
  static Future<void> initialize() async {
    await dotenv.load(fileName: ".env");
  }

  // API Configuration
  static String get apiBaseUrl => dotenv.env['API_BASE_URL'] ?? '';
  static String get apiKey => dotenv.env['API_KEY'] ?? '';

  // App Configuration
  static String get appName => dotenv.env['APP_NAME'] ?? 'Flutter Base';
  static String get appVersion => dotenv.env['APP_VERSION'] ?? '1.0.0';
  static bool get debugMode =>
      dotenv.env['DEBUG_MODE']?.toLowerCase() == 'true';

  // Third-party Services
  static String get googleMapsApiKey => dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';
  static String get firebaseProjectId =>
      dotenv.env['FIREBASE_PROJECT_ID'] ?? '';

  // Database
  static String get databaseUrl => dotenv.env['DATABASE_URL'] ?? '';

  // Utility method to check if environment is loaded
  static bool get isLoaded => dotenv.isEveryDefined(['API_BASE_URL']);

  // Get any environment variable by key
  static String getEnv(String key, {String defaultValue = ''}) {
    return dotenv.env[key] ?? defaultValue;
  }
}
