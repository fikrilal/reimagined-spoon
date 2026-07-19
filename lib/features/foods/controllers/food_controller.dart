import 'package:get/get.dart';
import 'package:reimagined_spoon/features/foods/models/food_model.dart';

class FoodController extends GetxController {
  final RxList<FoodModel> foods = <FoodModel>[].obs;

  void addFood(FoodModel food) {
    foods.add(food);
  }
}
