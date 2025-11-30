import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:mcd_inventory/core/app_state.dart';
import 'package:mcd_inventory/core/models/store.dart';
import 'package:mcd_inventory/core/models/user.dart';
import 'package:mcd_inventory/pages/homepage.dart';

void main() {
  Widget createHomeScreen(AppState appState) {
    return ChangeNotifierProvider<AppState>.value(
      value: appState,
      child: MaterialApp(home: HomeScreen()),
    );
  }

  testWidgets('HomeScreen shows welcome and store info', (tester) async {
    final appState = AppState();

    // Add a valid user
    final user = User(
      id: 'u1',
      email: 'manager@mcdon.com',
      username: 'Manager',
      storeId: '1',
      role: 'Manager',
      raw: {
        'id': 'u1',
        'email': 'manager@mcdon.com',
        'username': 'Manager',
        'store': '1',
        'role': 'Manager',
      },
    );
    appState.setUser(user);

    // Add a store
    final store = Store(
      id: '1',
      name: 'Test Store',
      location: 'Test Location',
      raw: {'id': '1', 'name': 'Test Store', 'location': 'Test Location'},
    );
    appState.setStores([store]);
    appState.setSelectedStore(store);

    await tester.pumpWidget(createHomeScreen(appState));
    await tester.pumpAndSettle();

    expect(find.text('Welcome, Manager!'), findsOneWidget);
    expect(find.text('Test Store'), findsOneWidget);
    expect(find.text('Test Location'), findsOneWidget);
  });
}
