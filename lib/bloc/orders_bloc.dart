import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/service_data_repository.dart';
import '../models/repair_order.dart';

enum OrdersStatus { initial, loading, loaded, failure }

class OrdersState {
  final OrdersStatus status;
  final List<RepairOrder> orders;
  final Set<int> favoriteOrderNumbers;
  final String? error;
  final bool refreshing;

  const OrdersState({
    this.status = OrdersStatus.initial,
    this.orders = const [],
    this.favoriteOrderNumbers = const {},
    this.error,
    this.refreshing = false,
  });

  OrdersState copyWith({
    OrdersStatus? status,
    List<RepairOrder>? orders,
    Set<int>? favoriteOrderNumbers,
    String? error,
    bool clearError = false,
    bool? refreshing,
  }) =>
      OrdersState(
        status: status ?? this.status,
        orders: orders ?? this.orders,
        favoriteOrderNumbers:
            favoriteOrderNumbers ?? this.favoriteOrderNumbers,
        error: clearError ? null : error ?? this.error,
        refreshing: refreshing ?? this.refreshing,
      );
}

sealed class OrdersEvent {}

final class OrdersStarted extends OrdersEvent {}

final class OrdersRefreshRequested extends OrdersEvent {
  final Completer<void> completer;

  OrdersRefreshRequested(this.completer);
}

final class FavoriteToggled extends OrdersEvent {
  final int orderNumber;

  FavoriteToggled(this.orderNumber);
}

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final ServiceDataRepository repository;

  OrdersBloc(this.repository) : super(const OrdersState()) {
    on<OrdersStarted>((event, emit) => _load(emit));
    on<OrdersRefreshRequested>((event, emit) async {
      try {
        await _load(emit, refreshing: true);
      } finally {
        if (!event.completer.isCompleted) event.completer.complete();
      }
    });
    on<FavoriteToggled>((event, emit) async {
      final isFavorite =
          !state.favoriteOrderNumbers.contains(event.orderNumber);
      try {
        await repository.setFavorite(event.orderNumber, isFavorite);
        final favorites = await repository.loadFavoriteOrderNumbers();
        emit(state.copyWith(favoriteOrderNumbers: favorites));
      } catch (error) {
        emit(state.copyWith(error: error.toString()));
      }
    });
  }

  Future<void> refresh() {
    final completer = Completer<void>();
    add(OrdersRefreshRequested(completer));
    return completer.future;
  }

  Future<void> _load(
    Emitter<OrdersState> emit, {
    bool refreshing = false,
  }) async {
    emit(
      state.copyWith(
        status: state.orders.isEmpty ? OrdersStatus.loading : state.status,
        refreshing: refreshing,
        clearError: true,
      ),
    );
    try {
      final results = await Future.wait([
        repository.loadOrders(),
        repository.loadFavoriteOrderNumbers(),
      ]);
      emit(
        state.copyWith(
          status: OrdersStatus.loaded,
          orders: results[0] as List<RepairOrder>,
          favoriteOrderNumbers: results[1] as Set<int>,
          refreshing: false,
          clearError: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: state.orders.isEmpty ? OrdersStatus.failure : state.status,
          error: error.toString(),
          refreshing: false,
        ),
      );
    }
  }
}
