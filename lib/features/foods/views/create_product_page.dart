import 'package:flutter/material.dart';
import 'package:reimagined_spoon/core/design_system/design_system.dart';
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
      appBar: AppBar(title: const Text('Create Food')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.space16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppTextField(
                  controller: productNameCont,
                  labelText: 'Food name',
                  hintText: 'e.g., Apple',
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  validator: (String? value) {
                    final input = value?.trim();

                    if (input == null || input.isEmpty) {
                      return 'Please enter the food name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.space16),
                AppTextField(
                  controller: caloriesCont,
                  labelText: 'Calories per serving',
                  hintText: 'e.g., 300',
                  suffixText: 'kcal',
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
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textInputAction: TextInputAction.done,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.space16),
          child: AppButton.primary(
            text: 'Create Food',
            isExpanded: true,
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
            },
          ),
        ),
      ),
    );
  }
}
