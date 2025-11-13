import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/config/app_constants.dart';
import '../../../../core/providers/repositories_provider.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/portfolio_item.dart';
import '../../domain/entities/portfolio_summary.dart';
import '../../data/models/portfolio_item_model.dart';

/// Portfolio box provider
final portfolioBoxProvider = FutureProvider<Box<PortfolioItemModel>>((
  ref,
) async {
  if (!Hive.isBoxOpen(AppConstants.portfolioBox)) {
    await Hive.openBox<PortfolioItemModel>(AppConstants.portfolioBox);
  }
  return Hive.box<PortfolioItemModel>(AppConstants.portfolioBox);
});

/// Portfolio items provider
final portfolioItemsProvider = FutureProvider<List<PortfolioItem>>((ref) async {
  final box = await ref.watch(portfolioBoxProvider.future);
  final models = box.values.cast<PortfolioItemModel>().toList();
  return models.map((model) => model.toEntity()).toList();
});

/// Portfolio summary provider (coin fiyatlarıyla birlikte hesaplanır)
final portfolioSummaryProvider = FutureProvider<PortfolioSummary>((ref) async {
  final items = await ref.watch(portfolioItemsProvider.future);
  final cryptoRepository = ref.watch(cryptoRepositoryProvider);

  if (items.isEmpty) {
    return const PortfolioSummary(
      totalValue: 0,
      totalValueChange24h: 0,
      totalValueChangePercentage24h: 0,
      itemCount: 0,
    );
  }

  // Coin fiyatlarını çek
  final coinIds = items.map((item) => item.coinId).toList();
  final pricesResult = await cryptoRepository.getCoinsPrices(
    coinIds,
    vsCurrencies: ['try'],
  );

  double totalValue = 0;
  double totalValueChange24h = 0;

  pricesResult.when(
    success: (coinsMap) {
      for (final item in items) {
        final coin = coinsMap[item.coinId];
        if (coin != null && coin.prices != null) {
          final price = coin.prices!['try'] ?? 0;
          final itemValue = item.amount * price;
          totalValue += itemValue;

          // 24h değişim hesaplama (basitleştirilmiş)
          final priceChange = coin.priceChangePercentage24h ?? 0;
          totalValueChange24h += itemValue * (priceChange / 100);
        }
      }
    },
    failure: (_, __) {},
  );

  final totalValueChangePercentage = totalValue > 0
      ? (totalValueChange24h / totalValue) * 100
      : 0.0;

  return PortfolioSummary(
    totalValue: totalValue,
    totalValueChange24h: totalValueChange24h,
    totalValueChangePercentage24h: totalValueChangePercentage,
    itemCount: items.length,
  );
});
