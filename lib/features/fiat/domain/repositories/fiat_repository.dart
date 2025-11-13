import '../entities/exchange_rate.dart';
import '../../../../core/utils/result.dart';

/// Döviz kuru repository interface
abstract class FiatRepository {
  /// Belirli bir base currency için döviz kurlarını getir
  Future<Result<ExchangeRate>> getExchangeRates(String baseCurrency);
}
