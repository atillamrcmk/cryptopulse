import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/repositories_provider.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/exchange_rate.dart';

/// Base currency provider
final baseCurrencyProvider = StateProvider<String>((ref) => 'USD');

/// Döviz kurları provider
final exchangeRatesProvider = FutureProvider<ExchangeRate>((ref) async {
  try {
    final repository = ref.watch(fiatRepositoryProvider);
    final baseCurrency = ref.watch(baseCurrencyProvider);

    final result = await repository.getExchangeRates(baseCurrency);

    return result.when(
      success: (rates) => rates,
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
