import 'package:get/get.dart';
import 'package:reimagined_spoon/core/database/app_database.dart';

import '../controllers/database_status_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    final database = Get.put(AppDatabase(), permanent: true);
    Get.put(DatabaseStatusController(database), permanent: true);
  }
}
