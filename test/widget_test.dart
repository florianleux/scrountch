// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:scrountch/main.dart';

void main() {
  testWidgets('App loads home screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ScrountchApp());

    // Verify that the home screen loads with expected buttons
    expect(find.text('TROUVER'), findsOneWidget);
    expect(find.text('RANGER'), findsOneWidget);
    
    // Le bouton IMPORT CSV ne doit pas être visible par défaut
    expect(find.text('IMPORT CSV'), findsNothing);
  });

  testWidgets('CSV import button hidden by default', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ScrountchApp());

    // Vérifier que le bouton CSV n'est pas visible par défaut
    expect(find.text('IMPORT CSV'), findsNothing);
    
    // Vérifier que les autres boutons sont bien présents
    expect(find.text('TROUVER'), findsOneWidget);
    expect(find.text('RANGER'), findsOneWidget);
  });
}
