import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reimagined_spoon/core/design_system/design_system.dart';
import 'package:reimagined_spoon/navigation/app_pages.dart';
import 'package:reimagined_spoon/navigation/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Nutrition Tracker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      getPages: AppPages.pages,
      initialRoute: AppRoutes.home,
    );
  }
}
