import '../../../../core/utils/result.dart';
import '../../domain/entities/exchange_rate.dart';
import '../../domain/repositories/fiat_repository.dart';
import '../datasources/fiat_remote_datasource.dart';

/// Döviz kuru repository implementasyonu
class FiatRepositoryImpl implements FiatRepository {
  final FiatRemoteDataSource _remoteDataSource;

  FiatRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<ExchangeRate>> getExchangeRates(String baseCurrency) async {
    final result = await _remoteDataSource.getExchangeRates(baseCurrency);

    return result.when(
      success: (model) => Success(model.toEntity()),
      failure: (message, error) => Failure(message, error),
    );
  }
}
