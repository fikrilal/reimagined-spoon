import 'package:get/get.dart';
import 'package:reimagined_spoon/core/database/app_database.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AppDatabase(), permanent: true);
  }
}
