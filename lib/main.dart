import 'package:agile_market/ui/checkout_page.dart';
import 'package:agile_market/ui/login_page.dart';
import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(MaterialApp(
    theme: ThemeData(primaryColor: Color(0xFF17202A)),
    home:
      SplashScreen.navigate(
      name: "assets/shopping-cart.flr",
      next: Login_Page(),
      until: () => Future.delayed(Duration(seconds: 1)),
      startAnimation: 'Untitled',
      backgroundColor: Colors.white,
      width: 120,
      height: 120,
    ),
    debugShowCheckedModeBanner: false,
  ));
}
