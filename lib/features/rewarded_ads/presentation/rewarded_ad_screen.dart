import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../core/ads/ad_load_state.dart';
import '../../../core/ads/rewarded_ad_service.dart';

class RewardedAdScreen extends StatefulWidget {
  const RewardedAdScreen({super.key});

  @override
  State<RewardedAdScreen> createState() => _RewardedAdScreenState();
}

class _RewardedAdScreenState extends State<RewardedAdScreen> {
  final RewardedAdService _service = RewardedAdService();
  AdLoadState _state = const AdLoadState(status: AdLoadStatus.idle);
  int _coins = 0;

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
      onRewarded: _handleReward,
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

  void _handleReward(RewardItem reward) {
    setState(() => _coins += reward.amount.toInt());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Reward earned: ${reward.amount} ${reward.type}')),
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
      appBar: AppBar(title: const Text('Rewarded Video Ad')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.workspace_premium,
                size: 56,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Coins: $_coins',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(_statusText, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _state.isLoaded ? _showAd : null,
                icon: const Icon(Icons.ondemand_video),
                label: const Text('Watch for reward'),
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
    AdLoadStatus.loading => 'Loading a rewarded video ad...',
    AdLoadStatus.loaded => 'Rewarded ad loaded and ready.',
    AdLoadStatus.failed => _state.message ?? 'Rewarded ad failed to load.',
    AdLoadStatus.idle => 'Preparing ad.',
  };
}
