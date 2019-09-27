import 'package:agile_market/ui/checkout_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main(){
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(MaterialApp(
    theme: ThemeData(
      primaryColor: Color(0xFF17202A)
    ),
    home: Checkout(),
    debugShowCheckedModeBanner: false,
  ));
}