import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:reimagined_spoon/features/foods/models/food_model.dart';
import 'package:reimagined_spoon/navigation/app_routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<FoodModel> _foods = [];

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
                  final food = await Get.toNamed(AppRoutes.createProduct);

                  if (!mounted || food == null) {
                    return;
                  }

                  setState(() {
                    _foods.add(food);
                  });
                },
                child: Text("Create Product", style: TextStyle(color: Colors.white)),
              ),

              SizedBox(height: 32),
              Expanded(
                child: _foods.isEmpty
                    ? const Center(child: Text('No food has been added yet'))
                    : ListView.builder(
                        itemCount: _foods.length,
                        itemBuilder: (BuildContext context, int index) {
                          final food = _foods[index];

                          return ListTile(
                            title: Text(food.name),
                            subtitle: Text('${food.calories} kcal'),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
