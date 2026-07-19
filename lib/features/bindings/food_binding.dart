import 'package:get/get.dart';
import 'package:reimagined_spoon/features/foods/controllers/food_controller.dart';

class FoodBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(() => FoodController());
  }
}