# Google Mobile Ads Integration in flutter app

A production-ready Flutter sample for integrating Google Mobile Ads with a clean, feature-based architecture. The app supports Android and iOS and includes Banner, Interstitial, Rewarded Video, and Native Ads using official test ad unit IDs.

## Features

- Material 3 UI with system light/dark mode.
- Home screen with navigation cards for every ad format.
- Adaptive banner ad loading with graceful failure handling.
- Interstitial and rewarded full-screen ad lifecycle management.
- Native ad rendering through Android and iOS native factories.
- Reusable ad services for feature screens.
- Analytics-ready abstraction for future Firebase Analytics integration.
- Flutter lints, smoke test, and documented setup.

## Installation

```bash
flutter pub get
flutter analyze
flutter test
flutter run
```

The project uses `google_mobile_ads: ^8.0.0`.

## Android setup

The Android test AdMob app ID is already configured in:

```xml
android/app/src/main/AndroidManifest.xml
```

```xml
<meta-data
    android:name="com.google.android.gms.ads.APPLICATION_ID"
    android:value="ca-app-pub-3940256099942544~3347511713"/>
```

Native ads are registered in `MainActivity.kt` with factory ID `listTile`, backed by `ListTileNativeAdFactory.kt` and `res/layout/list_tile_native_ad.xml`.

## iOS setup

The iOS test AdMob app ID is already configured in:

```xml
ios/Runner/Info.plist
```

```xml
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-3940256099942544~1458002511</string>
```

Native ads are registered in `AppDelegate.swift` with factory ID `listTile`.

For a fresh iOS install:

```bash
cd ios
pod install
cd ..
flutter run
```

## AdMob setup

1. Create or open your AdMob account.
2. Add your Android and iOS apps.
3. Create ad units for Banner, Interstitial, Rewarded, and Native formats.
4. Keep test IDs during development.
5. Replace test IDs only before production release.

## Test ad units

| Format | Android | iOS |
| --- | --- | --- |
| Banner | `ca-app-pub-3940256099942544/6300978111` | `ca-app-pub-3940256099942544/2934735716` |
| Interstitial | `ca-app-pub-3940256099942544/1033173712` | `ca-app-pub-3940256099942544/4411468910` |
| Rewarded | `ca-app-pub-3940256099942544/5224354917` | `ca-app-pub-3940256099942544/1712485313` |
| Native | `ca-app-pub-3940256099942544/2247696110` | `ca-app-pub-3940256099942544/3986624511` |

## Folder structure

```text
lib/
  app.dart
  main.dart
  core/
    ads/
      ad_helper.dart
      ad_load_state.dart
      banner_ad_service.dart
      interstitial_ad_service.dart
      native_ad_service.dart
      rewarded_ad_service.dart
    analytics/
      analytics_event.dart
      analytics_locator.dart
      analytics_service.dart
    theme/
      app_theme.dart
  features/
    home/presentation/home_screen.dart
    banner_ads/presentation/banner_ad_screen.dart
    interstitial_ads/presentation/interstitial_ad_screen.dart
    rewarded_ads/presentation/rewarded_ad_screen.dart
    native_ads/presentation/native_ad_screen.dart
```

## Usage examples

Load and show an interstitial ad:

```dart
final service = InterstitialAdService();

service.load(
  onLoaded: () => service.show(
    onDismissed: () => service.load(...),
    onFailedToShow: (error) {},
  ),
  onFailed: (error) {},
);
```

Render an adaptive banner:

```dart
final banner = await BannerAdService().loadAdaptiveBanner(
  width: MediaQuery.sizeOf(context).width.truncate(),
  onLoaded: () {},
  onFailed: (error) {},
);
```

## Production ad unit replacement guide

Replace all test ad unit IDs in:

```text
lib/core/ads/ad_helper.dart
```

Replace the Android app ID in:

```text
android/app/src/main/AndroidManifest.xml
```

Replace the iOS app ID in:

```text
ios/Runner/Info.plist
```

Do not ship production ad IDs until your app is approved and test mode has been fully removed from release builds.

## Screenshots

<p align="center">
  <img src="screenshots/Simulator%20Screenshot%20-%20iPhone%2017%20Pro%20Max%20-%202026-06-04%20at%2014.23.32.png" width="30%" alt="Home Screen"/>
  <img src="screenshots/Simulator%20Screenshot%20-%20iPhone%2017%20Pro%20Max%20-%202026-06-04%20at%2014.23.42.png" width="30%" alt="Banner Ad"/>
  <img src="screenshots/Simulator%20Screenshot%20-%20iPhone%2017%20Pro%20Max%20-%202026-06-04%20at%2014.23.50.png" width="30%" alt="Interstitial Ad"/>
</p>

<p align="center">
  <img src="screenshots/Simulator%20Screenshot%20-%20iPhone%2017%20Pro%20Max%20-%202026-06-04%20at%2014.24.03.png" width="30%" alt="Rewarded Ad"/>
  <img src="screenshots/Simulator%20Screenshot%20-%20iPhone%2017%20Pro%20Max%20-%202026-06-04%20at%2014.24.09.png" width="30%" alt="Native Ad"/>
</p>
