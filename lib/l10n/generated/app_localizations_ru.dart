// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appBarTitle => 'Автосервис «Мотор»';

  @override
  String get ordersHeader => 'Текущие заказ-наряды';

  @override
  String get emptyOrders => 'Заказов пока нет';

  @override
  String ordersLoadError(Object error) {
    return 'Не удалось загрузить заказы: $error';
  }

  @override
  String orderNumber(int number) {
    return 'Заказ №$number';
  }

  @override
  String clientLabel(Object name) {
    return 'Клиент: $name';
  }

  @override
  String carLabel(Object description) {
    return 'Автомобиль: $description';
  }

  @override
  String carDescription(Object brand, Object model, int year, int mileage) {
    return '$brand $model ($year), $mileage км';
  }

  @override
  String statusLabel(Object status) {
    return 'Статус: $status';
  }

  @override
  String get statusAccepted => 'Принят';

  @override
  String get statusInProgress => 'В работе';

  @override
  String get statusReady => 'Готов';

  @override
  String get workTypeMaintenance => 'ТО';

  @override
  String get workTypeRepair => 'Ремонт';

  @override
  String get workTypeDiagnostics => 'Диагностика';

  @override
  String serviceLine(Object type, Object name) {
    return '$type: $name';
  }

  @override
  String totalPrice(Object amount) {
    return 'Итого: $amount';
  }

  @override
  String workTime(int hours) {
    return 'Время работ: $hours ч.';
  }

  @override
  String get close => 'Закрыть';

  @override
  String get like => 'Поставить лайк';

  @override
  String get unlike => 'Убрать лайк';

  @override
  String get favoriteAdded => 'Карточка добавлена в избранное';

  @override
  String get favoriteRemoved => 'Лайк с карточки убран';

  @override
  String get searchHeader => 'Поиск автомобилей в базе автосервиса';

  @override
  String get searchField => 'Параметр поиска';

  @override
  String get searchHint => 'Марка, модель, госномер, VIN или владелец';

  @override
  String get searchButton => 'Найти';

  @override
  String get emptyQuery => 'Введите параметр поиска';

  @override
  String searchError(Object error) {
    return 'Ошибка получения данных: $error';
  }

  @override
  String get noVehicles => 'Автомобили по вашему запросу не найдены';

  @override
  String ownerLabel(Object name) {
    return 'Владелец: $name';
  }

  @override
  String plateLabel(Object plate) {
    return 'Госномер: $plate';
  }

  @override
  String vinLabel(Object vin) {
    return 'VIN: $vin';
  }

  @override
  String get languageMenu => 'Язык';

  @override
  String get russianLanguage => 'Русский';

  @override
  String get englishLanguage => 'English';
}
