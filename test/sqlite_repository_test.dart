import 'package:flutter_test/flutter_test.dart';
import 'package:lab_1/data/demo_orders.dart';
import 'package:lab_1/data/service_data_repository.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  test(
    'stores order JSON DTOs and persists favorites and locale in SQLite',
    () async {
      final database = await openServiceDatabase(path: inMemoryDatabasePath);
      final repository = SqliteServiceDataRepository(
        database: database,
        seedOrders: createDemoOrders(),
      );

      final orders = await repository.loadOrders();
      expect(orders.map((order) => order.number), [1024, 1025]);
      expect(orders.first.car.imageUrl, contains('213774/1.webp'));

      final storedRows = await database.query('repair_orders');
      expect(storedRows, hasLength(2));
      expect(storedRows.first['payload'], contains('"imageUrl"'));

      await repository.setFavorite(1024, true);
      await repository.saveLanguageCode('en');
      expect(await repository.loadFavoriteOrderNumbers(), {1024});
      expect(await repository.loadLanguageCode(), 'en');

      await database.close();
    },
  );
}
