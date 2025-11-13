import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/config/app_colors.dart';
import '../../../../core/utils/result.dart';
import '../providers/portfolio_providers.dart';
import '../../../../core/providers/repositories_provider.dart';
import '../../../settings/presentation/pages/settings_screen.dart';
import 'add_portfolio_item_dialog.dart';

/// Portföy ekranı
class PortfolioScreen extends ConsumerWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(portfolioItemsProvider);
    final summaryAsync = ref.watch(portfolioSummaryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Portföy'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              if (!context.mounted) return;

              final result = await showDialog<bool>(
                context: context,
                builder: (context) => const AddPortfolioItemDialog(),
              );

              // Dialog kapandıktan sonra refresh yap
              if (result == true && context.mounted) {
                ref.invalidate(portfolioItemsProvider);
                ref.invalidate(portfolioSummaryProvider);
              }
            },
          ),
        ],
      ),
      body: itemsAsync.when(
        data: (items) {
          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.wallet_outlined,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Henüz portföy eklemedin',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Portföyüne coin eklemek için + butonuna tıkla',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(portfolioItemsProvider);
              ref.invalidate(portfolioSummaryProvider);
            },
            child: Column(
              children: [
                // Summary card
                summaryAsync.when(
                  data: (summary) => _SummaryCard(summary: summary),
                  loading: () => const Card(
                    margin: EdgeInsets.all(16),
                    child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
                  error: (_, __) => const SizedBox.shrink(),
                ),
                // Items list
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return _PortfolioItemCard(
                        item: item,
                        onDelete: () async {
                          final box = await ref.read(
                            portfolioBoxProvider.future,
                          );
                          final key = box.keys.firstWhere((key) {
                            final model = box.get(key);
                            return model?.id == item.id;
                          }, orElse: () => null);
                          if (key != null) {
                            await box.delete(key);
                            ref.invalidate(portfolioItemsProvider);
                            ref.invalidate(portfolioSummaryProvider);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Portföy öğesi silindi'),
                                ),
                              );
                            }
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const LoadingIndicator(),
        error: (error, stack) => ErrorDisplay(
          message: error.toString(),
          onRetry: () {
            ref.invalidate(portfolioItemsProvider);
          },
        ),
      ),
    );
  }
}

class _SummaryCard extends ConsumerWidget {
  final dynamic summary;

  const _SummaryCard({required this.summary});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPositive = summary.totalValueChangePercentage24h >= 0;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Toplam Portföy Değeri',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Text(
              Formatters.formatCurrency(summary.totalValue, currency: 'TRY'),
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  isPositive ? Icons.trending_up : Icons.trending_down,
                  color: isPositive ? AppColors.positive : AppColors.negative,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  Formatters.formatPercentage(
                    summary.totalValueChangePercentage24h,
                  ),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: isPositive ? AppColors.positive : AppColors.negative,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '${summary.itemCount} coin',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _PortfolioItemCard extends ConsumerWidget {
  final dynamic item;
  final VoidCallback? onDelete;

  const _PortfolioItemCard({required this.item, this.onDelete});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Coin fiyatını FutureBuilder ile çek
    return FutureBuilder(
      future: ref
          .read(cryptoRepositoryProvider)
          .getCoinsPrices([item.coinId], vsCurrencies: ['try']),
      builder: (context, snapshot) {
        double? price;
        double? totalValue;

        if (snapshot.hasData) {
          snapshot.data!.when(
            success: (coinsMap) {
              final coin = coinsMap[item.coinId];
              price = coin?.prices?['try'];
              if (price != null) {
                totalValue = item.amount * price!;
              }
            },
            failure: (_, __) {},
          );
        }

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: ListTile(
            title: Text(item.coinName),
            subtitle: Text(
              '${item.amount.toStringAsFixed(8)} ${item.coinSymbol.toUpperCase()}',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (price != null)
                      Text(
                        Formatters.formatCurrency(price, currency: 'TRY'),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    if (totalValue != null)
                      Text(
                        Formatters.formatCurrency(totalValue, currency: 'TRY'),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
                if (onDelete != null) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    color: AppColors.negative,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Portföy Öğesini Sil'),
                          content: const Text(
                            'Bu öğeyi silmek istediğinize emin misiniz?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('İptal'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                onDelete?.call();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.negative,
                              ),
                              child: const Text('Sil'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
