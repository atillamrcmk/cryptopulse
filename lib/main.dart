import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/config/app_theme.dart';
import 'core/config/app_constants.dart';
import 'features/splash/presentation/pages/splash_screen.dart';
import 'features/portfolio/data/models/portfolio_item_model.dart';
import 'features/settings/data/models/favorite_coin_model.dart';
import 'features/settings/data/models/price_alarm_model.dart';
import 'features/settings/presentation/providers/settings_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive initialization
  await Hive.initFlutter();

  // Register Hive adapters
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(PortfolioItemModelAdapter());
  }
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(FavoriteCoinModelAdapter());
  }
  if (!Hive.isAdapterRegistered(2)) {
    Hive.registerAdapter(PriceAlarmModelAdapter());
  }

  // Open Hive boxes
  await Hive.openBox<PortfolioItemModel>(AppConstants.portfolioBox);
  await Hive.openBox<FavoriteCoinModel>(AppConstants.favoritesBox);
  await Hive.openBox<PriceAlarmModel>(AppConstants.alarmsBox);

  runApp(const ProviderScope(child: CryptoPulseApp()));
}

class CryptoPulseApp extends ConsumerWidget {
  const CryptoPulseApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    // Tema modunu ayarla
    ThemeMode themeMode;
    switch (settings.theme) {
      case 'light':
        themeMode = ThemeMode.light;
        break;
      case 'dark':
        themeMode = ThemeMode.dark;
        break;
      case 'system':
        themeMode = ThemeMode.system;
        break;
      default:
        themeMode = ThemeMode.dark;
    }

    return MaterialApp(
      title: 'CryptoPulse',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: const SplashScreen(),
    );
  }
}
