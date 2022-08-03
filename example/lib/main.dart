import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:get/get.dart';
import 'package:wireguard_plugin/wireguard_plugin.dart';
import 'ui/home_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  startVpnService();
  runApp(MyApp());
}

void startVpnService() async {
  final androidConfig = FlutterBackgroundAndroidConfig(
    notificationTitle: "BNEGuard",
    notificationText: "Background service to app alive",
    notificationImportance: AndroidNotificationImportance.Default,
    notificationIcon: AndroidResource(
        name: 'background_icon',
        defType: 'drawable'), // Default is ic_launcher from folder mipmap
  );
  bool hasPermissions = await FlutterBackground.hasPermissions;
  bool? success = hasPermissions
      ? await FlutterBackground.initialize(androidConfig: androidConfig)
      : null;
  await WireguardPlugin.requestPermission();
  await WireguardPlugin.initialize();
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
