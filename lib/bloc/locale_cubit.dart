import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/service_data_repository.dart';

class LocaleCubit extends Cubit<Locale> {
  final ServiceDataRepository repository;

  LocaleCubit(this.repository, {Locale initialLocale = const Locale('ru')})
    : super(initialLocale) {
    _restore();
  }

  Future<void> _restore() async {
    try {
      final savedCode = await repository.loadLanguageCode();
      if (savedCode != null && (savedCode == 'ru' || savedCode == 'en')) {
        emit(Locale(savedCode));
      }
    } catch (_) {
      // Continue with the default Russian locale if storage is unavailable.
    }
  }

  Future<void> setLocale(Locale locale) async {
    await repository.saveLanguageCode(locale.languageCode);
    emit(locale);
  }
}
