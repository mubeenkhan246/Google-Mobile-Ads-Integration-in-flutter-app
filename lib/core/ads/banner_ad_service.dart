import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_helper.dart';

class BannerAdService {
  BannerAd? _bannerAd;

  BannerAd? get ad => _bannerAd;

  Future<BannerAd> loadAdaptiveBanner({
    required int width,
    required VoidCallback onLoaded,
    required void Function(LoadAdError error) onFailed,
  }) async {
    final size = await AdSize.getLargeAnchoredAdaptiveBannerAdSize(width);
    if (size == null) {
      throw StateError('Unable to resolve an adaptive banner size.');
    }

    _bannerAd?.dispose();
    final banner = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) => onLoaded(),
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          onFailed(error);
        },
      ),
    );

    _bannerAd = banner;
    await banner.load();
    return banner;
  }

  void dispose() {
    _bannerAd?.dispose();
    _bannerAd = null;
  }
}
