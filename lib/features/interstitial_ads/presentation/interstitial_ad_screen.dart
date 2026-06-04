import 'package:flutter/material.dart';

import '../../../core/ads/ad_load_state.dart';
import '../../../core/ads/interstitial_ad_service.dart';

class InterstitialAdScreen extends StatefulWidget {
  const InterstitialAdScreen({super.key});

  @override
  State<InterstitialAdScreen> createState() => _InterstitialAdScreenState();
}

class _InterstitialAdScreenState extends State<InterstitialAdScreen> {
  final InterstitialAdService _service = InterstitialAdService();
  AdLoadState _state = const AdLoadState(status: AdLoadStatus.idle);

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    setState(() => _state = const AdLoadState(status: AdLoadStatus.loading));
    _service.load(
      onLoaded: () => mounted
          ? setState(
              () => _state = const AdLoadState(status: AdLoadStatus.loaded),
            )
          : null,
      onFailed: (error) => mounted
          ? setState(
              () => _state = AdLoadState(
                status: AdLoadStatus.failed,
                message: error.message,
              ),
            )
          : null,
    );
  }

  void _showAd() {
    _service.show(
      onDismissed: _loadAd,
      onFailedToShow: (error) {
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
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Interstitial Ad')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.fullscreen,
                size: 56,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Interstitial placement',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(_statusText, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _state.isLoaded ? _showAd : null,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Show interstitial'),
              ),
              const SizedBox(height: 12),
              if (_state.isLoading) const CircularProgressIndicator(),
              if (_state.status == AdLoadStatus.failed)
                OutlinedButton.icon(
                  onPressed: _loadAd,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String get _statusText => switch (_state.status) {
    AdLoadStatus.loading => 'Loading an interstitial ad...',
    AdLoadStatus.loaded => 'Ad loaded and ready to show.',
    AdLoadStatus.failed => _state.message ?? 'Interstitial failed to load.',
    AdLoadStatus.idle => 'Preparing ad.',
  };
}
