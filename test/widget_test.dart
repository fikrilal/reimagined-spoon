import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:reimagined_spoon/main.dart';

void main() {
  setUp(() {
    Get.testMode = true;
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('shows the food empty state and opens the create form', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Foods'), findsOneWidget);
    expect(find.text('No food yet'), findsOneWidget);
    expect(find.text('Create Food'), findsOneWidget);

    await tester.tap(find.text('Create Food'));
    await tester.pumpAndSettle();

    expect(find.text('Food name'), findsOneWidget);
    expect(find.text('Calories per serving'), findsOneWidget);
  });
}
