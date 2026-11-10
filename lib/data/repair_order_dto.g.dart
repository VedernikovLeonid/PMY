// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repair_order_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RepairOrderDto _$RepairOrderDtoFromJson(Map<String, dynamic> json) =>
    RepairOrderDto(
      number: (json['number'] as num).toInt(),
      clientName: json['clientName'] as String,
      car: CarDto.fromJson(json['car'] as Map<String, dynamic>),
      services: (json['services'] as List<dynamic>)
          .map((e) => ServiceItemDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: $enumDecode(_$OrderStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$RepairOrderDtoToJson(RepairOrderDto instance) =>
    <String, dynamic>{
      'number': instance.number,
      'clientName': instance.clientName,
      'car': instance.car.toJson(),
      'services': instance.services.map((e) => e.toJson()).toList(),
      'status': _$OrderStatusEnumMap[instance.status]!,
    };

const _$OrderStatusEnumMap = {
  OrderStatus.accepted: 'accepted',
  OrderStatus.inProgress: 'inProgress',
  OrderStatus.ready: 'ready',
};

CarDto _$CarDtoFromJson(Map<String, dynamic> json) => CarDto(
  brand: json['brand'] as String,
  model: json['model'] as String,
  year: (json['year'] as num).toInt(),
  mileage: (json['mileage'] as num).toInt(),
  imageUrl: json['imageUrl'] as String,
);

Map<String, dynamic> _$CarDtoToJson(CarDto instance) => <String, dynamic>{
  'brand': instance.brand,
  'model': instance.model,
  'year': instance.year,
  'mileage': instance.mileage,
  'imageUrl': instance.imageUrl,
};

ServiceItemDto _$ServiceItemDtoFromJson(Map<String, dynamic> json) =>
    ServiceItemDto(
      name: json['name'] as String,
      type: $enumDecode(_$WorkTypeEnumMap, json['type']),
      price: (json['price'] as num).toDouble(),
      hours: (json['hours'] as num).toInt(),
    );

Map<String, dynamic> _$ServiceItemDtoToJson(ServiceItemDto instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': _$WorkTypeEnumMap[instance.type]!,
      'price': instance.price,
      'hours': instance.hours,
    };

const _$WorkTypeEnumMap = {
  WorkType.maintenance: 'maintenance',
  WorkType.repair: 'repair',
  WorkType.diagnostics: 'diagnostics',
};
