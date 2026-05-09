import 'dart:async';

import 'package:flutter/material.dart';
import '../../providers/preferences_provider.dart';
import 'package:provider/provider.dart';
import '../../screens/home_bottom_navbar.dart';

import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () {
      checkLogin(context);
    });
  }

  void checkLogin(context) async {
    final prefProvider = Provider.of<PreferencesProvider>(context, listen: false);
    prefProvider.checkToken().then((v){
      if(prefProvider.token == null) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false);
      }
      else {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomeBottomNavbar(pageIndex: 0)),
                (route) => false);
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        bottom: true,
        child: SingleChildScrollView(
          child: SizedBox(
            width: size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 220,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: Image.asset(
                    "assets/images/logo1.png",
                    width: 180,
                    color: Theme.of(context).secondaryHeaderColor,
                    colorBlendMode: BlendMode.hue,
                  ),
                ),
                SizedBox(
                  height: 220,
                ),
                Text('Make Order Easily'),
                Text('Effortless Support'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}