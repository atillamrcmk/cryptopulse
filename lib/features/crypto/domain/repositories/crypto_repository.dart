import '../entities/crypto_coin.dart';
import '../entities/price_chart_data.dart';
import '../../../../core/utils/result.dart';

/// Kripto para repository interface (domain katmanı)
abstract class CryptoRepository {
  /// Popüler kripto paraları getir
  Future<Result<List<CryptoCoin>>> getPopularCoins({
    List<String>? vsCurrencies,
  });

  /// Tüm coin listesini getir
  Future<Result<List<CryptoCoin>>> getAllCoins();

  /// Belirli bir coin'in detayını getir
  Future<Result<CryptoCoin>> getCoinDetail(
    String coinId, {
    List<String>? vsCurrencies,
  });

  /// Birden fazla coin'in fiyatlarını getir
  Future<Result<Map<String, CryptoCoin>>> getCoinsPrices(
    List<String> coinIds, {
    List<String>? vsCurrencies,
  });

  /// Coin'in grafik verisini getir
  Future<Result<PriceChartData>> getCoinChart(
    String coinId, {
    int days = 7,
    String vsCurrency = 'usd',
  });
}
