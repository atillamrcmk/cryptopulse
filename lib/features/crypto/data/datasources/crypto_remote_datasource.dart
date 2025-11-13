import 'package:dio/dio.dart';
import '../../../../core/config/app_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/result.dart';
import '../models/crypto_coin_model.dart';
import '../models/price_chart_data_model.dart';

/// Kripto para remote data source (API çağrıları)
class CryptoRemoteDataSource {
  final Dio _dio;

  CryptoRemoteDataSource() : _dio = DioClient.instance;

  /// Popüler coin'leri getir (markets endpoint)
  Future<Result<List<CryptoCoinModel>>> getPopularCoins({
    List<String>? vsCurrencies,
  }) async {
    try {
      final response = await _dio.get(
        '${AppConstants.coinGeckoBaseUrl}/coins/markets',
        queryParameters: {
          'vs_currency': 'usd',
          'ids': AppConstants.popularCryptoIds.join(','),
          'order': 'market_cap_desc',
          'per_page': 50,
          'page': 1,
          'sparkline': false,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final coins = data
            .map((json) => CryptoCoinModel.fromJson(json))
            .toList();
        return Success(coins);
      } else {
        return const Failure('Veri alınamadı');
      }
    } catch (e) {
      return Failure(
        e is DioException
            ? (e.error?.toString() ?? 'Bilinmeyen hata')
            : 'Bilinmeyen hata',
        e,
      );
    }
  }

  /// Tüm coin listesini getir
  Future<Result<List<Map<String, dynamic>>>> getAllCoinsList() async {
    try {
      final response = await _dio.get(
        '${AppConstants.coinGeckoBaseUrl}/coins/list',
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return Success(data.cast<Map<String, dynamic>>());
      } else {
        return const Failure('Veri alınamadı');
      }
    } catch (e) {
      return Failure(
        e is DioException
            ? (e.error?.toString() ?? 'Bilinmeyen hata')
            : 'Bilinmeyen hata',
        e,
      );
    }
  }

  /// Belirli coin'lerin fiyatlarını getir (simple/price endpoint)
  Future<Result<Map<String, Map<String, double>>>> getCoinsPrices(
    List<String> coinIds, {
    List<String>? vsCurrencies,
  }) async {
    try {
      final currencies = vsCurrencies?.join(',') ?? 'usd,try,eur';

      final response = await _dio.get(
        '${AppConstants.coinGeckoBaseUrl}/simple/price',
        queryParameters: {
          'ids': coinIds.join(','),
          'vs_currencies': currencies,
          'include_24hr_change': true,
          'include_market_cap': true,
          'include_24hr_vol': true,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        final pricesMap = <String, Map<String, double>>{};

        data.forEach((coinId, coinData) {
          final prices = <String, double>{};
          coinData.forEach((key, value) {
            if (value is num) {
              prices[key] = value.toDouble();
            }
          });
          pricesMap[coinId] = prices;
        });

        return Success(pricesMap);
      } else {
        return const Failure('Fiyat verisi alınamadı');
      }
    } catch (e) {
      return Failure(
        e is DioException
            ? (e.error?.toString() ?? 'Bilinmeyen hata')
            : 'Bilinmeyen hata',
        e,
      );
    }
  }

  /// Coin detayını getir
  Future<Result<CryptoCoinModel>> getCoinDetail(String coinId) async {
    try {
      final response = await _dio.get(
        '${AppConstants.coinGeckoBaseUrl}/coins/$coinId',
        queryParameters: {
          'localization': false,
          'tickers': false,
          'market_data': true,
          'community_data': false,
          'developer_data': false,
          'sparkline': false,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final marketData = data['market_data'] as Map<String, dynamic>?;
        final imageData = data['image'] as Map<String, dynamic>?;

        // CoinGecko coins/{id} endpoint'i farklı yapıda döndürüyor
        // market_data içinde nested yapılar var
        final currentPriceMap =
            marketData?['current_price'] as Map<String, dynamic>?;
        final marketCapMap = marketData?['market_cap'] as Map<String, dynamic>?;
        final volumeMap = marketData?['total_volume'] as Map<String, dynamic>?;

        final coin = CryptoCoinModel(
          id: data['id'] as String? ?? coinId,
          name: data['name'] as String? ?? '',
          symbol: data['symbol'] as String? ?? '',
          imageUrl: imageData?['large'] as String?,
          currentPrice: currentPriceMap?['usd'] != null
              ? (currentPriceMap!['usd'] as num).toDouble()
              : null,
          priceChange24h: marketData?['price_change_24h'] != null
              ? (marketData!['price_change_24h'] as num).toDouble()
              : null,
          priceChangePercentage24h:
              marketData?['price_change_percentage_24h'] != null
              ? (marketData!['price_change_percentage_24h'] as num).toDouble()
              : null,
          marketCap: marketCapMap?['usd'] != null
              ? (marketCapMap!['usd'] as num).toDouble()
              : null,
          volume24h: volumeMap?['usd'] != null
              ? (volumeMap!['usd'] as num).toDouble()
              : null,
          marketCapRank: marketData?['market_cap_rank'] as int?,
        );
        return Success(coin);
      } else {
        return const Failure('Coin detayı alınamadı');
      }
    } catch (e) {
      return Failure(
        e is DioException
            ? (e.error?.toString() ?? 'Bilinmeyen hata')
            : 'Bilinmeyen hata',
        e,
      );
    }
  }

  /// Coin grafik verisini getir
  Future<Result<PriceChartDataModel>> getCoinChart(
    String coinId, {
    int days = 7,
    String vsCurrency = 'usd',
  }) async {
    try {
      // CoinGecko API: interval parametresi sadece belirli günler için çalışır
      // days <= 1 için interval kullanılmaz, otomatik olarak hourly gelir
      final queryParams = <String, dynamic>{
        'vs_currency': vsCurrency,
        'days': days,
      };

      // Interval sadece 1 günden fazla ve 90 günden az için kullanılabilir
      if (days > 1 && days < 90) {
        queryParams['interval'] = 'daily';
      }

      final response = await _dio.get(
        '${AppConstants.coinGeckoBaseUrl}/coins/$coinId/market_chart',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;

        // Debug: Veri yapısını kontrol et
        if (data['prices'] == null) {
          return Failure(
            'Grafik verisi formatı beklenmedik: prices bulunamadı',
            null,
          );
        }

        try {
          final chartData = PriceChartDataModel.fromJson(data);

          // Boş veri kontrolü
          if (chartData.prices.isEmpty) {
            return const Failure('Grafik verisi boş');
          }

          return Success(chartData);
        } catch (e) {
          return Failure('Grafik verisi parse edilemedi: ${e.toString()}', e);
        }
      } else {
        return Failure(
          'Grafik verisi alınamadı. Status: ${response.statusCode}',
          null,
        );
      }
    } on DioException catch (e) {
      String errorMessage = 'Grafik verisi alınamadı';

      if (e.response != null) {
        errorMessage = 'API Hatası: ${e.response?.statusCode}';
        if (e.response?.statusCode == 429) {
          errorMessage =
              'API limit aşıldı. Lütfen birkaç dakika sonra tekrar deneyin.';
        }
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Bağlantı zaman aşımı. Lütfen tekrar deneyin.';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage =
            'İnternet bağlantısı yok. Lütfen bağlantınızı kontrol edin.';
      }

      return Failure(errorMessage, e);
    } catch (e) {
      return Failure('Beklenmeyen hata: ${e.toString()}', e);
    }
  }
}
