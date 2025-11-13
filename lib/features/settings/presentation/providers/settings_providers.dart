import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/config/app_constants.dart';
import '../../domain/entities/app_settings.dart';
import '../../data/models/favorite_coin_model.dart';
import '../../data/models/price_alarm_model.dart';

/// Settings provider
final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>(
  (ref) => SettingsNotifier(),
);

class SettingsNotifier extends StateNotifier<AppSettings> {
  SettingsNotifier()
    : super(
        const AppSettings(
          theme: AppConstants.defaultTheme,
          language: AppConstants.defaultLanguage,
          defaultFiatCurrency: AppConstants.defaultFiatCurrency,
        ),
      ) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    state = AppSettings(
      theme: prefs.getString('theme') ?? AppConstants.defaultTheme,
      language: prefs.getString('language') ?? AppConstants.defaultLanguage,
      defaultFiatCurrency:
          prefs.getString('defaultFiatCurrency') ??
          AppConstants.defaultFiatCurrency,
    );
  }

  Future<void> updateTheme(String theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', theme);
    state = state.copyWith(theme: theme);
  }

  Future<void> updateLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', language);
    state = state.copyWith(language: language);
  }

  Future<void> updateDefaultFiatCurrency(String currency) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('defaultFiatCurrency', currency);
    state = state.copyWith(defaultFiatCurrency: currency);
  }
}

/// Favorites box provider
final favoritesBoxProvider = FutureProvider<Box<FavoriteCoinModel>>((
  ref,
) async {
  if (!Hive.isBoxOpen(AppConstants.favoritesBox)) {
    await Hive.openBox<FavoriteCoinModel>(AppConstants.favoritesBox);
  }
  return Hive.box<FavoriteCoinModel>(AppConstants.favoritesBox);
});

/// Favorites provider
final favoritesProvider = FutureProvider<List<String>>((ref) async {
  final box = await ref.watch(favoritesBoxProvider.future);
  return box.values.map((model) => model.coinId).toList();
});

/// Alarms box provider
final alarmsBoxProvider = FutureProvider<Box<PriceAlarmModel>>((ref) async {
  if (!Hive.isBoxOpen(AppConstants.alarmsBox)) {
    await Hive.openBox<PriceAlarmModel>(AppConstants.alarmsBox);
  }
  return Hive.box<PriceAlarmModel>(AppConstants.alarmsBox);
});

/// Alarms provider
final alarmsProvider = FutureProvider<List<PriceAlarmModel>>((ref) async {
  final box = await ref.watch(alarmsBoxProvider.future);
  return box.values.cast<PriceAlarmModel>().toList();
});
