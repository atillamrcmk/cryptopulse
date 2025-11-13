import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/repositories_provider.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/crypto_coin.dart';
import '../../domain/entities/price_chart_data.dart';

/// Popüler coin'leri getiren provider
/// Cache ile rate limit'i azaltmak için keepAlive kullanıyoruz
final popularCoinsProvider = FutureProvider<List<CryptoCoin>>((ref) async {
  final repository = ref.watch(cryptoRepositoryProvider);
  final result = await repository.getPopularCoins(
    vsCurrencies: ['usd', 'try', 'eur'],
  );

  return result.when(
    success: (coins) => coins,
    failure: (message, _) {
      // Rate limit hatası için daha açıklayıcı mesaj
      if (message.contains('429') ||
          message.contains('Rate limit') ||
          message.contains('rate limit') ||
          message.contains('limit aşıldı')) {
        throw Exception(
          'API limit aşıldı. Lütfen birkaç dakika sonra tekrar deneyin.',
        );
      }
      throw Exception(message);
    },
  );
}, dependencies: [cryptoRepositoryProvider]);

/// Coin detay provider (parametreli)
final coinDetailProvider = FutureProvider.family<CryptoCoin, String>((
  ref,
  coinId,
) async {
  try {
    final repository = ref.watch(cryptoRepositoryProvider);
    final result = await repository.getCoinDetail(
      coinId,
      vsCurrencies: ['usd', 'try', 'eur'],
    );

    return result.when(
      success: (coin) => coin,
      failure: (message, error) {
        // Rate limit veya diğer hatalar için daha açıklayıcı mesaj
        if (message.contains('429') ||
            message.contains('Rate limit') ||
            message.contains('rate limit')) {
          throw Exception(
            'API limit aşıldı. Lütfen birkaç dakika sonra tekrar deneyin.',
          );
        }
        throw Exception(message);
      },
    );
  } catch (e) {
    rethrow;
  }
});

/// Coin arama için provider
final coinSearchProvider = StateProvider<String>((ref) => '');

/// Filtrelenmiş coin listesi
final filteredCoinsProvider = Provider<List<CryptoCoin>>((ref) {
  final coins = ref.watch(popularCoinsProvider).value ?? [];
  final searchQuery = ref.watch(coinSearchProvider);

  if (searchQuery.isEmpty) {
    return coins;
  }

  final query = searchQuery.toLowerCase();
  return coins.where((coin) {
    return coin.name.toLowerCase().contains(query) ||
        coin.symbol.toLowerCase().contains(query);
  }).toList();
});

/// Coin grafik verisi provider (parametreli: coinId, days, vsCurrency)
/// Cache ile rate limit'i azaltmak için keepAlive kullanıyoruz
final coinChartProvider = FutureProvider.family<PriceChartData, ChartParams>((
  ref,
  params,
) async {
  try {
    final repository = ref.watch(cryptoRepositoryProvider);
    final result = await repository.getCoinChart(
      params.coinId,
      days: params.days,
      vsCurrency: params.vsCurrency,
    );

    return result.when(
      success: (chartData) => chartData,
      failure: (message, error) {
        if (message.contains('429') ||
            message.contains('Rate limit') ||
            message.contains('rate limit') ||
            message.contains('limit aşıldı')) {
          throw Exception(
            'CoinGecko API limit aşıldı.\n\n'
            'Ücretsiz API planı dakikada sınırlı istek yapabilir.\n'
            'Lütfen 1-2 dakika bekleyip tekrar deneyin.\n\n'
            'Alternatif: Farklı bir coin seçin veya daha sonra tekrar deneyin.',
          );
        }
        throw Exception(message);
      },
    );
  } catch (e) {
    rethrow;
  }
}, dependencies: [cryptoRepositoryProvider]);

/// Grafik parametreleri
class ChartParams {
  final String coinId;
  final int days;
  final String vsCurrency;

  ChartParams({required this.coinId, this.days = 7, this.vsCurrency = 'usd'});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChartParams &&
          runtimeType == other.runtimeType &&
          coinId == other.coinId &&
          days == other.days &&
          vsCurrency == other.vsCurrency;

  @override
  int get hashCode => coinId.hashCode ^ days.hashCode ^ vsCurrency.hashCode;
}
