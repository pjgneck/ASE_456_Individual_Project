// test/main_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:mcd_inventory/main.dart';      // <-- update with your app package
import 'package:mcd_inventory/core/app_state.dart';
import 'package:mcd_inventory/pages/login.dart';

void main() {
  testWidgets('App launches and builds MaterialApp', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AppState(),
        child: const MyApp(),
      ),
    );

    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('LoginScreen is displayed first', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AppState(),
        child: const MyApp(),
      ),
    );

    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('Provider<AppState> is available in widget tree',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AppState(),
        child: const MyApp(),
      ),
    );

    final context = tester.element(find.byType(LoginScreen));
    final appState = Provider.of<AppState>(context, listen: false);

    expect(appState, isA<AppState>());
  });

  testWidgets('App has correct title', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AppState(),
        child: const MyApp(),
      ),
    );

    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.title, equals('McDonalds Inventory'));
  });
}
