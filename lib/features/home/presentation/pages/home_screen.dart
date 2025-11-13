import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../crypto/presentation/pages/market_screen.dart';
import '../../../crypto/presentation/pages/favorites_screen.dart';
import '../../../fiat/presentation/pages/fiat_screen.dart';
import '../../../portfolio/presentation/pages/portfolio_screen.dart';
import '../../../settings/presentation/pages/alarms_screen.dart';

/// Ana ekran (bottom navigation ile)
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const MarketScreen(),
    const FiatScreen(),
    const PortfolioScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: 'Market',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.currency_exchange),
            label: 'Döviz',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.wallet), label: 'Portföy'),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'favorites',
            mini: true,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoritesScreen(),
                ),
              );
            },
            child: const Icon(Icons.favorite),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'alarms',
            mini: true,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AlarmsScreen()),
              );
            },
            child: const Icon(Icons.notifications),
          ),
        ],
      ),
    );
  }
}
