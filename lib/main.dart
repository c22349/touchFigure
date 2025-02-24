import 'package:flutter/material.dart';
import 'package:touchfigure/app_constants.dart';
import 'package:touchfigure/view/falling_action.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppConstants.seedColor),
      ),
      home: const FallingAction(title: AppConstants.appName),
    );
  }
}
