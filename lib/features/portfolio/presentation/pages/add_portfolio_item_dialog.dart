import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/config/app_constants.dart';
import '../../../../core/providers/coins_cache_provider.dart';
import '../../../crypto/domain/entities/crypto_coin.dart';
import '../../data/models/portfolio_item_model.dart';
import '../../domain/entities/portfolio_item.dart';

/// Portföy öğesi ekleme dialog'u
class AddPortfolioItemDialog extends ConsumerStatefulWidget {
  const AddPortfolioItemDialog({super.key});

  @override
  ConsumerState<AddPortfolioItemDialog> createState() =>
      _AddPortfolioItemDialogState();
}

class _AddPortfolioItemDialogState
    extends ConsumerState<AddPortfolioItemDialog> {
  String? _selectedCoinId;
  String? _selectedCoinName;
  String? _selectedCoinSymbol;
  final TextEditingController _amountController = TextEditingController();
  bool _isLoading = false;
  bool _isLoadingCoins = false;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _selectCoin() async {
    setState(() => _isLoadingCoins = true);

    try {
      // Cache'den coin listesini al
      final coinsAsync = ref.read(allCoinsCacheProvider);
      final coins = coinsAsync.maybeWhen(
        data: (coins) => coins,
        orElse: () => <CryptoCoin>[],
      );

      // Eğer cache'de yoksa bekleyelim
      if (coins.isEmpty) {
        // Provider'ı yeniden yükle ve bekle
        ref.invalidate(allCoinsCacheProvider);
        final newCoinsAsync = ref.read(allCoinsCacheProvider);

        List<CryptoCoin> newCoins = [];

        await newCoinsAsync.when(
          data: (coins) {
            newCoins = coins;
          },
          loading: () async {
            // Loading durumunda biraz bekle ve tekrar dene
            await Future.delayed(const Duration(milliseconds: 500));
            final retryAsync = ref.read(allCoinsCacheProvider);
            newCoins = retryAsync.maybeWhen(
              data: (coins) => coins,
              orElse: () => <CryptoCoin>[],
            );
          },
          error: (_, __) {
            newCoins = <CryptoCoin>[];
          },
        );

        setState(() => _isLoadingCoins = false);
        if (!mounted) return;

        if (newCoins.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Coin listesi yüklenemedi')),
          );
          return;
        }

        final selected = await showDialog<Map<String, String>>(
          context: context,
          builder: (context) => _CoinSelectionDialog(coins: newCoins),
        );

        if (selected != null && mounted) {
          setState(() {
            _selectedCoinId = selected['id'];
            _selectedCoinName = selected['name'];
            _selectedCoinSymbol = selected['symbol'];
          });
        }
        return;
      }

      setState(() => _isLoadingCoins = false);

      if (!mounted) return;

      final selected = await showDialog<Map<String, String>>(
        context: context,
        builder: (context) => _CoinSelectionDialog(coins: coins),
      );

      if (selected != null && mounted) {
        setState(() {
          _selectedCoinId = selected['id'];
          _selectedCoinName = selected['name'];
          _selectedCoinSymbol = selected['symbol'];
        });
      }
    } catch (e) {
      setState(() => _isLoadingCoins = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Hata: ${e.toString()}')));
      }
    }
  }

  Future<void> _save() async {
    if (_selectedCoinId == null || _amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen coin ve miktar seçin')),
      );
      return;
    }

    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Geçerli bir miktar girin')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final box = await Hive.openBox<PortfolioItemModel>(
        AppConstants.portfolioBox,
      );
      final item = PortfolioItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        coinId: _selectedCoinId!,
        coinName: _selectedCoinName!,
        coinSymbol: _selectedCoinSymbol!,
        amount: amount,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await box.add(PortfolioItemModel.fromEntity(item));

      if (mounted) {
        Navigator.of(context).pop(true); // true döndür ki refresh yapılsın
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Portföye eklendi')));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Hata: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Portföye Ekle'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Coin selection
          OutlinedButton.icon(
            onPressed: _isLoadingCoins ? null : _selectCoin,
            icon: _isLoadingCoins
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.search),
            label: Text(_selectedCoinName ?? 'Coin Seç'),
          ),
          const SizedBox(height: 16),
          // Amount input
          TextField(
            controller: _amountController,
            decoration: const InputDecoration(
              labelText: 'Miktar',
              hintText: 'Örn: 0.5',
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (mounted) {
              Navigator.of(context).pop(false);
            }
          },
          child: const Text('İptal'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _save,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Kaydet'),
        ),
      ],
    );
  }
}

class _CoinSelectionDialog extends StatefulWidget {
  final List<CryptoCoin> coins;

  const _CoinSelectionDialog({required this.coins});

  @override
  State<_CoinSelectionDialog> createState() => _CoinSelectionDialogState();
}

class _CoinSelectionDialogState extends State<_CoinSelectionDialog> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _filteredCoins = [];
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    // İlk 50 popüler coin göster (daha hızlı yükleme)
    _filteredCoins = widget.coins.take(50).toList();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _filterCoins(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      if (!mounted) return;

      setState(() {
        if (query.isEmpty) {
          _filteredCoins = widget.coins.take(50).toList();
        } else {
          final lowerQuery = query.toLowerCase();
          _filteredCoins = widget.coins
              .where(
                (coin) =>
                    coin.name.toLowerCase().contains(lowerQuery) ||
                    coin.symbol.toLowerCase().contains(lowerQuery),
              )
              .take(100) // Arama sonuçlarında 100'e çıkar
              .toList();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Coin Seç',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      if (mounted) {
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ],
              ),
            ),
            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Coin ara...',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: _filterCoins,
                autofocus: true,
              ),
            ),
            const SizedBox(height: 8),
            // Results count
            if (_searchController.text.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  '${_filteredCoins.length} sonuç bulundu',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            // Coin list
            Expanded(
              child: _filteredCoins.isEmpty
                  ? Center(
                      child: Text(
                        _searchController.text.isEmpty
                            ? 'Arama yapın...'
                            : 'Sonuç bulunamadı',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredCoins.length,
                      itemBuilder: (context, index) {
                        final coin = _filteredCoins[index];
                        return ListTile(
                          title: Text(coin.name),
                          subtitle: Text(coin.symbol.toUpperCase()),
                          onTap: () {
                            if (mounted) {
                              Navigator.of(context).pop({
                                'id': coin.id,
                                'name': coin.name,
                                'symbol': coin.symbol,
                              });
                            }
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
