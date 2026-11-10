import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../data/vehicle_repository.dart';
import '../models/service_vehicle.dart';

enum VehicleSearchStatus { idle, loading, loaded, failure }

class VehicleSearchState {
  final String query;
  final List<ServiceVehicle> vehicles;
  final VehicleSearchStatus status;
  final String? error;

  const VehicleSearchState({
    this.query = '',
    this.vehicles = const [],
    this.status = VehicleSearchStatus.idle,
    this.error,
  });

  VehicleSearchState copyWith({
    String? query,
    List<ServiceVehicle>? vehicles,
    VehicleSearchStatus? status,
    String? error,
    bool clearError = false,
  }) =>
      VehicleSearchState(
        query: query ?? this.query,
        vehicles: vehicles ?? this.vehicles,
        status: status ?? this.status,
        error: clearError ? null : error ?? this.error,
      );
}

sealed class VehicleSearchEvent {}

final class VehicleSearchStarted extends VehicleSearchEvent {
  final String query;

  VehicleSearchStarted(this.query);
}

final class VehicleSearchQueryChanged extends VehicleSearchEvent {
  final String query;

  VehicleSearchQueryChanged(this.query);
}

final class VehicleSearchSubmitted extends VehicleSearchEvent {
  final String query;

  VehicleSearchSubmitted(this.query);
}

final class VehicleSearchRefreshRequested extends VehicleSearchEvent {
  final String query;
  final Completer<void> completer;

  VehicleSearchRefreshRequested(this.query, this.completer);
}

EventTransformer<E> _debounceLatest<E>(Duration duration) =>
    (events, mapper) => events.debounceTime(duration).switchMap(mapper);

class VehicleSearchBloc
    extends Bloc<VehicleSearchEvent, VehicleSearchState> {
  final VehicleRepository repository;

  VehicleSearchBloc(this.repository) : super(const VehicleSearchState()) {
    on<VehicleSearchQueryChanged>(
      (event, emit) => _search(event.query, emit),
      transformer: _debounceLatest(const Duration(milliseconds: 400)),
    );
    on<VehicleSearchStarted>((event, emit) => _search(event.query, emit));
    on<VehicleSearchSubmitted>((event, emit) => _search(event.query, emit));
    on<VehicleSearchRefreshRequested>((event, emit) async {
      try {
        await _search(event.query, emit);
      } finally {
        if (!event.completer.isCompleted) event.completer.complete();
      }
    });
  }

  Future<void> refresh(String query) {
    final completer = Completer<void>();
    add(VehicleSearchRefreshRequested(query, completer));
    return completer.future;
  }

  Future<void> _search(String query, Emitter<VehicleSearchState> emit) async {
    final normalizedQuery = query.trim();
    if (normalizedQuery.isEmpty) {
      emit(
        state.copyWith(
          query: query,
          vehicles: const [],
          status: VehicleSearchStatus.idle,
          clearError: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        query: query,
        status: VehicleSearchStatus.loading,
        clearError: true,
      ),
    );
    try {
      final vehicles = await repository.search(normalizedQuery);
      emit(
        state.copyWith(
          query: query,
          vehicles: vehicles,
          status: VehicleSearchStatus.loaded,
          clearError: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          query: query,
          status: VehicleSearchStatus.failure,
          error: error.toString(),
        ),
      );
    }
  }
}
