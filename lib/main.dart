import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/locale_cubit.dart';
import 'bloc/orders_bloc.dart';
import 'bloc/vehicle_search_bloc.dart';
import 'data/demo_orders.dart';
import 'data/service_data_repository.dart';
import 'data/vehicle_repository.dart';
import 'l10n/generated/app_localizations.dart';
import 'ui/service_home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = await openServiceDatabase();
  final dataRepository = SqliteServiceDataRepository(
    database: database,
    seedOrders: createDemoOrders(),
  );
  runApp(
    AutoServiceApp(
      dataRepository: dataRepository,
      vehicleRepository: RemoteVehicleRepository(HttpVehicleApi()),
    ),
  );
}

class AutoServiceApp extends StatelessWidget {
  final ServiceDataRepository dataRepository;
  final VehicleRepository vehicleRepository;
  final String initialSearch;
  final Locale initialLocale;

  const AutoServiceApp({
    required this.dataRepository,
    required this.vehicleRepository,
    this.initialSearch = 'Toyota',
    this.initialLocale = const Locale('ru'),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => LocaleCubit(
            dataRepository,
            initialLocale: initialLocale,
          ),
        ),
        BlocProvider(
          create: (_) => OrdersBloc(dataRepository)..add(OrdersStarted()),
        ),
        BlocProvider(
          create: (_) => VehicleSearchBloc(vehicleRepository)
            ..add(VehicleSearchStarted(initialSearch)),
        ),
      ],
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, locale) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Motor Auto Service',
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
            useMaterial3: true,
          ),
          home: ServiceHomePage(initialSearch: initialSearch),
        ),
      ),
    );
  }
}
