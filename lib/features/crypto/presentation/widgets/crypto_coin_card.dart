import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/config/app_colors.dart';
import '../../domain/entities/crypto_coin.dart';

/// Kripto coin kartı widget'ı
class CryptoCoinCard extends StatelessWidget {
  final CryptoCoin coin;
  final String defaultCurrency;
  final VoidCallback? onTap;

  const CryptoCoinCard({
    super.key,
    required this.coin,
    this.defaultCurrency = 'TRY',
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final price = _getPrice();
    final change24h = coin.priceChangePercentage24h ?? 0.0;
    final isPositive = change24h >= 0;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Coin icon
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: coin.image != null
                    ? CachedNetworkImage(
                        imageUrl: coin.image!,
                        width: 48,
                        height: 48,
                        placeholder: (context, url) => const SizedBox(
                          width: 48,
                          height: 48,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: 48,
                          height: 48,
                          color: AppColors.darkCard,
                          child: const Icon(Icons.currency_bitcoin),
                        ),
                      )
                    : Container(
                        width: 48,
                        height: 48,
                        color: AppColors.darkCard,
                        child: const Icon(Icons.currency_bitcoin),
                      ),
              ),
              const SizedBox(width: 16),
              // Coin info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      coin.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      coin.symbol.toUpperCase(),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              // Price and change
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    Formatters.formatCurrency(price, currency: defaultCurrency),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isPositive ? Icons.trending_up : Icons.trending_down,
                        size: 16,
                        color: isPositive
                            ? AppColors.positive
                            : AppColors.negative,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        Formatters.formatPercentage(change24h),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isPositive
                              ? AppColors.positive
                              : AppColors.negative,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _getPrice() {
    if (coin.prices != null && coin.prices!.isNotEmpty) {
      final currencyKey = defaultCurrency.toLowerCase();
      return coin.prices![currencyKey] ?? coin.currentPrice ?? 0.0;
    }
    return coin.currentPrice ?? 0.0;
  }
}
