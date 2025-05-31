import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meals_app/core/utils/shared_prefs.dart';
import 'package:meals_app/features/language/cubit/language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  static const String _languageKey = 'language_code';

  LanguageCubit() : super(LanguageState.initial()) {
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    emit(state.copyWith(status: LanguageStatus.loading));
    try {
      final savedLanguage = SharedPrefs.getString(_languageKey, defaultValue: 'ar');
      emit(state.copyWith(
        locale: Locale(savedLanguage),
        status: LanguageStatus.loaded,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: LanguageStatus.error,
        errorMessage: 'Failed to load language: ${e.toString()}',
      ));
    }
  }

  Future<void> changeLanguage(String languageCode) async {
    emit(state.copyWith(status: LanguageStatus.loading));
    try {
      await SharedPrefs.setString(_languageKey, languageCode);
      emit(state.copyWith(
        locale: Locale(languageCode),
        status: LanguageStatus.loaded,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: LanguageStatus.error,
        errorMessage: 'Failed to change language: ${e.toString()}',
      ));
    }
  }

  Future<void> toggleLanguage() async {
    final newLanguage = state.isArabic ? 'en' : 'ar';
    await changeLanguage(newLanguage);
  }
} 