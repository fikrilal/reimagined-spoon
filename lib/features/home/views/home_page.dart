import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:reimagined_spoon/core/design_system/design_system.dart';
import 'package:reimagined_spoon/features/foods/controllers/food_controller.dart';
import 'package:reimagined_spoon/features/foods/models/food_model.dart';
import 'package:reimagined_spoon/navigation/app_routes.dart';
import '../../../core/controllers/database_status_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final foodController = Get.find<FoodController>();
  final databaseStatusController = Get.find<DatabaseStatusController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Foods')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.space16),
          child: Column(
            children: [
              if (kDebugMode)
                Obx(() {
                  final message = databaseStatusController.upgradedMessage.value;

                  if (message == null) {
                    return const SizedBox.shrink();
                  }

                  return Padding(
                    padding: const EdgeInsetsGeometry.only(bottom: AppSpacing.space16),
                    child: MaterialBanner(
                      content: Text(message),
                      actions: [
                        TextButton(
                          onPressed: databaseStatusController.dismissUpgradeMessage,
                          child: Text('Dismiss'),
                        ),
                      ],
                    ),
                  );
                }),

              AppButton.primary(
                text: 'Create Food',
                icon: const Icon(Icons.add),
                isExpanded: true,
                onPressed: () async {
                  final food = await Get.toNamed(AppRoutes.createProduct);

                  if (!mounted || food is! FoodModel) {
                    return;
                  }

                  await foodController.addFood(food);
                },
              ),

              const SizedBox(height: AppSpacing.space24),
              Expanded(
                child: Obx(() {
                  final foods = foodController.foods;

                  if (foods.isEmpty) {
                    return const AppEmptyState(
                      title: 'No food yet',
                      description: 'Create your first food to start tracking nutrition.',
                      icon: Icons.restaurant_outlined,
                    );
                  }

                  return ListView.separated(
                    itemCount: foods.length,
                    separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.space8),
                    itemBuilder: (BuildContext context, int index) {
                      final food = foods[index];

                      return AppListTile(
                        title: food.name,
                        subtitle: '${food.caloriesPerServing} kcal per ${food.servingLabel}',
                        leading: const Icon(Icons.local_dining_outlined),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
