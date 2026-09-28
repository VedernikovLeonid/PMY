import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lab_1/main.dart';

void main() {
  testWidgets('Автосервис показывает заказ-наряды после загрузки',
      (WidgetTester tester) async {
    await tester.pumpWidget(const AutoServiceApp());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 800));

    expect(find.text('Автосервис «Мотор»'), findsOneWidget);
    expect(find.text('Заказ №1024'), findsOneWidget);
    expect(find.text('Заказ №1025'), findsOneWidget);
    expect(find.byType(Image), findsNWidgets(2));
  });
}
