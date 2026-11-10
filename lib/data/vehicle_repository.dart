import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/service_vehicle.dart';
import 'vehicle_dto.dart';

abstract interface class VehicleApi {
  Future<List<VehicleDto>> search(String query);
}

class HttpVehicleApi implements VehicleApi {
  final http.Client client;
  final Uri endpoint;

  HttpVehicleApi({http.Client? client, Uri? endpoint})
    : client = client ?? http.Client(),
      endpoint = endpoint ?? _defaultEndpoint;

  static Uri get _defaultEndpoint {
    const configuredBaseUrl = String.fromEnvironment('SERVICE_API_BASE_URL');
    if (configuredBaseUrl.isNotEmpty) {
      return Uri.parse(
        '${configuredBaseUrl.replaceAll(RegExp(r'/+$'), '')}/api/v1/vehicles',
      );
    }

    final host = !kIsWeb && defaultTargetPlatform == TargetPlatform.android
        ? '192.168.1.58'
        : 'localhost';
    return Uri.parse('http://$host:8080/api/v1/vehicles');
  }

  @override
  Future<List<VehicleDto>> search(String query) async {
    final uri = endpoint.replace(queryParameters: {'search': query});
    final response = await client.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Сервер вернул код ${response.statusCode}');
    }

    final json = jsonDecode(response.body) as List<dynamic>;
    return json
        .map((item) => VehicleDto.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}

abstract interface class VehicleRepository {
  Future<List<ServiceVehicle>> search(String query);
}

class RemoteVehicleRepository implements VehicleRepository {
  final VehicleApi api;

  const RemoteVehicleRepository(this.api);

  @override
  Future<List<ServiceVehicle>> search(String query) async {
    final dtos = await api.search(query);
    final normalizedQuery = query.trim().toLowerCase();

    // Проверяем совпадение и на клиенте, чтобы UI всегда получил точный поиск.
    return dtos
        .map((dto) => dto.toModel())
        .where((vehicle) => vehicle.matches(normalizedQuery))
        .toList();
  }
}
