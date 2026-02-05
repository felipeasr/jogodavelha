import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_theme.dart';
import '../core/constants/app_constants.dart';
import '../services/purchase_service.dart';
import '../services/storage_service.dart';
import '../services/ad_service.dart';

class StoreScreen extends StatefulWidget {
  final bool showAppBar;

  const StoreScreen({super.key, this.showAppBar = false});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  @override
  void initState() {
    super.initState();
    final purchaseService = context.read<PurchaseService>();
    purchaseService.onPurchaseComplete = _onPurchaseComplete;
  }

  void _onPurchaseComplete(bool success) {
    final l10n = AppLocalizations.of(context)!;
    final storageService = context.read<StorageService>();
    final adService = context.read<AdService>();

    if (success) {
      storageService.setAdsRemoved(true);
      adService.setAdsRemoved(true);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.purchaseSuccess),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.purchaseError),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final storageService = context.watch<StorageService>();
    final purchaseService = context.watch<PurchaseService>();

    return Scaffold(
      appBar: widget.showAppBar ? AppBar(title: Text(l10n.store)) : null,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!widget.showAppBar) ...[
                Padding(
                  padding: const EdgeInsets.only(bottom: 24, top: 16),
                  child: Text(
                    l10n.store,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
              _buildRemoveAdsCard(
                context,
                l10n,
                storageService,
                purchaseService,
              ),
              const SizedBox(height: 20),
              if (!storageService.adsRemoved)
                Center(
                  child: TextButton.icon(
                    onPressed: () {
                      purchaseService.restorePurchases();
                    },
                    icon: const Icon(Icons.restore),
                    label: Text(l10n.restorePurchases),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRemoveAdsCard(
    BuildContext context,
    AppLocalizations l10n,
    StorageService storageService,
    PurchaseService purchaseService,
  ) {
    final isPurchased = storageService.adsRemoved || purchaseService.isPurchased;
    final price = storageService.locale.languageCode == 'pt'
        ? AppConstants.priceBRL
        : AppConstants.priceUSD;

    return Card(
      elevation: 4,
      shadowColor: AppTheme.primaryColor.withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: [
              Colors.white,
              isPurchased
                  ? Colors.green.withValues(alpha: 0.05)
                  : AppTheme.primaryColor.withValues(alpha: 0.05),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isPurchased
                      ? Colors.green.withValues(alpha: 0.1)
                      : AppTheme.primaryColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: (isPurchased ? Colors.green : AppTheme.primaryColor)
                          .withValues(alpha: 0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(
                  isPurchased ? Icons.check_circle_outline : Icons.block_outlined,
                  size: 56,
                  color: isPurchased ? Colors.green : AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.removeAds,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.removeAdsDesc,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              if (isPurchased)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green, size: 24),
                      const SizedBox(width: 10),
                      Text(
                        l10n.purchased,
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                )
              else
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: purchaseService.isLoading
                        ? null
                        : () {
                            purchaseService.buyRemoveAds();
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      shadowColor: AppTheme.primaryColor.withValues(alpha: 0.4),
                    ),
                    child: purchaseService.isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.shopping_cart_outlined),
                              const SizedBox(width: 10),
                              Text(
                                '${l10n.buy} - $price',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
