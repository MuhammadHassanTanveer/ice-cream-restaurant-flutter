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
    _error = null;
    notifyListeners();

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userId = prefs.getInt('id');
      var userToken = prefs.getString('token');

      debugPrint('=== Dashboard API Debug ===');
      debugPrint('User ID: $userId');
      debugPrint('User Token: ${userToken?.substring(0, 20)}...');
      debugPrint('Requested Date: $date');

      final url = Uri.parse('${AppConstants.baseUrl}/orders/stats/daily?date=$date&user_id=$userId');
      debugPrint('API URL: $url');

      final headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $userToken'
      };

      final response = await http.get(url, headers: headers);

      debugPrint('Response Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        debugPrint("Dashboard stats fetched successfully");
        dashboardStats = dashboardModelFromJson(response.body);
        _error = null;
      } else if (response.statusCode == 401) {
        _error = 'Unauthorized: Please login again';
        debugPrint('Error: Unauthorized access - 401');
      } else if (response.statusCode == 404) {
        _error = 'No data found for this date';
        debugPrint('Error: No data found - 404');
      } else {
        _error = 'Failed to load dashboard stats: ${response.statusCode}';
        debugPrint('Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e, stackTrace) {
      _error = 'Error fetching dashboard stats: $e';
      debugPrint('=== Dashboard API Error ===');
      debugPrint('Error: $e');
      debugPrint('Stack Trace: $stackTrace');
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