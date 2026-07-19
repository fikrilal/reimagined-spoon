import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:reimagined_spoon/features/foods/controllers/food_controller.dart';
import 'package:reimagined_spoon/features/foods/models/food_model.dart';
import 'package:reimagined_spoon/navigation/app_routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final foodController = Get.find<FoodController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home Page")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              ElevatedButton(
                style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.blue)),
                onPressed: () async {
                  final food = await Get.toNamed(
                    AppRoutes.createProduct,
                  );

                  if (!mounted || food is! FoodModel) {
                    return;
                  }

                  foodController.addFood(food);
                },
                child: Text("Create Product", style: TextStyle(color: Colors.white)),
              ),

              SizedBox(height: 32),
              Expanded(
                child: Obx(() {
                  final foods = foodController.foods;

                  if (foods.isEmpty) {
                    return const Center(child: Text('No food has been added yet'));
                  }

                  return ListView.builder(
                    itemCount: foods.length,
                    itemBuilder: (BuildContext context, int index) {
                      final food = foods[index];

                      return ListTile(
                        title: Text(food.name),
                        subtitle: Text('${food.calories} kcal'),
                      );
                    },
                  );
                })
              ),
            ],
          ),
        ),
      ),
    );
  }
}
