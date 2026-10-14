import 'dart:convert';

import 'package:http/http.dart' as http;

import 'spare_part_dto.dart';

/// Интерфейс API: реализацию можно заменить на backend из интернет-лабораторных.
abstract interface class SparePartApi {
  Future<List<SparePartDto>> search(String query);
}

class HttpSparePartApi implements SparePartApi {
  final http.Client client;
  final Uri endpoint;

  HttpSparePartApi({
    http.Client? client,
    Uri? endpoint,
  })  : client = client ?? http.Client(),
        endpoint = endpoint ??
            Uri.parse('https://dummyjson.com/products/search');

  @override
  Future<List<SparePartDto>> search(String query) async {
    final uri = endpoint.replace(queryParameters: {'q': query, 'limit': '8'});
    final response = await client.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Сервер вернул код ${response.statusCode}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final products = json['products'] as List<dynamic>? ?? <dynamic>[];

    return products
        .map((item) => SparePartDto.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}

/// Репозиторий отделяет экран приложения от деталей HTTP-запроса.
abstract interface class SparePartRepository {
  Future<List<SparePartDto>> search(String query);
}

class RemoteSparePartRepository implements SparePartRepository {
  final SparePartApi api;

  const RemoteSparePartRepository(this.api);

  @override
  Future<List<SparePartDto>> search(String query) {
    return api.search(query);
  }
}
