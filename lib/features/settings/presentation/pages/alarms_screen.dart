import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/config/app_colors.dart';
import '../providers/settings_providers.dart';
import '../../data/models/price_alarm_model.dart';
import '../../../crypto/presentation/pages/coin_detail_screen.dart';

/// Alarmlar ekranı
class AlarmsScreen extends ConsumerWidget {
  const AlarmsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alarmsAsync = ref.watch(alarmsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Fiyat Alarmlarım')),
      body: alarmsAsync.when(
        data: (alarms) {
          if (alarms.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_off,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Henüz alarm kurmadın',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Coin detay sayfasından fiyat alarmı kurabilirsin',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          // Aktif ve pasif alarmları ayır
          final activeAlarms = alarms.where((a) => a.isActive).toList();
          final inactiveAlarms = alarms.where((a) => !a.isActive).toList();

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(alarmsProvider);
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (activeAlarms.isNotEmpty) ...[
                  Text(
                    'Aktif Alarmlar',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...activeAlarms.map(
                    (alarm) => _AlarmCard(
                      alarm: alarm,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CoinDetailScreen(coinId: alarm.coinId),
                          ),
                        );
                      },
                      onToggle: () async {
                        final box = await ref.read(alarmsBoxProvider.future);
                        final key = box.keys.firstWhere(
                          (key) => box.get(key)?.id == alarm.id,
                          orElse: () => null,
                        );
                        if (key != null) {
                          alarm.isActive = !alarm.isActive;
                          await box.put(key, alarm);
                          ref.invalidate(alarmsProvider);
                        }
                      },
                      onDelete: () async {
                        final box = await ref.read(alarmsBoxProvider.future);
                        final key = box.keys.firstWhere(
                          (key) => box.get(key)?.id == alarm.id,
                          orElse: () => null,
                        );
                        if (key != null) {
                          await box.delete(key);
                          ref.invalidate(alarmsProvider);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Alarm silindi')),
                            );
                          }
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
                if (inactiveAlarms.isNotEmpty) ...[
                  Text(
                    'Pasif Alarmlar',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...inactiveAlarms.map(
                    (alarm) => _AlarmCard(
                      alarm: alarm,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CoinDetailScreen(coinId: alarm.coinId),
                          ),
                        );
                      },
                      onToggle: () async {
                        final box = await ref.read(alarmsBoxProvider.future);
                        final key = box.keys.firstWhere(
                          (key) => box.get(key)?.id == alarm.id,
                          orElse: () => null,
                        );
                        if (key != null) {
                          alarm.isActive = !alarm.isActive;
                          await box.put(key, alarm);
                          ref.invalidate(alarmsProvider);
                        }
                      },
                      onDelete: () async {
                        final box = await ref.read(alarmsBoxProvider.future);
                        final key = box.keys.firstWhere(
                          (key) => box.get(key)?.id == alarm.id,
                          orElse: () => null,
                        );
                        if (key != null) {
                          await box.delete(key);
                          ref.invalidate(alarmsProvider);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Alarm silindi')),
                            );
                          }
                        }
                      },
                    ),
                  ),
                ],
              ],
            ),
          );
        },
        loading: () => const LoadingIndicator(),
        error: (error, stack) => ErrorDisplay(
          message: error.toString(),
          onRetry: () {
            ref.invalidate(alarmsProvider);
          },
        ),
      ),
    );
  }
}

class _AlarmCard extends StatelessWidget {
  final PriceAlarmModel alarm;
  final VoidCallback onTap;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const _AlarmCard({
    required this.alarm,
    required this.onTap,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Coin info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          alarm.coinName,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          alarm.coinSymbol.toUpperCase(),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          alarm.isAbove
                              ? Icons.trending_up
                              : Icons.trending_down,
                          size: 16,
                          color: alarm.isAbove
                              ? AppColors.positive
                              : AppColors.negative,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          alarm.isAbove ? 'Yukarı kırınca' : 'Aşağı kırınca',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Hedef: ${Formatters.formatCurrency(alarm.targetPrice, currency: 'TRY')}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              // Actions
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      alarm.isActive
                          ? Icons.notifications_active
                          : Icons.notifications_off,
                      color: alarm.isActive
                          ? AppColors.positive
                          : AppColors.darkTextSecondary,
                    ),
                    onPressed: onToggle,
                    tooltip: alarm.isActive ? 'Pasifleştir' : 'Aktifleştir',
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    color: AppColors.negative,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Alarmı Sil'),
                          content: const Text(
                            'Bu alarmı silmek istediğinize emin misiniz?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('İptal'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                onDelete();
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
                    tooltip: 'Sil',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
