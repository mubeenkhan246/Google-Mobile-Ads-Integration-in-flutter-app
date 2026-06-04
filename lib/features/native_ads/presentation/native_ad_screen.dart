import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../core/ads/ad_load_state.dart';
import '../../../core/ads/native_ad_service.dart';

class NativeAdScreen extends StatefulWidget {
  const NativeAdScreen({super.key});

  @override
  State<NativeAdScreen> createState() => _NativeAdScreenState();
}

class _NativeAdScreenState extends State<NativeAdScreen> {
  final NativeAdService _service = NativeAdService();
  AdLoadState _state = const AdLoadState(status: AdLoadStatus.idle);
  NativeAd? _nativeAd;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    setState(() => _state = const AdLoadState(status: AdLoadStatus.loading));
    _nativeAd = _service.load(
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

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ad = _nativeAd;
    return Scaffold(
      appBar: AppBar(title: const Text('Native Ad')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Native ad layout',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          const Text(
            'This screen renders a platform native ad factory named listTile.',
          ),
          const SizedBox(height: 24),
          switch (_state.status) {
            AdLoadStatus.loading => const Center(
              child: CircularProgressIndicator(),
            ),
            AdLoadStatus.loaded when ad != null => SizedBox(
              height: 150,
              child: AdWidget(ad: ad),
            ),
            AdLoadStatus.failed => Column(
              children: [
                Text(
                  _state.message ?? 'Native ad failed to load.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: _loadAd,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
            _ => const SizedBox.shrink(),
          },
        ],
      ),
    );
  }
}
