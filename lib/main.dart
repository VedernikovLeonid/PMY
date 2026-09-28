import 'package:flutter/material.dart';

void main() {
  runApp(const AutoServiceApp());
}

/// Этап выполнения заказа-наряда.
enum OrderStatus { accepted, inProgress, ready }

/// Вид работы, которую выполняет автосервис.
enum WorkType { maintenance, repair, diagnostics }

extension WorkTypeTitle on WorkType {
  String get title {
    switch (this) {
      case WorkType.maintenance:
        return 'ТО';
      case WorkType.repair:
        return 'Ремонт';
      case WorkType.diagnostics:
        return 'Диагностика';
    }
  }
}

extension MoneyFormat on num {
  String get rubles => '${toStringAsFixed(0)} ₽';
}

class Car {
  final String brand;
  final String model;
  final int year;
  final int mileage;
  final String imageUrl;

  const Car({
    required this.brand,
    required this.model,
    required this.year,
    required this.mileage,
    required this.imageUrl,
  });

  String get description => '$brand $model ($year), $mileage км';
}

class ServiceItem {
  final String name;
  final WorkType type;
  final double price;
  final int hours;

  const ServiceItem({
    required this.name,
    required this.type,
    required this.price,
    required this.hours,
  });
}

class RepairOrder {
  final int number;
  final String clientName;
  final Car car;
  final List<ServiceItem> services;
  OrderStatus status;

  RepairOrder({
    required this.number,
    required this.clientName,
    required this.car,
    required this.services,
    required this.status,
  });

  double get totalPrice {
    var total = 0.0;

    // Цикл for используется для расчёта стоимости всех работ.
    for (final service in services) {
      total += service.price;
    }
    return total;
  }

  int get totalHours {
    var hours = 0;

    // Второй цикл: суммируем длительность работ.
    for (final service in services) {
      hours += service.hours;
    }
    return hours;
  }

  String get statusTitle {
    switch (status) {
      case OrderStatus.accepted:
        return 'Принят';
      case OrderStatus.inProgress:
        return 'В работе';
      case OrderStatus.ready:
        return 'Готов';
    }
  }
}

/// Обобщённое хранилище: его можно использовать для любых элементов услуг.
class ServiceRepository<T extends ServiceItem> {
  final List<T> items;

  ServiceRepository(this.items);

  List<T> findByType(WorkType type) {
    return items.where((item) => item.type == type).toList();
  }
}

class AutoService {
  // Future моделирует загрузку заказов из базы данных или API.
  Future<List<RepairOrder>> loadOrders() async {
    await Future<void>.delayed(const Duration(milliseconds: 700));

    final catalog = ServiceRepository<ServiceItem>([
      const ServiceItem(
        name: 'Замена масла и фильтра',
        type: WorkType.maintenance,
        price: 4500,
        hours: 1,
      ),
      const ServiceItem(
        name: 'Диагностика ходовой части',
        type: WorkType.diagnostics,
        price: 1800,
        hours: 1,
      ),
      const ServiceItem(
        name: 'Замена передних колодок',
        type: WorkType.repair,
        price: 6200,
        hours: 2,
      ),
      const ServiceItem(
        name: 'Компьютерная диагностика',
        type: WorkType.diagnostics,
        price: 2500,
        hours: 1,
      ),
    ]);

    // Использование generic-метода репозитория.
    final diagnostics = catalog.findByType(WorkType.diagnostics);

    return [
      RepairOrder(
        number: 1024,
        clientName: 'Иван Петров',
        car: const Car(
          brand: 'Toyota',
          model: 'Camry',
          year: 2021,
          mileage: 48500,
          imageUrl:
              'https://storage.yandexcloud.net/iat-ninearts/origin/models/213774/1.webp',
        ),
        services: [catalog.items[0], catalog.items[2]],
        status: OrderStatus.inProgress,
      ),
      RepairOrder(
        number: 1025,
        clientName: 'Анна Соколова',
        car: const Car(
          brand: 'Kia',
          model: 'Rio',
          year: 2019,
          mileage: 72100,
          imageUrl:
              'https://krasnoyarsk.ruautoshop.com/auto/images/00000005999f60ad66f2.png',
        ),
        services: [diagnostics.first],
        status: OrderStatus.accepted,
      ),
    ];
  }
}

class AutoServiceApp extends StatelessWidget {
  const AutoServiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Автосервис',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const ServiceHomePage(),
    );
  }
}

class ServiceHomePage extends StatefulWidget {
  const ServiceHomePage({super.key});

  @override
  State<ServiceHomePage> createState() => _ServiceHomePageState();
}

class _ServiceHomePageState extends State<ServiceHomePage> {
  final AutoService _autoService = AutoService();
  late Future<List<RepairOrder>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _ordersFuture = _autoService.loadOrders();
  }

  void _reloadOrders() {
    setState(() {
      _ordersFuture = _autoService.loadOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Автосервис «Мотор»'),
        actions: [
          IconButton(
            onPressed: _reloadOrders,
            tooltip: 'Обновить заказы',
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder<List<RepairOrder>>(
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Ошибка загрузки: ${snapshot.error}'));
          }

          final orders = snapshot.data ?? <RepairOrder>[];
          if (orders.isEmpty) {
            return const Center(child: Text('Заказов пока нет'));
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _SummaryCard(orders: orders),
              const SizedBox(height: 16),
              const Text(
                'Текущие заказ-наряды',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              // Anonymous function itemBuilder создаёт карточку для каждого заказа.
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  return _OrderCard(order: orders[index]);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final List<RepairOrder> orders;

  const _SummaryCard({required this.orders});

  @override
  Widget build(BuildContext context) {
    final total = orders.fold<double>(
      0,
      // Anonymous function: fold собирает общую стоимость заказов.
      (sum, order) => sum + order.totalPrice,
    );
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Заказов в работе'),
            Text(
              '${orders.length}  •  ${total.rubles}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final RepairOrder order;

  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    order.car.imageUrl,
                    width: 112,
                    height: 96,
                    fit: BoxFit.cover,
                    // Локальная заглушка сохраняет внешний вид карточки без сети.
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 112,
                        height: 96,
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        child: const Icon(Icons.directions_car, size: 42),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Заказ №${order.number}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Chip(label: Text(order.statusTitle)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(order.clientName),
            Text(order.car.description),
            const Divider(),
            // Цикл for создаёт строки с перечнем работ.
            for (final service in order.services)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text('${service.type.title}: ${service.name}')),
                    Text(service.price.rubles),
                  ],
                ),
              ),
            const SizedBox(height: 8),
            Text(
              'Итого: ${order.totalPrice.rubles} • ${order.totalHours} ч.',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
