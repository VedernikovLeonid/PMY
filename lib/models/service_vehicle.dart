class ServiceVehicle {
  final int id;
  final int clientId;
  final String clientName;
  final String brand;
  final String model;
  final String licensePlate;
  final String vin;

  const ServiceVehicle({
    required this.id,
    required this.clientId,
    required this.clientName,
    required this.brand,
    required this.model,
    required this.licensePlate,
    required this.vin,
  });

  String get title => '$brand $model';

  bool matches(String query) {
    if (query.isEmpty) return true;
    final searchableText = '$brand $model $licensePlate $vin $clientName'
        .toLowerCase();
    return searchableText.contains(query);
  }
}
