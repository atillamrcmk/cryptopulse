import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/app_constants.dart';
import '../providers/settings_providers.dart';

/// Ayarlar ekranı
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Ayarlar')),
      body: ListView(
        children: [
          // Theme section
          _SettingsSection(
            title: 'Görünüm',
            children: [
              ListTile(
                title: const Text('Tema'),
                subtitle: Text(_getThemeLabel(settings.theme)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showThemeDialog(context, ref),
              ),
            ],
          ),
          // Language section
          _SettingsSection(
            title: 'Dil',
            children: [
              ListTile(
                title: const Text('Dil'),
                subtitle: Text(_getLanguageLabel(settings.language)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showLanguageDialog(context, ref),
              ),
            ],
          ),
          // Currency section
          _SettingsSection(
            title: 'Para Birimi',
            children: [
              ListTile(
                title: const Text('Varsayılan Para Birimi'),
                subtitle: Text(settings.defaultFiatCurrency),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showCurrencyDialog(context, ref),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getThemeLabel(String theme) {
    switch (theme) {
      case 'dark':
        return 'Koyu';
      case 'light':
        return 'Açık';
      case 'system':
        return 'Sistem';
      default:
        return theme;
    }
  }

  String _getLanguageLabel(String language) {
    switch (language) {
      case 'tr':
        return 'Türkçe';
      case 'en':
        return 'English';
      default:
        return language;
    }
  }

  Future<void> _showThemeDialog(BuildContext context, WidgetRef ref) async {
    final settings = ref.read(settingsProvider);
    final selected = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tema Seç'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Koyu'),
              value: 'dark',
              groupValue: settings.theme,
              onChanged: (value) => Navigator.pop(context, value),
            ),
            RadioListTile<String>(
              title: const Text('Açık'),
              value: 'light',
              groupValue: settings.theme,
              onChanged: (value) => Navigator.pop(context, value),
            ),
            RadioListTile<String>(
              title: const Text('Sistem'),
              value: 'system',
              groupValue: settings.theme,
              onChanged: (value) => Navigator.pop(context, value),
            ),
          ],
        ),
      ),
    );

    if (selected != null) {
      await ref.read(settingsProvider.notifier).updateTheme(selected);
    }
  }

  Future<void> _showLanguageDialog(BuildContext context, WidgetRef ref) async {
    final settings = ref.read(settingsProvider);
    final selected = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Dil Seç'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Türkçe'),
              value: 'tr',
              groupValue: settings.language,
              onChanged: (value) => Navigator.pop(context, value),
            ),
            RadioListTile<String>(
              title: const Text('English'),
              value: 'en',
              groupValue: settings.language,
              onChanged: (value) => Navigator.pop(context, value),
            ),
          ],
        ),
      ),
    );

    if (selected != null) {
      await ref.read(settingsProvider.notifier).updateLanguage(selected);
    }
  }

  Future<void> _showCurrencyDialog(BuildContext context, WidgetRef ref) async {
    final settings = ref.read(settingsProvider);
    final selected = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Para Birimi Seç'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: AppConstants.supportedFiatCurrencies
              .map(
                (currency) => RadioListTile<String>(
                  title: Text(currency),
                  value: currency,
                  groupValue: settings.defaultFiatCurrency,
                  onChanged: (value) => Navigator.pop(context, value),
                ),
              )
              .toList(),
        ),
      ),
    );

    if (selected != null) {
      await ref
          .read(settingsProvider.notifier)
          .updateDefaultFiatCurrency(selected);
    }
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        ...children,
      ],
    );
  }
}
