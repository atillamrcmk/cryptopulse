import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/error_widget.dart';
import '../providers/crypto_providers.dart';
import '../widgets/crypto_coin_card.dart';
import 'coin_detail_screen.dart';
import '../../../settings/presentation/providers/settings_providers.dart';
import '../../../settings/presentation/pages/settings_screen.dart';

/// Market ekranı (kripto listesi)
class MarketScreen extends ConsumerStatefulWidget {
  const MarketScreen({super.key});

  @override
  ConsumerState<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends ConsumerState<MarketScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      ref.read(coinSearchProvider.notifier).state = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final popularCoinsAsync = ref.watch(popularCoinsProvider);
    final filteredCoins = ref.watch(filteredCoinsProvider);
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Market'),
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
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Coin ara...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          // Coin list
          Expanded(
            child: popularCoinsAsync.when(
              data: (_) {
                if (filteredCoins.isEmpty) {
                  return const Center(child: Text('Coin bulunamadı'));
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(popularCoinsProvider);
                  },
                  child: ListView.builder(
                    itemCount: filteredCoins.length,
                    itemBuilder: (context, index) {
                      final coin = filteredCoins[index];
                      return CryptoCoinCard(
                        coin: coin,
                        defaultCurrency: settings.defaultFiatCurrency,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CoinDetailScreen(coinId: coin.id),
                            ),
                          ).catchError((error) {
                            // Navigation hatası durumunda
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Hata: ${error.toString()}'),
                              ),
                            );
                          });
                        },
                      );
                    },
                  ),
                );
              },
              loading: () =>
                  const LoadingIndicator(message: 'Coinler yükleniyor...'),
              error: (error, stack) => ErrorDisplay(
                message: error.toString(),
                onRetry: () {
                  ref.invalidate(popularCoinsProvider);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
