import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_helper.dart';

class NativeAdService {
  NativeAd? _nativeAd;

  NativeAd? get ad => _nativeAd;

  NativeAd load({
    required VoidCallback onLoaded,
    required void Function(LoadAdError error) onFailed,
  }) {
    dispose();
    final nativeAd = NativeAd(
      adUnitId: AdHelper.nativeAdUnitId,
      factoryId: 'listTile',
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (_) => onLoaded(),
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          onFailed(error);
        },
      ),
    );
    _nativeAd = nativeAd;
    nativeAd.load();
    return nativeAd;
  }

  void dispose() {
    _nativeAd?.dispose();
    _nativeAd = null;
  }
}
