import 'package:json_annotation/json_annotation.dart';

import '../models/repair_order.dart';

part 'repair_order_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class RepairOrderDto {
  final int number;
  final String clientName;
  final CarDto car;
  final List<ServiceItemDto> services;
  final OrderStatus status;

  const RepairOrderDto({
    required this.number,
    required this.clientName,
    required this.car,
    required this.services,
    required this.status,
  });

  factory RepairOrderDto.fromJson(Map<String, dynamic> json) =>
      _$RepairOrderDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RepairOrderDtoToJson(this);

  factory RepairOrderDto.fromModel(RepairOrder order) => RepairOrderDto(
    number: order.number,
    clientName: order.clientName,
    car: CarDto.fromModel(order.car),
    services: order.services.map(ServiceItemDto.fromModel).toList(),
    status: order.status,
  );

  RepairOrder toModel() => RepairOrder(
    number: number,
    clientName: clientName,
    car: car.toModel(),
    services: services.map((service) => service.toModel()).toList(),
    status: status,
  );
}

@JsonSerializable()
class CarDto {
  final String brand;
  final String model;
  final int year;
  final int mileage;
  final String imageUrl;

  const CarDto({
    required this.brand,
    required this.model,
    required this.year,
    required this.mileage,
    required this.imageUrl,
  });

  factory CarDto.fromJson(Map<String, dynamic> json) =>
      _$CarDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CarDtoToJson(this);

  factory CarDto.fromModel(Car car) => CarDto(
    brand: car.brand,
    model: car.model,
    year: car.year,
    mileage: car.mileage,
    imageUrl: car.imageUrl,
  );

  Car toModel() => Car(
    brand: brand,
    model: model,
    year: year,
    mileage: mileage,
    imageUrl: imageUrl,
  );
}

@JsonSerializable()
class ServiceItemDto {
  final String name;
  final WorkType type;
  final double price;
  final int hours;

  const ServiceItemDto({
    required this.name,
    required this.type,
    required this.price,
    required this.hours,
  });

  factory ServiceItemDto.fromJson(Map<String, dynamic> json) =>
      _$ServiceItemDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceItemDtoToJson(this);

  factory ServiceItemDto.fromModel(ServiceItem item) => ServiceItemDto(
    name: item.name,
    type: item.type,
    price: item.price,
    hours: item.hours,
  );

  ServiceItem toModel() => ServiceItem(
    name: name,
    type: type,
    price: price,
    hours: hours,
  );
}
