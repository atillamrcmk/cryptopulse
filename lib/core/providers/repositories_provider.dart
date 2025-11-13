import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/crypto/data/datasources/crypto_remote_datasource.dart';
import '../../features/crypto/data/repositories/crypto_repository_impl.dart';
import '../../features/crypto/domain/repositories/crypto_repository.dart';
import '../../features/fiat/data/datasources/fiat_remote_datasource.dart';
import '../../features/fiat/data/repositories/fiat_repository_impl.dart';
import '../../features/fiat/domain/repositories/fiat_repository.dart';

/// Repository provider'ları
final cryptoRepositoryProvider = Provider<CryptoRepository>((ref) {
  return CryptoRepositoryImpl(CryptoRemoteDataSource());
});

final fiatRepositoryProvider = Provider<FiatRepository>((ref) {
  return FiatRepositoryImpl(FiatRemoteDataSource());
});
