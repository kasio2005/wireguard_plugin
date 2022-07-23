import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'ui/home_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BNEGuard',
      theme: ThemeData(fontFamily: 'Montserrat'),
      home: HomeView(),
    );
  }
}
