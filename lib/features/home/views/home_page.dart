import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:reimagined_spoon/navigation/app_routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home Page")),
      body: SafeArea(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => Get.toNamed(AppRoutes.createProduct),
              child: Text("Create Product"),
            ),
          ],
        ),
      ),
    );
  }
}
