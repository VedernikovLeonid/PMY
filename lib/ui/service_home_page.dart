import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../bloc/locale_cubit.dart';
import '../bloc/orders_bloc.dart';
import '../bloc/vehicle_search_bloc.dart';
import '../l10n/generated/app_localizations.dart';
import '../models/repair_order.dart';
import '../models/service_vehicle.dart';

class ServiceHomePage extends StatefulWidget {
  final String initialSearch;

  const ServiceHomePage({this.initialSearch = 'Toyota', super.key});

  @override
  State<ServiceHomePage> createState() => _ServiceHomePageState();
}

class _ServiceHomePageState extends State<ServiceHomePage> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialSearch);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshPage() async {
    await Future.wait([
      context.read<OrdersBloc>().refresh(),
      context.read<VehicleSearchBloc>().refresh(_searchController.text),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appBarTitle),
        actions: [
          PopupMenuButton<Locale>(
            tooltip: l10n.languageMenu,
            icon: const Icon(Icons.language),
            onSelected: (locale) => context.read<LocaleCubit>().setLocale(locale),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: const Locale('ru'),
                child: Text(l10n.russianLanguage),
              ),
              PopupMenuItem(
                value: const Locale('en'),
                child: Text(l10n.englishLanguage),
              ),
            ],
          ),
        ],
      ),
      body: BlocBuilder<OrdersBloc, OrdersState>(
        builder: (context, ordersState) {
          if (ordersState.status == OrdersStatus.loading &&
              ordersState.orders.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: _refreshPage,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  l10n.ordersHeader,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                if (ordersState.error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      l10n.ordersLoadError(ordersState.error!),
                      style: TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                  ),
                if (ordersState.orders.isEmpty &&
                    ordersState.status == OrdersStatus.loaded)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(l10n.emptyOrders),
                  ),
                for (final order in ordersState.orders)
                  _OrderCard(order: order),
                const SizedBox(height: 12),
                _VehicleSearchSection(controller: _searchController),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final RepairOrder order;

  const _OrderCard({required this.order});

  void _toggleFavorite(BuildContext context, bool wasFavorite) {
    context.read<OrdersBloc>().add(FavoriteToggled(order.number));
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(wasFavorite ? l10n.favoriteRemoved : l10n.favoriteAdded),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showDetails(BuildContext context, AppLocalizations l10n) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.orderNumber(order.number)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  order.car.imageUrl,
                  width: 240,
                  height: 160,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 240,
                    height: 160,
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    child: const Icon(Icons.directions_car, size: 56),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(l10n.clientLabel(order.clientName)),
              const SizedBox(height: 8),
              Text(l10n.carLabel(_carDescription(l10n, order.car))),
              const SizedBox(height: 8),
              Text(l10n.statusLabel(_statusTitle(l10n, order.status))),
              const SizedBox(height: 8),
              for (final service in order.services)
                Text(
                  l10n.serviceLine(
                    _workTypeTitle(l10n, service.type),
                    service.name,
                  ),
                ),
              const SizedBox(height: 8),
              Text(l10n.totalPrice(_formatRubles(l10n, order.totalPrice))),
              Text(l10n.workTime(order.totalHours)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<OrdersBloc, OrdersState>(
      builder: (context, state) {
        final isFavorite = state.favoriteOrderNumbers.contains(order.number);
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () => _showDetails(context, l10n),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          order.car.imageUrl,
                          width: 112,
                          height: 96,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                width: 112,
                                height: 96,
                                color: Theme.of(context)
                                    .colorScheme
                                    .surfaceContainerHighest,
                                child: const Icon(Icons.directions_car, size: 42),
                              ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    l10n.orderNumber(order.number),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () =>
                                      _toggleFavorite(context, isFavorite),
                                  tooltip: isFavorite ? l10n.unlike : l10n.like,
                                  icon: Icon(
                                    isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: isFavorite ? Colors.red : null,
                                  ),
                                ),
                              ],
                            ),
                            Chip(
                              label: Text(_statusTitle(l10n, order.status)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(order.clientName),
                  Text(_carDescription(l10n, order.car)),
                  const Divider(),
                  for (final service in order.services)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '${_workTypeTitle(l10n, service.type)}: ${service.name}',
                            ),
                          ),
                          Text(_formatRubles(l10n, service.price)),
                        ],
                      ),
                    ),
                  const SizedBox(height: 8),
                  Text(
                    '${l10n.totalPrice(_formatRubles(l10n, order.totalPrice))} '
                    '• ${l10n.workTime(order.totalHours)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _VehicleSearchSection extends StatelessWidget {
  final TextEditingController controller;

  const _VehicleSearchSection({required this.controller});

  void _submit(BuildContext context) {
    final query = controller.text.trim();
    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.emptyQuery)),
      );
      return;
    }
    context.read<VehicleSearchBloc>().add(VehicleSearchSubmitted(query));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.searchHeader,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                onChanged: (query) => context
                    .read<VehicleSearchBloc>()
                    .add(VehicleSearchQueryChanged(query)),
                onSubmitted: (query) => context
                    .read<VehicleSearchBloc>()
                    .add(VehicleSearchSubmitted(query)),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: l10n.searchField,
                  hintText: l10n.searchHint,
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: () => _submit(context),
              tooltip: l10n.searchButton,
              icon: const Icon(Icons.search),
            ),
          ],
        ),
        const SizedBox(height: 12),
        BlocBuilder<VehicleSearchBloc, VehicleSearchState>(
          builder: (context, state) {
            if (state.status == VehicleSearchStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == VehicleSearchStatus.failure) {
              return Text(l10n.searchError(state.error ?? ''));
            }
            if (state.status == VehicleSearchStatus.loaded &&
                state.vehicles.isEmpty) {
              return Text(l10n.noVehicles);
            }
            return Column(
              children: [
                for (final vehicle in state.vehicles)
                  _VehicleCard(vehicle: vehicle),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _VehicleCard extends StatelessWidget {
  final ServiceVehicle vehicle;

  const _VehicleCard({required this.vehicle});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.directions_car)),
        title: Text(vehicle.title),
        subtitle: Text(
          '${l10n.ownerLabel(vehicle.clientName)}\n'
          '${l10n.plateLabel(vehicle.licensePlate)} • ${l10n.vinLabel(vehicle.vin)}',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

String _carDescription(AppLocalizations l10n, Car car) => l10n.carDescription(
  car.brand,
  car.model,
  car.year,
  car.mileage,
);

String _statusTitle(AppLocalizations l10n, OrderStatus status) => switch (
  status
) {
  OrderStatus.accepted => l10n.statusAccepted,
  OrderStatus.inProgress => l10n.statusInProgress,
  OrderStatus.ready => l10n.statusReady,
};

String _workTypeTitle(AppLocalizations l10n, WorkType type) => switch (type) {
  WorkType.maintenance => l10n.workTypeMaintenance,
  WorkType.repair => l10n.workTypeRepair,
  WorkType.diagnostics => l10n.workTypeDiagnostics,
};

String _formatRubles(AppLocalizations l10n, num amount) =>
    '${NumberFormat.decimalPattern(l10n.localeName).format(amount)} ₽';
