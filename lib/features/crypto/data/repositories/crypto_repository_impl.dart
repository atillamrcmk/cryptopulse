import '../../../../core/utils/result.dart';
import '../../domain/entities/crypto_coin.dart';
import '../../domain/entities/price_chart_data.dart';
import '../../domain/repositories/crypto_repository.dart';
import '../datasources/crypto_remote_datasource.dart';

/// Kripto para repository implementasyonu
class CryptoRepositoryImpl implements CryptoRepository {
  final CryptoRemoteDataSource _remoteDataSource;

  CryptoRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<CryptoCoin>>> getPopularCoins({
    List<String>? vsCurrencies,
  }) async {
    final result = await _remoteDataSource.getPopularCoins(
      vsCurrencies: vsCurrencies,
    );

    return await result.whenAsync(
      success: (models) async {
        // Fiyatları çoklu para birimi için çek
        final coinIds = models.map((e) => e.id).toList();
        final pricesResult = await _remoteDataSource.getCoinsPrices(
          coinIds,
          vsCurrencies: vsCurrencies,
        );

        final coins = models.map((model) {
          final prices = pricesResult.when(
            success: (pricesMap) => pricesMap[model.id],
            failure: (_, __) => null,
          );
          return model.toEntity(prices: prices);
        }).toList();

        return Success<List<CryptoCoin>>(coins);
      },
      failure: (message, error) async =>
          Failure<List<CryptoCoin>>(message, error),
    );
  }

  @override
  Future<Result<List<CryptoCoin>>> getAllCoins() async {
    final result = await _remoteDataSource.getAllCoinsList();

    return result.when(
      success: (data) {
        final coins = data.map((json) {
          return CryptoCoin(
            id: json['id'] as String,
            name: json['name'] as String,
            symbol: json['symbol'] as String,
          );
        }).toList();
        return Success(coins);
      },
      failure: (message, error) => Failure(message, error),
    );
  }

  @override
  Future<Result<CryptoCoin>> getCoinDetail(
    String coinId, {
    List<String>? vsCurrencies,
  }) async {
    final result = await _remoteDataSource.getCoinDetail(coinId);

    return await result.whenAsync(
      success: (model) async {
        // Çoklu para birimi fiyatlarını çek
        final pricesResult = await _remoteDataSource.getCoinsPrices([
          coinId,
        ], vsCurrencies: vsCurrencies);

        final prices = pricesResult.when(
          success: (pricesMap) => pricesMap[coinId],
          failure: (_, __) => null,
        );

        return Success<CryptoCoin>(model.toEntity(prices: prices));
      },
      failure: (message, error) async => Failure<CryptoCoin>(message, error),
    );
  }

  @override
  Future<Result<Map<String, CryptoCoin>>> getCoinsPrices(
    List<String> coinIds, {
    List<String>? vsCurrencies,
  }) async {
    final result = await _remoteDataSource.getCoinsPrices(
      coinIds,
      vsCurrencies: vsCurrencies,
    );

    return result.when(
      success: (pricesMap) {
        // Burada sadece fiyat bilgisi var, tam coin bilgisi için
        // getPopularCoins veya getCoinDetail kullanılmalı
        // Şimdilik basit bir mapping yapıyoruz
        final coinsMap = <String, CryptoCoin>{};
        for (final coinId in coinIds) {
          final prices = pricesMap[coinId];
          if (prices != null) {
            coinsMap[coinId] = CryptoCoin(
              id: coinId,
              name: coinId,
              symbol: coinId.toUpperCase(),
              prices: prices,
              currentPrice: prices['usd'],
            );
          }
        }
        return Success(coinsMap);
      },
      failure: (message, error) => Failure(message, error),
    );
  }

  @override
  Future<Result<PriceChartData>> getCoinChart(
    String coinId, {
    int days = 7,
    String vsCurrency = 'usd',
  }) async {
    final result = await _remoteDataSource.getCoinChart(
      coinId,
      days: days,
      vsCurrency: vsCurrency,
    );

    return result.when(
      success: (model) => Success(model.toEntity()),
      failure: (message, error) => Failure(message, error),
    );
  }
}
