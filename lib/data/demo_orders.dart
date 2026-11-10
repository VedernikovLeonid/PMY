import '../models/repair_order.dart';

/// Generic catalogue retained from the Dart lab and used to build sample orders.
class ServiceRepository<T extends ServiceItem> {
  final List<T> items;

  ServiceRepository(this.items);

  List<T> findByType(WorkType type) =>
      items.where((item) => item.type == type).toList();
}

List<RepairOrder> createDemoOrders() {
  final catalogue = ServiceRepository<ServiceItem>([
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

  final diagnostics = catalogue.findByType(WorkType.diagnostics);
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
      services: [catalogue.items[0], catalogue.items[2]],
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
