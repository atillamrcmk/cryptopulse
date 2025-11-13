import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/config/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../domain/entities/price_chart_data.dart';
import '../providers/crypto_providers.dart';
import '../../../settings/presentation/providers/settings_providers.dart';
import '../../../settings/data/models/favorite_coin_model.dart';
import '../../../settings/data/models/price_alarm_model.dart';

/// Coin detay ekranı
class CoinDetailScreen extends ConsumerStatefulWidget {
  final String coinId;

  const CoinDetailScreen({super.key, required this.coinId});

  @override
  ConsumerState<CoinDetailScreen> createState() => _CoinDetailScreenState();
}

class _CoinDetailScreenState extends ConsumerState<CoinDetailScreen> {
  bool _isFavorite = false;
  int _selectedDays = 7;
  String _selectedCurrency = 'usd'; // Varsayılan USD, daha güvenilir
  bool _showChart = true; // Grafik gösterimi için flag

  @override
  void initState() {
    super.initState();
    _checkFavorite();
  }

  Future<void> _checkFavorite() async {
    final favorites = await ref.read(favoritesProvider.future);
    setState(() {
      _isFavorite = favorites.contains(widget.coinId);
    });
  }

  Future<void> _toggleFavorite() async {
    final box = await ref.read(favoritesBoxProvider.future);
    if (_isFavorite) {
      final key = box.keys.firstWhere(
        (key) => box.get(key)?.coinId == widget.coinId,
        orElse: () => null,
      );
      if (key != null) {
        await box.delete(key);
      }
    } else {
      await box.add(
        FavoriteCoinModel(coinId: widget.coinId, addedAt: DateTime.now()),
      );
    }
    setState(() {
      _isFavorite = !_isFavorite;
    });
    ref.invalidate(favoritesProvider);
  }

