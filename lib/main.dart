import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      getPages: AppPages.pages,
      initialRoute: AppRoutes.home,
    );
  }
}
