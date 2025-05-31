import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum LanguageStatus { initial, loading, loaded, error }

class LanguageState extends Equatable {
  final Locale locale;
  final LanguageStatus status;
  final String? errorMessage;

  const LanguageState({
    required this.locale,
    this.status = LanguageStatus.initial,
    this.errorMessage,
  });

  factory LanguageState.initial() {
    return const LanguageState(
      locale: Locale('ar'),
      status: LanguageStatus.initial,
    );
  }

  LanguageState copyWith({
    Locale? locale,
    LanguageStatus? status,
    String? errorMessage,
  }) {
    return LanguageState(
      locale: locale ?? this.locale,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  bool get isArabic => locale.languageCode == 'ar';
  bool get isEnglish => locale.languageCode == 'en';

  @override
  List<Object?> get props => [locale, status, errorMessage];
} 