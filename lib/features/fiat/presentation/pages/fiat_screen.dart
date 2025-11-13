import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/utils/formatters.dart';
import '../providers/fiat_providers.dart';
import '../../../../core/config/app_constants.dart';
import '../../../settings/presentation/pages/settings_screen.dart';

/// Döviz kurları ekranı
class FiatScreen extends ConsumerWidget {
  const FiatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final baseCurrency = ref.watch(baseCurrencyProvider);
    final ratesAsync = ref.watch(exchangeRatesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Döviz Kurları'),
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
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (currency) {
              ref.read(baseCurrencyProvider.notifier).state = currency;
              ref.invalidate(exchangeRatesProvider);
            },
            itemBuilder: (context) => AppConstants.supportedFiatCurrencies
                .map(
                  (currency) => PopupMenuItem(
                    value: currency,
                    child: Row(
                      children: [
                        if (currency == baseCurrency)
                          const Icon(Icons.check, size: 20),
                        const SizedBox(width: 8),
                        Text(currency),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
      body: ratesAsync.when(
        data: (rates) {
          final filteredRates =
              rates.rates.entries
                  .where(
                    (entry) => AppConstants.supportedFiatCurrencies.contains(
                      entry.key,
                    ),
                  )
                  .toList()
                ..sort((a, b) => a.key.compareTo(b.key));

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(exchangeRatesProvider);
            },
            child: Column(
              children: [
                // Base currency info
                Card(
                  margin: const EdgeInsets.all(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Base Currency',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              baseCurrency,
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        if (rates.lastUpdate != null)
                          Text(
                            'Güncelleme: ${Formatters.formatTime(rates.lastUpdate)}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                      ],
                    ),
                  ),
                ),
                // Rates list
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredRates.length,
                    itemBuilder: (context, index) {
                      final entry = filteredRates[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: ListTile(
                          title: Text(entry.key),
                          trailing: Text(
                            entry.value.toStringAsFixed(4),
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
        loading: () =>
            const LoadingIndicator(message: 'Döviz kurları yükleniyor...'),
        error: (error, stack) => ErrorDisplay(
          message: error.toString(),
          onRetry: () {
            ref.invalidate(exchangeRatesProvider);
          },
        ),
      ),
    );
  }
}
