enum OrderStatus { accepted, inProgress, ready }

enum WorkType { maintenance, repair, diagnostics }

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
    for (final service in services) {
      total += service.price;
    }
    return total;
  }

  int get totalHours {
    var hours = 0;
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
