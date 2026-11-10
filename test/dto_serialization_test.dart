import 'package:flutter_test/flutter_test.dart';
import 'package:lab_1/data/repair_order_dto.dart';
import 'package:lab_1/models/repair_order.dart';

void main() {
  test('Repair-order DTO serializes to JSON and maps back to the model', () {
    const dto = RepairOrderDto(
      number: 1024,
      clientName: 'Иван Петров',
      car: CarDto(
        brand: 'Toyota',
        model: 'Camry',
        year: 2021,
        mileage: 48500,
        imageUrl: 'https://example.com/camry.png',
      ),
      services: [
        ServiceItemDto(
          name: 'Замена масла',
          type: WorkType.maintenance,
          price: 4500,
          hours: 1,
        ),
      ],
      status: OrderStatus.inProgress,
    );

    final json = dto.toJson();
    expect(json['car'], isA<Map<String, dynamic>>());
    expect((json['car'] as Map<String, dynamic>)['imageUrl'], dto.car.imageUrl);

    final decoded = RepairOrderDto.fromJson(json).toModel();
    expect(decoded.number, dto.number);
    expect(decoded.clientName, dto.clientName);
    expect(decoded.car.imageUrl, dto.car.imageUrl);
    expect(decoded.services.single.name, dto.services.single.name);
    expect(decoded.status, dto.status);
  });
}
