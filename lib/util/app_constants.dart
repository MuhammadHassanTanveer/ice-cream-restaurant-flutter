import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AppConstants {
  static const String appName = 'Restaurant App';

  static const String fontFamily = 'Roboto';

  static const String baseUrl = 'http://192.168.100.170:8000/api';
  static const String imageUrl = 'http://192.168.100.170:8000/';

  static const double maxLimitOfFileSentINConversation = 25;
  static const double maxLimitOfTotalFileSent = 5;
  static const double maxSizeOfASingleFile = 10;
  static const double maxImageSend = 10;

  // Helper method to construct full image URLs
  static String getImageUrl(String imagePath) {
    if (imagePath.startsWith('http')) {
      return imagePath;
    }
    return '$imageUrl$imagePath';
  }
}

void showToast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      fontSize: 12);
}
_launchURL(String url) async {
  if (await canLaunchUrlString(url)) {
    await launchUrlString(url, mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not launch $url';
  }
}