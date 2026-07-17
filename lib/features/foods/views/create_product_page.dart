import 'package:flutter/material.dart';
import 'package:reimagined_spoon/features/foods/models/food_model.dart';
import 'package:get/get.dart';

class CreateProductPage extends StatefulWidget {
  const CreateProductPage({super.key});

  @override
  State<CreateProductPage> createState() => _CreateProductPageState();
}

class _CreateProductPageState extends State<CreateProductPage> {
  final TextEditingController productNameCont = TextEditingController();
  final TextEditingController caloriesCont = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    productNameCont.dispose();
    caloriesCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Product Page")),
      body: SafeArea(
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: productNameCont,
                    decoration: InputDecoration(hintText: "eg;, Apple", labelText: "Product Name"),
                    validator: (String? value) {
                      final input = value?.trim();

                      if (input == null || input.isEmpty) {
                        return "Please enter the product name";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: caloriesCont,
                    decoration: InputDecoration(hintText: "eg;, 300", labelText: "Calories"),
                    validator: (String? value) {
                      final input = value?.trim() ?? '';

                      if (input.isEmpty) {
                        return "Please enter the calories";
                      }

                      final calories = double.tryParse(input);

                      if (calories == null || !calories.isFinite) {
                        return 'Calories must be a valid number';
                      }

                      if (calories < 0) {
                        return 'Calories cannot be negative';
                      }

                      return null;
                    },
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                final isValid = _formKey.currentState?.validate() ?? false;

                if (!isValid) {
                  return;
                }

                final food = FoodModel(
                  name: productNameCont.text.trim(),
                  calories: double.parse(caloriesCont.text.trim()),
                );

                Get.back(result: food);

                // ScaffoldMessenger.of(context).showSnackBar(
                //   SnackBar(content: Text("Product created successfully!")),
                // );
              },
              child: Text("Create Product"),
            ),
          ],
        ),
      ),
    );
  }
}
