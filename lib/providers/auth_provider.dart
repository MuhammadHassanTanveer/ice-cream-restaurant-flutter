import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'package:restaurant_flutter_app/screens/home_bottom_navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/widgets/snack_bar_widget.dart';
import '../models/auth_model.dart';
import '../util/api_config_service.dart';

class AuthProvider with ChangeNotifier {

  AuthModel? authModel;
  String? userToken;

  bool isLoading = false;
  loadingApi(value){
    isLoading = value;
    notifyListeners();
  }

  Future<void> loginUser(context, email, password) async {
    final baseUrl = await ApiConfigService.getBaseUrl();
    final String apiUrl = '$baseUrl/login';
    final Map<String, dynamic> body = {
      "email": email,
      "password": password,
    };

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Accept' : 'application/json',
          'Content-Type' : 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        debugPrint('login api is working ${response.body}');
        authModel = authModelFromJson(response.body);
        await prefs.setString('token', authModel!.success.token);
        await prefs.setInt('id', authModel!.success.user.id);
        showCustomSnackBar(context, "Login Successfully " , isError: false);
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=> HomeBottomNavbar(pageIndex: 0)), (route) => false);
        isLoading = false;
        notifyListeners();
      }else if( response.statusCode == 401){
        debugPrint('login api is working ${response.body}');
        var resp = jsonDecode(response.body); // Decode the JSON string to a Map
        var message = resp['message'];        // Access the message from the Map
        showCustomSnackBar(context, message);
      }else if( response.statusCode == 403) {
        debugPrint('login api is working ${response.body}');
        var resp = jsonDecode(response.body); // Decode the JSON string to a Map
        var message = resp['message'];        // Access the message from the Map
        showCustomSnackBar(context, message);
      }

    } catch (error) {
      isLoading = false;
      notifyListeners();
      debugPrint('login api is not working error $error');
      rethrow;
    }
    isLoading = false;
    notifyListeners();
  }
}