import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/crypto/domain/entities/crypto_coin.dart';
import '../utils/result.dart';
import 'repositories_provider.dart';

/// Tüm coin listesi cache provider (performans için)
final allCoinsCacheProvider = FutureProvider<List<CryptoCoin>>((ref) async {
  final repository = ref.watch(cryptoRepositoryProvider);
  final result = await repository.getAllCoins();

  return result.when(
    success: (coins) => coins,
    failure: (message, _) => throw Exception(message),
  );
});
