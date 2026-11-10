import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab_1/data/demo_orders.dart';
import 'package:lab_1/data/service_data_repository.dart';
import 'package:lab_1/data/vehicle_repository.dart';
import 'package:lab_1/main.dart';
import 'package:lab_1/models/repair_order.dart';
import 'package:lab_1/models/service_vehicle.dart';

void main() {
  testWidgets('orders, favorite, and order details render', (
    tester,
  ) async {
    final repository = _MemoryServiceDataRepository(createDemoOrders());

    await tester.pumpWidget(
      AutoServiceApp(
        dataRepository: repository,
        vehicleRepository: _EmptyVehicleRepository(),
        initialLocale: const Locale('ru'),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 10));

    expect(find.text('Автосервис «Мотор»'), findsOneWidget);
    expect(find.text('Заказ №1024'), findsOneWidget);
    expect(find.text('Заказ №1025'), findsOneWidget);
    expect(find.byIcon(Icons.favorite_border), findsNWidgets(2));

    await tester.tap(find.byIcon(Icons.favorite_border).first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 10));
    expect(find.byIcon(Icons.favorite), findsOneWidget);
    expect(find.text('Карточка добавлена в избранное'), findsOneWidget);
    expect(repository.favorites, contains(1024));

    await tester.tap(find.text('Заказ №1024'));
    await tester.pump();
    expect(find.text('Клиент: Иван Петров'), findsOneWidget);
    expect(find.byType(Image), findsNWidgets(3));

  });
}

class _MemoryServiceDataRepository implements ServiceDataRepository {
  _MemoryServiceDataRepository(this.orders);

  final List<RepairOrder> orders;
  final Set<int> favorites = {};
  String? languageCode;

  @override
  Future<List<RepairOrder>> loadOrders() async => orders;

  @override
  Future<Set<int>> loadFavoriteOrderNumbers() async => {...favorites};

  @override
  Future<void> setFavorite(int orderNumber, bool isFavorite) async {
    if (isFavorite) {
      favorites.add(orderNumber);
    } else {
      favorites.remove(orderNumber);
    }
  }

  @override
  Future<String?> loadLanguageCode() async => languageCode;

  @override
  Future<void> saveLanguageCode(String languageCode) async {
    this.languageCode = languageCode;
  }
}

class _EmptyVehicleRepository implements VehicleRepository {
  @override
  Future<List<ServiceVehicle>> search(String query) async => const [];
}
