import 'package:flutter/material.dart';

import 'data/spare_part_dto.dart';
import 'data/spare_part_repository.dart';

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
  final SparePartRepository _partsRepository = RemoteSparePartRepository(
    HttpSparePartApi(),
  );
  late Future<List<RepairOrder>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _ordersFuture = _autoService.loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Автосервис «Мотор»'),
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
              const SizedBox(height: 20),
              _PartsSearchSection(repository: _partsRepository),
            ],
          );
        },
      ),
    );
  }
}

class _OrderCard extends StatefulWidget {
  final RepairOrder order;

  const _OrderCard({required this.order});

  @override
  State<_OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<_OrderCard> {
  bool _isLiked = false;

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isLiked
              ? 'Карточка добавлена в избранное'
              : 'Лайк с карточки убран',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showDetails() {
    final order = widget.order;
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Заказ №${order.number}'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Клиент: ${order.clientName}'),
                const SizedBox(height: 8),
                Text('Автомобиль: ${order.car.description}'),
                const SizedBox(height: 8),
                Text('Статус: ${order.statusTitle}'),
                const SizedBox(height: 8),
                for (final service in order.services)
                  Text('• ${service.name} — ${service.price.rubles}'),
                const SizedBox(height: 8),
                Text('Итого: ${order.totalPrice.rubles}'),
                Text('Время работ: ${order.totalHours} ч.'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Закрыть'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: _showDetails,
        borderRadius: BorderRadius.circular(12),
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
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest,
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
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Заказ №${order.number}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: _toggleLike,
                              tooltip: _isLiked
                                  ? 'Убрать лайк'
                                  : 'Поставить лайк',
                              icon: Icon(
                                _isLiked
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: _isLiked ? Colors.red : null,
                              ),
                            ),
                          ],
                        ),
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
                      Expanded(
                        child: Text('${service.type.title}: ${service.name}'),
                      ),
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
      ),
    );
  }
}

class _PartsSearchSection extends StatefulWidget {
  final SparePartRepository repository;

  const _PartsSearchSection({required this.repository});

  @override
  State<_PartsSearchSection> createState() => _PartsSearchSectionState();
}

class _PartsSearchSectionState extends State<_PartsSearchSection> {
  final TextEditingController _searchController = TextEditingController(
    text: 'car',
  );
  late Future<List<SparePartDto>> _partsFuture;

  @override
  void initState() {
    super.initState();
    _partsFuture = widget.repository.search(_searchController.text);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _searchParts() {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введите параметр поиска')),
      );
      return;
    }

    setState(() {
      _partsFuture = widget.repository.search(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Поиск деталей на сервере',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                onSubmitted: (_) => _searchParts(),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Параметр поиска',
                  hintText: 'Например, car',
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: _searchParts,
              tooltip: 'Найти',
              icon: const Icon(Icons.search),
            ),
          ],
        ),
        const SizedBox(height: 12),
        FutureBuilder<List<SparePartDto>>(
          future: _partsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Text('Ошибка получения данных: ${snapshot.error}');
            }

            final parts = snapshot.data ?? <SparePartDto>[];
            if (parts.isEmpty) {
              return const Text('По вашему запросу детали не найдены');
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: parts.length,
              itemBuilder: (context, index) {
                return _SparePartCard(part: parts[index]);
              },
            );
          },
        ),
      ],
    );
  }
}

class _SparePartCard extends StatelessWidget {
  final SparePartDto part;

  const _SparePartCard({required this.part});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.network(
          part.imageUrl,
          width: 56,
          height: 56,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.build_circle, size: 40);
          },
        ),
        title: Text(part.title),
        subtitle: Text(
          part.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text('${part.price.toStringAsFixed(0)} $'),
      ),
    );
  }
}
