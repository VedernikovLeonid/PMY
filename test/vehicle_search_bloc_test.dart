import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab_1/bloc/vehicle_search_bloc.dart';
import 'package:lab_1/data/vehicle_repository.dart';
import 'package:lab_1/models/service_vehicle.dart';

void main() {
  late _CountingVehicleRepository repository;

  setUp(() => repository = _CountingVehicleRepository());

  blocTest<VehicleSearchBloc, VehicleSearchState>(
    'debounces rapid query edits and searches only the final query',
    build: () => VehicleSearchBloc(repository),
    act: (bloc) {
      bloc.add(VehicleSearchQueryChanged('T'));
      bloc.add(VehicleSearchQueryChanged('To'));
      bloc.add(VehicleSearchQueryChanged('Toyota'));
    },
    wait: const Duration(milliseconds: 500),
    expect: () => [
      isA<VehicleSearchState>()
          .having((state) => state.status, 'status', VehicleSearchStatus.loading)
          .having((state) => state.query, 'query', 'Toyota'),
      isA<VehicleSearchState>()
          .having((state) => state.status, 'status', VehicleSearchStatus.loaded)
          .having((state) => state.vehicles, 'vehicles', isEmpty),
    ],
    verify: (_) => expect(repository.queries, ['Toyota']),
  );
}

class _CountingVehicleRepository implements VehicleRepository {
  final List<String> queries = [];

  @override
  Future<List<ServiceVehicle>> search(String query) async {
    queries.add(query);
    return const [];
  }
}
