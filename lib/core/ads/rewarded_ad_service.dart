import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_helper.dart';

class RewardedAdService {
  RewardedAd? _ad;

  bool get isReady => _ad != null;

  void load({
    required void Function() onLoaded,
    required void Function(LoadAdError error) onFailed,
  }) {
    dispose();
    RewardedAd.load(
      adUnitId: AdHelper.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _ad = ad;
          onLoaded();
        },
        onAdFailedToLoad: onFailed,
      ),
    );
  }

  void show({
    required void Function(RewardItem reward) onRewarded,
    required void Function() onDismissed,
    required void Function(AdError error) onFailedToShow,
  }) {
    final ad = _ad;
    if (ad == null) return;
    _ad = null;
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        onDismissed();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        onFailedToShow(error);
      },
    );
    ad.show(onUserEarnedReward: (_, reward) => onRewarded(reward));
  }

  void dispose() {
    _ad?.dispose();
    _ad = null;
  }
}
