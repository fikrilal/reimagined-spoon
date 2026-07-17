import 'package:get/get.dart';
import 'package:reimagined_spoon/features/foods/views/create_product_page.dart';
import 'package:reimagined_spoon/features/home/views/home_page.dart';

import 'app_routes.dart';

abstract class AppPages {
  static final List<GetPage> pages = [
    GetPage(name: AppRoutes.home, page: () => const HomePage()),
    GetPage(name: AppRoutes.createProduct, page: () => CreateProductPage()),
  ];
}
