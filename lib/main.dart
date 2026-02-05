import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'services/storage_service.dart';
import 'services/ad_service.dart';
import 'services/purchase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storageService = StorageService();
  await storageService.init();

  final adService = AdService();
  if (!kIsWeb) {
    await adService.init();
  }

  final purchaseService = PurchaseService();
  await purchaseService.init();

  // Sync ads removed state
  if (storageService.adsRemoved) {
    adService.setAdsRemoved(true);
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: storageService),
        ChangeNotifierProvider.value(value: adService),
        ChangeNotifierProvider.value(value: purchaseService),
      ],
      child: const JogoDaVelhaApp(),
    ),
  );
}
