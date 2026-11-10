import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
  ];

  /// No description provided for @appBarTitle.
  ///
  /// In ru, this message translates to:
  /// **'Автосервис «Мотор»'**
  String get appBarTitle;

  /// No description provided for @ordersHeader.
  ///
  /// In ru, this message translates to:
  /// **'Текущие заказ-наряды'**
  String get ordersHeader;

  /// No description provided for @emptyOrders.
  ///
  /// In ru, this message translates to:
  /// **'Заказов пока нет'**
  String get emptyOrders;

  /// No description provided for @ordersLoadError.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось загрузить заказы: {error}'**
  String ordersLoadError(Object error);

  /// No description provided for @orderNumber.
  ///
  /// In ru, this message translates to:
  /// **'Заказ №{number}'**
  String orderNumber(int number);

  /// No description provided for @clientLabel.
  ///
  /// In ru, this message translates to:
  /// **'Клиент: {name}'**
  String clientLabel(Object name);

  /// No description provided for @carLabel.
  ///
  /// In ru, this message translates to:
  /// **'Автомобиль: {description}'**
  String carLabel(Object description);

  /// No description provided for @carDescription.
  ///
  /// In ru, this message translates to:
  /// **'{brand} {model} ({year}), {mileage} км'**
  String carDescription(Object brand, Object model, int year, int mileage);

  /// No description provided for @statusLabel.
  ///
  /// In ru, this message translates to:
  /// **'Статус: {status}'**
  String statusLabel(Object status);

  /// No description provided for @statusAccepted.
  ///
  /// In ru, this message translates to:
  /// **'Принят'**
  String get statusAccepted;

  /// No description provided for @statusInProgress.
  ///
  /// In ru, this message translates to:
  /// **'В работе'**
  String get statusInProgress;

  /// No description provided for @statusReady.
  ///
  /// In ru, this message translates to:
  /// **'Готов'**
  String get statusReady;

  /// No description provided for @workTypeMaintenance.
  ///
  /// In ru, this message translates to:
  /// **'ТО'**
  String get workTypeMaintenance;

  /// No description provided for @workTypeRepair.
  ///
  /// In ru, this message translates to:
  /// **'Ремонт'**
  String get workTypeRepair;

  /// No description provided for @workTypeDiagnostics.
  ///
  /// In ru, this message translates to:
  /// **'Диагностика'**
  String get workTypeDiagnostics;

  /// No description provided for @serviceLine.
  ///
  /// In ru, this message translates to:
  /// **'{type}: {name}'**
  String serviceLine(Object type, Object name);

  /// No description provided for @totalPrice.
  ///
  /// In ru, this message translates to:
  /// **'Итого: {amount}'**
  String totalPrice(Object amount);

  /// No description provided for @workTime.
  ///
  /// In ru, this message translates to:
  /// **'Время работ: {hours} ч.'**
  String workTime(int hours);

  /// No description provided for @close.
  ///
  /// In ru, this message translates to:
  /// **'Закрыть'**
  String get close;

  /// No description provided for @like.
  ///
  /// In ru, this message translates to:
  /// **'Поставить лайк'**
  String get like;

  /// No description provided for @unlike.
  ///
  /// In ru, this message translates to:
  /// **'Убрать лайк'**
  String get unlike;

  /// No description provided for @favoriteAdded.
  ///
  /// In ru, this message translates to:
  /// **'Карточка добавлена в избранное'**
  String get favoriteAdded;

  /// No description provided for @favoriteRemoved.
  ///
  /// In ru, this message translates to:
  /// **'Лайк с карточки убран'**
  String get favoriteRemoved;

  /// No description provided for @searchHeader.
  ///
  /// In ru, this message translates to:
  /// **'Поиск автомобилей в базе автосервиса'**
  String get searchHeader;

  /// No description provided for @searchField.
  ///
  /// In ru, this message translates to:
  /// **'Параметр поиска'**
  String get searchField;

  /// No description provided for @searchHint.
  ///
  /// In ru, this message translates to:
  /// **'Марка, модель, госномер, VIN или владелец'**
  String get searchHint;

  /// No description provided for @searchButton.
  ///
  /// In ru, this message translates to:
  /// **'Найти'**
  String get searchButton;

  /// No description provided for @emptyQuery.
  ///
  /// In ru, this message translates to:
  /// **'Введите параметр поиска'**
  String get emptyQuery;

  /// No description provided for @searchError.
  ///
  /// In ru, this message translates to:
  /// **'Ошибка получения данных: {error}'**
  String searchError(Object error);

  /// No description provided for @noVehicles.
  ///
  /// In ru, this message translates to:
  /// **'Автомобили по вашему запросу не найдены'**
  String get noVehicles;

  /// No description provided for @ownerLabel.
  ///
  /// In ru, this message translates to:
  /// **'Владелец: {name}'**
  String ownerLabel(Object name);

  /// No description provided for @plateLabel.
  ///
  /// In ru, this message translates to:
  /// **'Госномер: {plate}'**
  String plateLabel(Object plate);

  /// No description provided for @vinLabel.
  ///
  /// In ru, this message translates to:
  /// **'VIN: {vin}'**
  String vinLabel(Object vin);

  /// No description provided for @languageMenu.
  ///
  /// In ru, this message translates to:
  /// **'Язык'**
  String get languageMenu;

  /// No description provided for @russianLanguage.
  ///
  /// In ru, this message translates to:
  /// **'Русский'**
  String get russianLanguage;

  /// No description provided for @englishLanguage.
  ///
  /// In ru, this message translates to:
  /// **'English'**
  String get englishLanguage;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
