// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appBarTitle => 'Motor Auto Service';

  @override
  String get ordersHeader => 'Current repair orders';

  @override
  String get emptyOrders => 'There are no orders yet';

  @override
  String ordersLoadError(Object error) {
    return 'Could not load orders: $error';
  }

  @override
  String orderNumber(int number) {
    return 'Order #$number';
  }

  @override
  String clientLabel(Object name) {
    return 'Client: $name';
  }

  @override
  String carLabel(Object description) {
    return 'Vehicle: $description';
  }

  @override
  String carDescription(Object brand, Object model, int year, int mileage) {
    return '$brand $model ($year), $mileage km';
  }

  @override
  String statusLabel(Object status) {
    return 'Status: $status';
  }

  @override
  String get statusAccepted => 'Accepted';

  @override
  String get statusInProgress => 'In progress';

  @override
  String get statusReady => 'Ready';

  @override
  String get workTypeMaintenance => 'Maintenance';

  @override
  String get workTypeRepair => 'Repair';

  @override
  String get workTypeDiagnostics => 'Diagnostics';

  @override
  String serviceLine(Object type, Object name) {
    return '$type: $name';
  }

  @override
  String totalPrice(Object amount) {
    return 'Total: $amount';
  }

  @override
  String workTime(int hours) {
    return 'Work time: $hours h';
  }

  @override
  String get close => 'Close';

  @override
  String get like => 'Add to favorites';

  @override
  String get unlike => 'Remove from favorites';

  @override
  String get favoriteAdded => 'Card added to favorites';

  @override
  String get favoriteRemoved => 'Card removed from favorites';

  @override
  String get searchHeader => 'Search vehicles in the service database';

  @override
  String get searchField => 'Search query';

  @override
  String get searchHint => 'Make, model, plate, VIN, or owner';

  @override
  String get searchButton => 'Search';

  @override
  String get emptyQuery => 'Enter a search query';

  @override
  String searchError(Object error) {
    return 'Could not retrieve data: $error';
  }

  @override
  String get noVehicles => 'No vehicles match your query';

  @override
  String ownerLabel(Object name) {
    return 'Owner: $name';
  }

  @override
  String plateLabel(Object plate) {
    return 'Plate: $plate';
  }

  @override
  String vinLabel(Object vin) {
    return 'VIN: $vin';
  }

  @override
  String get languageMenu => 'Language';

  @override
  String get russianLanguage => 'Русский';

  @override
  String get englishLanguage => 'English';
}
