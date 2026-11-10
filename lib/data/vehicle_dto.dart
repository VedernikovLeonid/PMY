import 'package:json_annotation/json_annotation.dart';

import '../models/service_vehicle.dart';

part 'vehicle_dto.g.dart';

@JsonSerializable()
class VehicleDto {
  final int id;
  final int clientId;
  final String clientName;
  final String brand;
  final String model;
  final String licensePlate;
  final String vin;

  const VehicleDto({
    required this.id,
    required this.clientId,
    required this.clientName,
    required this.brand,
    required this.model,
    required this.licensePlate,
    required this.vin,
  });

  factory VehicleDto.fromJson(Map<String, dynamic> json) =>
      _$VehicleDtoFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleDtoToJson(this);

  ServiceVehicle toModel() => ServiceVehicle(
    id: id,
    clientId: clientId,
    clientName: clientName,
    brand: brand,
    model: model,
    licensePlate: licensePlate,
    vin: vin,
  );
}
