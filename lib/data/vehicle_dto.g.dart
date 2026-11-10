// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehicleDto _$VehicleDtoFromJson(Map<String, dynamic> json) => VehicleDto(
  id: (json['id'] as num).toInt(),
  clientId: (json['clientId'] as num).toInt(),
  clientName: json['clientName'] as String,
  brand: json['brand'] as String,
  model: json['model'] as String,
  licensePlate: json['licensePlate'] as String,
  vin: json['vin'] as String,
);

Map<String, dynamic> _$VehicleDtoToJson(VehicleDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'clientId': instance.clientId,
      'clientName': instance.clientName,
      'brand': instance.brand,
      'model': instance.model,
      'licensePlate': instance.licensePlate,
      'vin': instance.vin,
    };
