import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../core/ads/ad_load_state.dart';
import '../../../core/ads/banner_ad_service.dart';

class BannerAdScreen extends StatefulWidget {
  const BannerAdScreen({super.key});

  @override
  State<BannerAdScreen> createState() => _BannerAdScreenState();
}

class _BannerAdScreenState extends State<BannerAdScreen> {
  final BannerAdService _service = BannerAdService();
  AdLoadState _state = const AdLoadState(status: AdLoadStatus.idle);
  BannerAd? _bannerAd;

  Future<void> _loadAd() async {
    setState(() => _state = const AdLoadState(status: AdLoadStatus.loading));
    try {
      final width = MediaQuery.sizeOf(context).width.truncate();
      _bannerAd = await _service.loadAdaptiveBanner(
        width: width,
        onLoaded: () {
          if (mounted) {
            setState(
              () => _state = const AdLoadState(status: AdLoadStatus.loaded),
            );
          }
        },
        onFailed: (error) {
          if (mounted) {
            setState(
              () => _state = AdLoadState(
                status: AdLoadStatus.failed,
                message: error.message,
              ),
            );
          }
        },
      );
    } on Object catch (error) {
      if (mounted) {
        setState(
          () => _state = AdLoadState(
            status: AdLoadStatus.failed,
            message: '$error',
          ),
        );
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_state.status == AdLoadStatus.idle) _loadAd();
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ad = _bannerAd;
    return Scaffold(
      appBar: AppBar(title: const Text('Adaptive Banner')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Adaptive banner ad',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text(
              'The banner uses the current orientation and available screen width.',
            ),
            const Spacer(),
            Center(
              child: switch (_state.status) {
                AdLoadStatus.loading => const CircularProgressIndicator(),
                AdLoadStatus.loaded when ad != null => SizedBox(
                  width: ad.size.width.toDouble(),
                  height: ad.size.height.toDouble(),
                  child: AdWidget(ad: ad),
                ),
                AdLoadStatus.failed => _Failure(
                  message: _state.message,
                  onRetry: _loadAd,
                ),
                _ => const SizedBox.shrink(),
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Failure extends StatelessWidget {
  const _Failure({required this.message, required this.onRetry});

  final String? message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(message ?? 'Banner failed to load.', textAlign: TextAlign.center),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh),
          label: const Text('Retry'),
        ),
      ],
    );
  }
}
