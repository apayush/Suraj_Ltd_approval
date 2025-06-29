// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

<<<<<<< HEAD
import 'package:suraj_approval/main.dart';
=======
import 'package:suraj_ltd_approval/main.dart';
import 'package:suraj_ltd_approval/suraj_ltd_approval/ui/utills/constants/App_routes.dart';
>>>>>>> f772f8103b5a646c82881509b27274af2a448dea

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
<<<<<<< HEAD
    await tester.pumpWidget(const MyApp());
=======
    await tester.pumpWidget(MyApp(initialRoute: AppRoutes.dashboardScreen,));
>>>>>>> f772f8103b5a646c82881509b27274af2a448dea

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
