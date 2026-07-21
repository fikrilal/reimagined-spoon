import 'dart:async';
import 'package:get/get.dart';
import 'package:reimagined_spoon/core/database/app_database.dart';

class DatabaseStatusController extends GetxController {
  DatabaseStatusController(this._database);

  final AppDatabase _database;
  final RxnString upgradedMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    unawaited(_loadUpgradeStatus());
  }

  Future<void> _loadUpgradeStatus() async {
    await _database.customSelect('SELECT 1').getSingle();

    final details = _database.lastOpeningDetails;

    if (details == null || !details.hadUpgrade) {
      return;
    }

    upgradedMessage.value = 'Database upgraded successfully: v${details.versionBefore} -> v${details.versionNow}';
  }

  void dismissUpgradeMessage() {
    upgradedMessage.value = null;
  }
}