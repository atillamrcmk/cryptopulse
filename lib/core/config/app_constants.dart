/// Uygulama genelinde kullanılan sabitler
class AppConstants {
  AppConstants._();

  // API Endpoints
  static const String coinGeckoBaseUrl = 'https://api.coingecko.com/api/v3';
  static const String exchangeRateBaseUrl = 'https://open.er-api.com/v6';

  // API Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Popular Crypto IDs (CoinGecko)
  static const List<String> popularCryptoIds = [
    'bitcoin',
    'ethereum',
    'solana',
    'avalanche-2',
    'cardano',
    'polkadot',
    'chainlink',
    'polygon',
    'litecoin',
    'bitcoin-cash',
    'stellar',
    'dogecoin',
    'tron',
    'cosmos',
    'algorand',
  ];

  // Supported Fiat Currencies
  static const List<String> supportedFiatCurrencies = [
    'USD',
    'TRY',
    'EUR',
    'GBP',
    'JPY',
    'CAD',
    'AUD',
    'CHF',
    'CNY',
  ];

  // Default Values
  static const String defaultFiatCurrency = 'TRY';
  static const String defaultLanguage = 'tr';
  static const String defaultTheme = 'dark';

  // Hive Box Names
  static const String favoritesBox = 'favorites';
  static const String portfolioBox = 'portfolio';
  static const String alarmsBox = 'alarms';
  static const String settingsBox = 'settings';

  // Refresh Intervals
  static const Duration cryptoRefreshInterval = Duration(minutes: 1);
  static const Duration fiatRefreshInterval = Duration(minutes: 5);
}
