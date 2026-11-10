import 'dart:convert';

import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../models/repair_order.dart';
import 'repair_order_dto.dart';

abstract interface class ServiceDataRepository {
  Future<List<RepairOrder>> loadOrders();
  Future<Set<int>> loadFavoriteOrderNumbers();
  Future<void> setFavorite(int orderNumber, bool isFavorite);
  Future<String?> loadLanguageCode();
  Future<void> saveLanguageCode(String languageCode);
}

Future<Database> openServiceDatabase({String? path}) async {
  final databasePath = path ?? p.join(await getDatabasesPath(), 'motor.db');
  return openDatabase(
    databasePath,
    version: 1,
    onCreate: (database, version) async {
      await database.execute('''
        CREATE TABLE repair_orders (
          number INTEGER PRIMARY KEY,
          payload TEXT NOT NULL
        )
      ''');
      await database.execute('''
        CREATE TABLE favorite_orders (
          order_number INTEGER PRIMARY KEY
        )
      ''');
      await database.execute('''
        CREATE TABLE app_settings (
          setting_key TEXT PRIMARY KEY,
          setting_value TEXT NOT NULL
        )
      ''');
    },
  );
}

/// SQLite repository. Orders are stored as JSON DTO payloads; favorites and
/// the selected language have their own relational tables.
class SqliteServiceDataRepository implements ServiceDataRepository {
  final Database database;
  final List<RepairOrder> seedOrders;

  const SqliteServiceDataRepository({
    required this.database,
    required this.seedOrders,
  });

  @override
  Future<List<RepairOrder>> loadOrders() async {
    var rows = await database.query('repair_orders', orderBy: 'number ASC');
    if (rows.isEmpty && seedOrders.isNotEmpty) {
      final batch = database.batch();
      for (final order in seedOrders) {
        final dto = RepairOrderDto.fromModel(order);
        batch.insert('repair_orders', {
          'number': order.number,
          'payload': jsonEncode(dto.toJson()),
        });
      }
      await batch.commit(noResult: true);
      rows = await database.query('repair_orders', orderBy: 'number ASC');
    }

    return rows.map((row) {
      final payload = jsonDecode(row['payload']! as String);
      final json = Map<String, dynamic>.from(payload as Map);
      return RepairOrderDto.fromJson(json).toModel();
    }).toList();
  }

  @override
  Future<Set<int>> loadFavoriteOrderNumbers() async {
    final rows = await database.query('favorite_orders');
    return rows.map((row) => row['order_number']! as int).toSet();
  }

  @override
  Future<void> setFavorite(int orderNumber, bool isFavorite) async {
    if (isFavorite) {
      await database.insert(
        'favorite_orders',
        {'order_number': orderNumber},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } else {
      await database.delete(
        'favorite_orders',
        where: 'order_number = ?',
        whereArgs: [orderNumber],
      );
    }
  }

  @override
  Future<String?> loadLanguageCode() async {
    final rows = await database.query(
      'app_settings',
      columns: ['setting_value'],
      where: 'setting_key = ?',
      whereArgs: ['language'],
      limit: 1,
    );
    return rows.isEmpty ? null : rows.first['setting_value'] as String?;
  }

  @override
  Future<void> saveLanguageCode(String languageCode) async {
    await database.insert(
      'app_settings',
      {'setting_key': 'language', 'setting_value': languageCode},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
