import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/home/presentation/home_screen.dart';

class GoogleMobileAdsIntegrationApp extends StatelessWidget {
  const GoogleMobileAdsIntegrationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Google Mobile Ads Integration in flutter app',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}
