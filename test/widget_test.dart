import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:toko_digital_app/main.dart';

void main() {
  testWidgets('app shows product list screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Daftar Produk'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
}
