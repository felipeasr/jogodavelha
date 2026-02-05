import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'services/storage_service.dart';
import 'screens/home_screen.dart';

class JogoDaVelhaApp extends StatelessWidget {
  const JogoDaVelhaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final storageService = context.watch<StorageService>();

    return MaterialApp(
      title: 'Jogo da Velha',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      locale: storageService.locale,
      supportedLocales: const [
        Locale('pt'),
        Locale('en'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const HomeScreen(),
    );
  }
}
