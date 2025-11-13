import 'package:equatable/equatable.dart';

/// Uygulama ayarları entity
class AppSettings extends Equatable {
  final String theme; // 'dark', 'light', 'system'
  final String language; // 'tr', 'en'
  final String defaultFiatCurrency; // 'TRY', 'USD', 'EUR'

  const AppSettings({
    required this.theme,
    required this.language,
    required this.defaultFiatCurrency,
  });

  AppSettings copyWith({
    String? theme,
    String? language,
    String? defaultFiatCurrency,
  }) {
    return AppSettings(
      theme: theme ?? this.theme,
      language: language ?? this.language,
      defaultFiatCurrency: defaultFiatCurrency ?? this.defaultFiatCurrency,
    );
  }

  @override
  List<Object?> get props => [theme, language, defaultFiatCurrency];
}
