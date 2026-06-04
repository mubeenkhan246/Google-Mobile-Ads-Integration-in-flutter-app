import 'package:flutter/material.dart';

import '../../../core/analytics/analytics_event.dart';
import '../../../core/analytics/analytics_locator.dart';
import '../../banner_ads/presentation/banner_ad_screen.dart';
import '../../interstitial_ads/presentation/interstitial_ad_screen.dart';
import '../../native_ads/presentation/native_ad_screen.dart';
import '../../rewarded_ads/presentation/rewarded_ad_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _items = <_HomeItem>[
    _HomeItem(
      'Banner Ads',
      'Adaptive banner anchored to the screen width.',
      Icons.web_asset,
      BannerAdScreen(),
    ),
    _HomeItem(
      'Interstitial Ads',
      'Load and show a full-screen placement.',
      Icons.fullscreen,
      InterstitialAdScreen(),
    ),
    _HomeItem(
      'Rewarded Video Ads',
      'Reward users after they finish the ad.',
      Icons.workspace_premium,
      RewardedAdScreen(),
    ),
    _HomeItem(
      'Native Ads',
      'Render a platform native ad layout.',
      Icons.view_list,
      NativeAdScreen(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Google Mobile Ads')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Google Mobile Ads Integration in flutter app',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            'Production-ready sample using test ad units, clean services, and Material 3.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 20),
          for (final item in _items) ...[
            _NavigationCard(item: item),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _NavigationCard extends StatelessWidget {
  const _NavigationCard({required this.item});

  final _HomeItem item;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        minVerticalPadding: 18,
        leading: Icon(item.icon, color: Theme.of(context).colorScheme.primary),
        title: Text(
          item.title,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Text(item.description),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          AnalyticsLocator.instance.track(
            AnalyticsEvent(
              'open_${item.title.toLowerCase().replaceAll(' ', '_')}',
            ),
          );
          Navigator.of(
            context,
          ).push(MaterialPageRoute<void>(builder: (_) => item.screen));
        },
      ),
    );
  }
}

class _HomeItem {
  const _HomeItem(this.title, this.description, this.icon, this.screen);

  final String title;
  final String description;
  final IconData icon;
  final Widget screen;
}
