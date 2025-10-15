import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Cache Service for managing app data caching
/// Uses Hive for complex data and SharedPreferences for simple key-value pairs
class CacheService {
  // Private constructor
  CacheService._();

  // Box names
  static const String _apiCacheBox = 'api_cache';
  static const String _userDataBox = 'user_data';

  // Cache duration in hours
  static const int defaultCacheDuration = 24;

  /// Initialize cache service
  static Future<void> init() async {
    // Hive boxes are opened on demand
    // You can open them here if needed for immediate access
  }

  /// Get API cache box
  static Future<Box> _getApiCacheBox() async {
    if (!Hive.isBoxOpen(_apiCacheBox)) {
      return await Hive.openBox(_apiCacheBox);
    }
    return Hive.box(_apiCacheBox);
  }

  /// Get user data box
  static Future<Box> _getUserDataBox() async {
    if (!Hive.isBoxOpen(_userDataBox)) {
      return await Hive.openBox(_userDataBox);
    }
    return Hive.box(_userDataBox);
  }

  /// Cache API response
  /// [key] - Unique identifier for the cache entry
  /// [data] - Data to cache
  /// [duration] - Cache duration in hours (default: 24 hours)
  static Future<void> cacheApiResponse(
    String key,
    dynamic data, {
    int duration = defaultCacheDuration,
  }) async {
    try {
      final box = await _getApiCacheBox();
      final cacheData = {
        'data': data,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'duration': duration,
      };
      await box.put(key, cacheData);
    } catch (e) {
      print('Error caching API response: $e');
    }
  }

  /// Get cached API response
  /// Returns null if cache doesn't exist or has expired
  static Future<dynamic> getCachedApiResponse(String key) async {
    try {
      final box = await _getApiCacheBox();
      final cacheData = box.get(key);

      if (cacheData == null) return null;

      // Check if cache has expired
      final timestamp = cacheData['timestamp'] as int;
      final duration = cacheData['duration'] as int;
      final expiryTime = DateTime.fromMillisecondsSinceEpoch(timestamp)
          .add(Duration(hours: duration));

      if (DateTime.now().isAfter(expiryTime)) {
        // Cache expired, remove it
        await box.delete(key);
        return null;
      }

      return cacheData['data'];
    } catch (e) {
      print('Error getting cached API response: $e');
      return null;
    }
  }

  /// Clear all API cache
  static Future<void> clearApiCache() async {
    try {
      final box = await _getApiCacheBox();
      await box.clear();
    } catch (e) {
      print('Error clearing API cache: $e');
    }
  }

  /// Clear specific cache entry
  static Future<void> clearCacheEntry(String key) async {
    try {
      final box = await _getApiCacheBox();
      await box.delete(key);
    } catch (e) {
      print('Error clearing cache entry: $e');
    }
  }

  /// Save user data
  static Future<void> saveUserData(String key, dynamic value) async {
    try {
      final box = await _getUserDataBox();
      await box.put(key, value);
    } catch (e) {
      print('Error saving user data: $e');
    }
  }

  /// Get user data
  static Future<dynamic> getUserData(String key) async {
    try {
      final box = await _getUserDataBox();
      return box.get(key);
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  /// Clear all user data
  static Future<void> clearUserData() async {
    try {
      final box = await _getUserDataBox();
      await box.clear();
    } catch (e) {
      print('Error clearing user data: $e');
    }
  }

  /// Clear all cache (API + User Data)
  static Future<void> clearAllCache() async {
    await clearApiCache();
    await clearUserData();
  }

  // SharedPreferences helpers for simple key-value storage

  /// Save string to SharedPreferences
  static Future<bool> saveString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setString(key, value);
  }

  /// Get string from SharedPreferences
  static Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  /// Save bool to SharedPreferences
  static Future<bool> saveBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(key, value);
  }

  /// Get bool from SharedPreferences
  static Future<bool?> getBool(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  /// Save int to SharedPreferences
  static Future<bool> saveInt(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setInt(key, value);
  }

  /// Get int from SharedPreferences
  static Future<int?> getInt(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }

  /// Remove key from SharedPreferences
  static Future<bool> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.remove(key);
  }

  /// Clear all SharedPreferences
  static Future<bool> clearPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.clear();
  }
}