  Future<void> _showAlarmDialog() async {
    final coinAsync = ref.read(coinDetailProvider(widget.coinId));
    final coin = coinAsync.maybeWhen(data: (coin) => coin, orElse: () => null);

    if (coin == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Coin bilgisi yüklenemedi')));
      return;
    }

    final priceController = TextEditingController();
    bool isAbove = true;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fiyat Alarmı Kur',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(
                    labelText: 'Hedef Fiyat (TRY)',
                    hintText: 'Örn: 2000000',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ChoiceChip(
                        label: const Text('Yukarı kırınca'),
                        selected: isAbove,
                        onSelected: (selected) {
                          setState(() => isAbove = true);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ChoiceChip(
                        label: const Text('Aşağı kırınca'),
                        selected: !isAbove,
                        onSelected: (selected) {
                          setState(() => isAbove = false);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('İptal'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () async {
                        final price = double.tryParse(priceController.text);
                        if (price != null && price > 0) {
                          final alarmsBox = await ref.read(
                            alarmsBoxProvider.future,
                          );
                          await alarmsBox.add(
                            PriceAlarmModel(
                              id: DateTime.now().millisecondsSinceEpoch
                                  .toString(),
                              coinId: coin.id,
                              coinName: coin.name,
                              coinSymbol: coin.symbol,
                              targetPrice: price,
                              isAbove: isAbove,
                              createdAt: DateTime.now(),
                            ),
                          );
                          ref.invalidate(alarmsProvider);
                          if (mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Alarm kuruldu')),
                            );
                          }
                        }
                      },
                      child: const Text('Kaydet'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final coinAsync = ref.watch(coinDetailProvider(widget.coinId));

    return Scaffold(
      appBar: AppBar(
        title: coinAsync.when(
          data: (coin) => Text(coin.name),
          loading: () => const Text('Yükleniyor...'),
          error: (_, __) => const Text('Hata'),
        ),
        actions: [
          IconButton(
            icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: coinAsync.when(
        data: (coin) {
          final price =
              coin.prices?['try'] ??
              coin.prices?['usd'] ??
              coin.currentPrice ??
              0.0;
          final change24h = coin.priceChangePercentage24h ?? 0.0;
          final isPositive = change24h >= 0;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Price header
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          coin.symbol.toUpperCase(),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          Formatters.formatCurrency(price, currency: 'TRY'),
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              isPositive
                                  ? Icons.trending_up
                                  : Icons.trending_down,
                              color: isPositive
                                  ? AppColors.positive
                                  : AppColors.negative,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              Formatters.formatPercentage(change24h),
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    color: isPositive
                                        ? AppColors.positive
                                        : AppColors.negative,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Metrics
                Row(
                  children: [
                    Expanded(
                      child: _MetricCard(
                        title: 'Market Cap',
                        value: Formatters.formatCompactNumber(coin.marketCap),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _MetricCard(
                        title: '24h Volume',
                        value: Formatters.formatCompactNumber(coin.volume24h),
                      ),
                    ),
                  ],
                ),
                if (coin.marketCapRank != null) ...[
                  const SizedBox(height: 8),
                  _MetricCard(
                    title: 'Market Cap Rank',
                    value: '#${coin.marketCapRank}',
                  ),
                ],
                const SizedBox(height: 24),
                // Price Chart (Opsiyonel - API limit durumunda gösterilmeyebilir)
                if (_showChart)
                  _PriceChartWidget(
                    coinId: widget.coinId,
                    selectedDays: _selectedDays,
                    selectedCurrency: _selectedCurrency,
                    onDaysChanged: (days) {
                      setState(() {
                        _selectedDays = days;
                      });
                    },
                    onCurrencyChanged: (currency) {
                      setState(() {
                        _selectedCurrency = currency;
                      });
                    },
                    onHideChart: () {
                      setState(() {
                        _showChart = false;
                      });
                    },
                  )
                else
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            'Grafik Gizlendi',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'API limiti nedeniyle grafik gizlendi.',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 16),
                          OutlinedButton.icon(
                            onPressed: () {
                              setState(() {
                                _showChart = true;
                              });
                            },
                            icon: const Icon(Icons.show_chart),
                            label: const Text('Grafiği Göster'),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _toggleFavorite,
                        icon: Icon(
                          _isFavorite ? Icons.favorite : Icons.favorite_border,
                        ),
                        label: Text(
                          _isFavorite
                              ? 'Favorilerden Çıkar'
                              : 'Favorilere Ekle',
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _showAlarmDialog,
                        icon: const Icon(Icons.notifications),
                        label: const Text('Alarm Kur'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        loading: () => const LoadingIndicator(),
        error: (error, stack) => ErrorDisplay(
          message: error.toString(),
          onRetry: () {
            ref.invalidate(coinDetailProvider(widget.coinId));
          },
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;

  const _MetricCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

/// Fiyat grafik widget'ı
class _PriceChartWidget extends ConsumerWidget {
  final String coinId;
  final int selectedDays;
  final String selectedCurrency;
  final ValueChanged<int> onDaysChanged;
  final ValueChanged<String> onCurrencyChanged;
  final VoidCallback? onHideChart;

  const _PriceChartWidget({
    required this.coinId,
    required this.selectedDays,
    required this.selectedCurrency,
    required this.onDaysChanged,
    required this.onCurrencyChanged,
    this.onHideChart,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Grafik verilerini cache'lemek için provider'ı watch ediyoruz
    // Aynı parametreler için tekrar API çağrısı yapılmaz (Riverpod cache)
    final chartAsync = ref.watch(
      coinChartProvider(
        ChartParams(
          coinId: coinId,
          days: selectedDays,
          vsCurrency: selectedCurrency,
        ),
      ),
    );

    // Rate limit kontrolü - eğer hata varsa ve rate limit ise, cache'lenmiş veriyi göster
    final hasRateLimitError =
        chartAsync.hasError && chartAsync.error.toString().contains('limit');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Başlık ve kontroller
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fiyat Grafiği',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    if (hasRateLimitError)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          '⚠️ API limiti nedeniyle güncel veri alınamıyor',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: AppColors.negative,
                                fontSize: 10,
                              ),
                        ),
                      ),
                  ],
                ),
                // Para birimi seçimi
                PopupMenuButton<String>(
                  initialValue: selectedCurrency,
                  onSelected: onCurrencyChanged,
                  child: Chip(
                    label: Text(selectedCurrency.toUpperCase()),
                    avatar: const Icon(Icons.currency_exchange, size: 18),
                  ),
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'try', child: Text('TRY')),
                    const PopupMenuItem(value: 'usd', child: Text('USD')),
                    const PopupMenuItem(value: 'eur', child: Text('EUR')),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Zaman aralığı seçimi
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _TimeButton(
                    label: '24S',
                    days: 1,
                    selected: selectedDays == 1,
                    onTap: () => onDaysChanged(1),
                  ),
                  const SizedBox(width: 8),
                  _TimeButton(
                    label: '7G',
                    days: 7,
                    selected: selectedDays == 7,
                    onTap: () => onDaysChanged(7),
                  ),
                  const SizedBox(width: 8),
                  _TimeButton(
                    label: '30G',
                    days: 30,
                    selected: selectedDays == 30,
                    onTap: () => onDaysChanged(30),
                  ),
                  const SizedBox(width: 8),
                  _TimeButton(
                    label: '90G',
                    days: 90,
                    selected: selectedDays == 90,
                    onTap: () => onDaysChanged(90),
                  ),
                  const SizedBox(width: 8),
                  _TimeButton(
                    label: '1Y',
                    days: 365,
                    selected: selectedDays == 365,
                    onTap: () => onDaysChanged(365),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Grafik
            SizedBox(
              height: 250,
              child: chartAsync.when(
                data: (chartData) {
                  if (chartData.prices.isEmpty) {
                    return const Center(
                      child: Text('Grafik verisi bulunamadı'),
                    );
                  }
                  return _buildChart(chartData, context);
                },
                loading: () => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 8),
                      Text(
                        'Grafik verisi yükleniyor...',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                error: (error, stack) {
                  // Hata mesajını göster
                  final errorMessage = error.toString().replaceAll(
                    'Exception: ',
                    '',
                  );
                  final isRateLimit =
                      errorMessage.contains('limit') ||
                      errorMessage.contains('429') ||
                      errorMessage.contains('Rate limit');

                  // Rate limit durumunda grafik widget'ını gizle veya basit mesaj göster
                  if (isRateLimit) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.schedule,
                            color: AppColors.negative,
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'API Limit Aşıldı',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: Text(
                              'CoinGecko ücretsiz API planı dakikada sınırlı istek yapabilir.\n\n'
                              'Grafik verileri için lütfen birkaç dakika bekleyin.',
                              style: Theme.of(context).textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              OutlinedButton.icon(
                                onPressed: () {
                                  // Farklı zaman aralığı dene (cache'lenmiş olabilir)
                                  final newDays = selectedDays == 7 ? 30 : 7;
                                  onDaysChanged(newDays);
                                },
                                icon: const Icon(Icons.swap_horiz),
                                label: const Text('Farklı Aralık Dene'),
                              ),
                              if (onHideChart != null) ...[
                                const SizedBox(width: 8),
                                OutlinedButton.icon(
                                  onPressed: onHideChart,
                                  icon: const Icon(Icons.visibility_off),
                                  label: const Text('Gizle'),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    );
                  }

                  return Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isRateLimit ? Icons.schedule : Icons.error_outline,
                            color: AppColors.negative,
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            isRateLimit
                                ? 'API Limit Aşıldı'
                                : 'Grafik Yüklenemedi',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: Text(
                              errorMessage,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium?.color,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          if (isRateLimit) ...[
                            const SizedBox(height: 16),
                            Card(
                              color: Theme.of(
                                context,
                              ).colorScheme.surfaceVariant,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  children: [
                                    Text(
                                      '💡 İpucu',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '• Grafik verileri otomatik olarak cache\'lenir\n'
                                      '• Birkaç dakika sonra tekrar deneyin\n'
                                      '• Farklı bir coin seçebilirsiniz',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall,
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton.icon(
                                onPressed: () {
                                  ref.invalidate(
                                    coinChartProvider(
                                      ChartParams(
                                        coinId: coinId,
                                        days: selectedDays,
                                        vsCurrency: selectedCurrency,
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.refresh),
                                label: const Text('Tekrar Dene'),
                              ),
                              if (isRateLimit) ...[
                                const SizedBox(width: 8),
                                OutlinedButton.icon(
                                  onPressed: () {
                                    // Farklı zaman aralığı dene
                                    final newDays = selectedDays == 7 ? 30 : 7;
                                    onDaysChanged(newDays);
                                  },
                                  icon: const Icon(Icons.swap_horiz),
                                  label: const Text('Farklı Aralık'),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChart(PriceChartData chartData, BuildContext context) {
    final prices = chartData.prices;
    if (prices.isEmpty) {
      return const Center(child: Text('Veri yok'));
    }

    // Verilerin zaman sırasını kontrol et (en eski -> en yeni olmalı)
    // CoinGecko API genelde zaman sırasına göre döndürür
    final sortedPrices = List<PricePoint>.from(prices);

    // Min ve max değerleri bul
    final values = sortedPrices.map((p) => p.value).toList();
    final minValue = values.reduce((a, b) => a < b ? a : b);
    final maxValue = values.reduce((a, b) => a > b ? a : b);
    final range = maxValue - minValue;
    final padding = range * 0.1; // %10 padding

    // İlk ve son fiyat (zaman sırasına göre)
    final firstPrice = sortedPrices.first.value;
    final lastPrice = sortedPrices.last.value;
    final isPositive = lastPrice >= firstPrice;

    // Spot değerleri (grafik için normalize edilmiş)
    // fl_chart'ta Y ekseni: 0 = üst, 1 = alt
    // Yüksek fiyatlar üstte, düşük fiyatlar altta olmalı
    final spots = sortedPrices.asMap().entries.map((entry) {
      final index = entry.key;
      final price = entry.value;
      // Normalize: yüksek fiyat -> 0 (üst), düşük fiyat -> 1 (alt)
      // Formül: Y = (price - min + padding) / (range + 2*padding)
      // Bu formül yüksek fiyatları üste, düşük fiyatları alta koyar
      final normalizedY =
          (price.value - minValue + padding) / (range + padding * 2);
      // fl_chart'ta Y ekseni ters çalışır (0=üst, 1=alt), bu yüzden tersine çeviriyoruz
      return FlSpot(index.toDouble(), 1.0 - normalizedY);
    }).toList();

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 0.25,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Theme.of(context).dividerColor.withOpacity(0.2),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 &&
                    value.toInt() < sortedPrices.length &&
                    value.toInt() % (sortedPrices.length ~/ 4) == 0) {
                  final date = sortedPrices[value.toInt()].timestamp;
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      '${date.day}/${date.month}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              interval: 0.25, // 4 etiket göster
              getTitlesWidget: (value, meta) {
                // Y ekseni: value 0 = üst (max), value 1 = alt (min)
                // Normalize işleminin tersini yaparak gerçek fiyatı bul
                // normalizedY = (price - min + padding) / (range + 2*padding)
                // price = min - padding + normalizedY * (range + 2*padding)
                // value = 1 - normalizedY olduğu için:
                // price = min - padding + (1 - value) * (range + 2*padding)
                final price =
                    minValue - padding + (1.0 - value) * (range + padding * 2);
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    Formatters.formatCompactNumber(price),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(
            color: Theme.of(context).dividerColor.withOpacity(0.3),
          ),
        ),
        minX: 0,
        maxX: (sortedPrices.length - 1).toDouble(),
        minY: 0,
        maxY: 1,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: isPositive ? AppColors.positive : AppColors.negative,
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: (isPositive ? AppColors.positive : AppColors.negative)
                  .withOpacity(0.1),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (List<LineBarSpot> touchedSpots) {
              return touchedSpots.map((spot) {
                final index = spot.x.toInt();
                if (index >= 0 && index < sortedPrices.length) {
                  final price = sortedPrices[index];
                  return LineTooltipItem(
                    Formatters.formatCurrency(
                      price.value,
                      currency: selectedCurrency.toUpperCase(),
                    ),
                    TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.fontSize,
                    ),
                  );
                }
                return null;
              }).toList();
            },
          ),
        ),
      ),
    );
  }
}

/// Zaman aralığı butonu
class _TimeButton extends StatelessWidget {
  final String label;
  final int days;
  final bool selected;
  final VoidCallback onTap;

  const _TimeButton({
    required this.label,
    required this.days,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).dividerColor,
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: selected
                ? Colors.white
                : Theme.of(context).textTheme.bodyMedium?.color,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
