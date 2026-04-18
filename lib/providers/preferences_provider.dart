import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/splash_screen.dart';

class PreferencesProvider with ChangeNotifier {
  String? token;
  int? id;

  Future<void> checkToken() async {
    try {
      debugPrint("Checking token in SharedPreferences");
      final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();

      token = sharedPrefs.getString("token");
      id = sharedPrefs.getInt("id");

      notifyListeners();
    } catch (e) {
      debugPrint("Error checking token: $e");
      rethrow;
    }
  }

  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  Future<void> logOut(BuildContext context) async {
    if (_disposed) return;

    try {
      final SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.clear();

      token = null;
      id = null;

      if (!_disposed) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const SplashScreen()),
              (route) => false,
        );
        notifyListeners();
      }
    } catch (e) {
      if (!_disposed) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to logout properly')),
        );
      }
      rethrow;
    }
  }
}