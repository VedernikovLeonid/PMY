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

    await tester.tap(find.byIcon(Icons.favorite_border).first);
    await tester.pump();
    expect(find.byIcon(Icons.favorite), findsOneWidget);
    expect(find.text('Карточка добавлена в избранное'), findsOneWidget);

    await tester.tap(find.text('Заказ №1024'));
    await tester.pump();
    expect(find.text('Клиент: Иван Петров'), findsOneWidget);
  });
}
