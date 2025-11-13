import 'package:dio/dio.dart';
import '../../../../core/config/app_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/result.dart';
import '../models/exchange_rate_model.dart';

/// Döviz kuru remote data source
class FiatRemoteDataSource {
  final Dio _dio;

  FiatRemoteDataSource() : _dio = DioClient.instance;

  /// Döviz kurlarını getir
  Future<Result<ExchangeRateModel>> getExchangeRates(
    String baseCurrency,
  ) async {
    try {
      final response = await _dio.get(
        '${AppConstants.exchangeRateBaseUrl}/latest/$baseCurrency',
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;

        // Exchange Rate API response yapısını kontrol et
        // API'den gelen veri yapısı: { "result": "success", "base_code": "USD", "rates": {...}, "time_last_update_unix": ... }
        final ratesMap = <String, double>{};
        final rates = data['rates'] as Map<String, dynamic>?;

        if (rates != null) {
          rates.forEach((key, value) {
            if (value is num) {
              ratesMap[key] = value.toDouble();
            }
          });
        }

        final model = ExchangeRateModel(
          base: data['base_code'] as String? ?? baseCurrency,
          rates: ratesMap,
          lastUpdateUnix: data['time_last_update_unix'] as int?,
        );

        return Success(model);
      } else {
        return const Failure('Döviz kuru verisi alınamadı');
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
}
