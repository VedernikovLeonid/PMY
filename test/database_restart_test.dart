import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:lab_1/data/demo_orders.dart';
import 'package:lab_1/data/service_data_repository.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  test('JSON DTO orders and preferences survive closing and reopening SQLite',
      () async {
    final directory = await Directory.systemTemp.createTemp('motor-db-test-');
    final path = '${directory.path}${Platform.pathSeparator}motor.db';
    final firstDatabase = await openServiceDatabase(path: path);
    final firstRepository = SqliteServiceDataRepository(
      database: firstDatabase,
      seedOrders: createDemoOrders(),
    );

    await firstRepository.loadOrders();
    await firstRepository.setFavorite(1024, true);
    await firstRepository.saveLanguageCode('en');
    await firstDatabase.close();

    final reopenedDatabase = await openServiceDatabase(path: path);
    final reopenedRepository = SqliteServiceDataRepository(
      database: reopenedDatabase,
      seedOrders: const [],
    );
    addTearDown(() async {
      await reopenedDatabase.close();
      await directory.delete(recursive: true);
    });

    final restoredOrders = await reopenedRepository.loadOrders();
    expect(restoredOrders, isNotEmpty);
    expect(restoredOrders.first.number, 1024);
    expect(
      await reopenedRepository.loadFavoriteOrderNumbers(),
      contains(1024),
    );
    expect(await reopenedRepository.loadLanguageCode(), 'en');
  });
}
