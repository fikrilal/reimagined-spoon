import 'package:get/get.dart';
import 'package:reimagined_spoon/core/database/app_database.dart';
import 'package:reimagined_spoon/features/foods/controllers/food_controller.dart';

class FoodBinding extends Bindings {
  @override
  void dependencies() {
    final database = Get.find<AppDatabase>();

    Get.lazyPut(() => FoodController(database.foodDao));
  }
}
