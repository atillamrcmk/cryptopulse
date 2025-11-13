import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/error_widget.dart';
import '../providers/crypto_providers.dart';
import '../widgets/crypto_coin_card.dart';
import 'coin_detail_screen.dart';
import '../../../settings/presentation/providers/settings_providers.dart';

/// Favoriler ekranı
class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoritesProvider);
    final popularCoinsAsync = ref.watch(popularCoinsProvider);
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Favorilerim')),
      body: favoritesAsync.when(
        data: (favoriteIds) {
          if (favoriteIds.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Henüz favori coin eklemedin',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Coin detay sayfasından favorilere ekleyebilirsin',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return popularCoinsAsync.when(
            data: (allCoins) {
              // Sadece favori olan coinleri filtrele
              final favoriteCoins = allCoins
                  .where((coin) => favoriteIds.contains(coin.id))
                  .toList();

              if (favoriteCoins.isEmpty) {
                return const Center(
                  child: Text('Favori coinler yükleniyor...'),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(popularCoinsProvider);
                  ref.invalidate(favoritesProvider);
                },
                child: ListView.builder(
                  itemCount: favoriteCoins.length,
                  itemBuilder: (context, index) {
                    final coin = favoriteCoins[index];
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
                        );
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
          );
        },
        loading: () => const LoadingIndicator(),
        error: (error, stack) => ErrorDisplay(
          message: error.toString(),
          onRetry: () {
            ref.invalidate(favoritesProvider);
          },
        ),
      ),
    );
  }
}
