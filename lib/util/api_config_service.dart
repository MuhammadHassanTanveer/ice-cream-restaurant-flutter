import 'package:shared_preferences/shared_preferences.dart';

class ApiConfigService {
  static const String _baseUrlKey = 'api_base_url';
  static const String _imageUrlKey = 'api_image_url';

  // Default values
  static const String defaultBaseUrl = 'http://192.168.92.174:8000/api';
  static const String defaultImageUrl = 'http://192.168.92.174:8000/';

  static Future<String> getBaseUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_baseUrlKey) ?? defaultBaseUrl;
  }

  static Future<String> getImageUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_imageUrlKey) ?? defaultImageUrl;
  }

  static Future<void> setBaseUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_baseUrlKey, url);
  }

  static Future<void> setImageUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_imageUrlKey, url);
  }

  static Future<void> resetToDefaults() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_baseUrlKey);
    await prefs.remove(_imageUrlKey);
  }

  static Future<bool> isCustomUrlSet() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_baseUrlKey);
  }
}

