import 'dart:io';

class AdHelper {
  const AdHelper._();

  static String get bannerAdUnitId {
    if (Platform.isAndroid) return 'ca-app-pub-3940256099942544/6300978111';
    if (Platform.isIOS) return 'ca-app-pub-3940256099942544/2934735716';
    throw UnsupportedError('Banner ads are only supported on Android and iOS.');
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) return 'ca-app-pub-3940256099942544/1033173712';
    if (Platform.isIOS) return 'ca-app-pub-3940256099942544/4411468910';
    throw UnsupportedError(
      'Interstitial ads are only supported on Android and iOS.',
    );
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) return 'ca-app-pub-3940256099942544/5224354917';
    if (Platform.isIOS) return 'ca-app-pub-3940256099942544/1712485313';
    throw UnsupportedError(
      'Rewarded ads are only supported on Android and iOS.',
    );
  }

  static String get nativeAdUnitId {
    if (Platform.isAndroid) return 'ca-app-pub-3940256099942544/2247696110';
    if (Platform.isIOS) return 'ca-app-pub-3940256099942544/3986624511';
    throw UnsupportedError('Native ads are only supported on Android and iOS.');
  }
}
