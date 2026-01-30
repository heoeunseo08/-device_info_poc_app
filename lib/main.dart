import 'package:device_info_poc_app/providers/device_info_provider.dart';
import 'package:device_info_poc_app/screens/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ValueListenableBuilder(
      valueListenable: appProvider.updateCount,
      builder: (context, value, child) {
        return MaterialApp(home: HomeScreen());
      },
    ),
  );
}
