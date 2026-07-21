import 'package:get/get.dart';
import 'package:reimagined_spoon/features/foods/models/food_model.dart';
import '../../../core/database/app_database.dart';
import '../data/local/daos/food_dao.dart';

class FoodController extends GetxController {
  final FoodDao _foodDao;

  FoodController(this._foodDao);

  final RxList<Food> foods = <Food>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadFoods();
  }

  Future<void> addFood(FoodModel food) async {
    final now = DateTime.now().toUtc();

    await _foodDao.insertFood(
      name: food.name,
      caloriesPerServing: food.calories,
      createdAt: now,
      updatedAt: now,
    );

    await loadFoods();
  }

  Future<void> loadFoods() async {
    final foodList = await _foodDao.getActiveFoods();
    foods.assignAll(foodList);
  }
}
