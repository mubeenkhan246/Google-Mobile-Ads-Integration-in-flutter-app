import 'package:flutter_test/flutter_test.dart';
import 'package:google_mobile_ads_app/app.dart';

void main() {
  testWidgets('Home screen lists ad formats', (WidgetTester tester) async {
    await tester.pumpWidget(const GoogleMobileAdsIntegrationApp());

    expect(find.text('Google Mobile Ads'), findsOneWidget);
    expect(find.text('Banner Ads'), findsOneWidget);
    expect(find.text('Interstitial Ads'), findsOneWidget);
    expect(find.text('Rewarded Video Ads'), findsOneWidget);
    expect(find.text('Native Ads'), findsOneWidget);
  });
}
