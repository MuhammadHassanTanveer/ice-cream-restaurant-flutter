import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/dashboard_model.dart';
import '../util/app_constants.dart';

class DashboardProvider with ChangeNotifier{
  DashboardModel? dashboardStats;
  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchDashboardStats({required String date}) async {
    _isLoading = true;
    notifyListeners();

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userId = prefs.getInt('id');
      var userToken = prefs.getString('token');
      final url = Uri.parse('${AppConstants.baseUrl}/orders/stats/daily?date=$date&user_id=$userId');
      final headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $userToken'
      };

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        dashboardStats = dashboardModelFromJson(response.body);
        _error = null;
      } else {
        _error = 'Failed to load dashboard stats: ${response.statusCode}';
      }
    } catch (e) {
      _error = 'Error fetching dashboard stats: $e';
      if (kDebugMode) {
        print('Error: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Helper method to refresh data with current date
  Future<void> refreshData() async {
    final now = DateTime.now();
    final formattedDate = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    await fetchDashboardStats(date: formattedDate);
  }
}