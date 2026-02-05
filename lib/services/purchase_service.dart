import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../core/constants/app_constants.dart';

class PurchaseService extends ChangeNotifier {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  bool _isAvailable = false;
  bool _isPurchased = false;
  bool _isLoading = false;
  ProductDetails? _product;
  String? _error;

  bool get isAvailable => _isAvailable;
  bool get isPurchased => _isPurchased;
  bool get isLoading => _isLoading;
  ProductDetails? get product => _product;
  String? get error => _error;

  Function(bool)? onPurchaseComplete;

  Future<void> init() async {
    if (kIsWeb) {
      // In-app purchases not available on web
      _isAvailable = false;
      return;
    }

    _isAvailable = await _inAppPurchase.isAvailable();

    if (!_isAvailable) return;

    _subscription = _inAppPurchase.purchaseStream.listen(
      _onPurchaseUpdate,
      onDone: _onDone,
      onError: _onError,
    );

    await _loadProducts();
    await _restorePurchases();
  }

  Future<void> _loadProducts() async {
    final response = await _inAppPurchase.queryProductDetails({
      AppConstants.removeAdsProductId,
    });

    if (response.notFoundIDs.isNotEmpty) {
      debugPrint('Products not found: ${response.notFoundIDs}');
    }

    if (response.productDetails.isNotEmpty) {
      _product = response.productDetails.first;
      notifyListeners();
    }
  }

  Future<void> _restorePurchases() async {
    await _inAppPurchase.restorePurchases();
  }

  void _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) {
    for (final purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        _isLoading = true;
        notifyListeners();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          _error = purchaseDetails.error?.message;
          _isLoading = false;
          onPurchaseComplete?.call(false);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          _isPurchased = true;
          _isLoading = false;
          onPurchaseComplete?.call(true);
        }

        if (purchaseDetails.pendingCompletePurchase) {
          _inAppPurchase.completePurchase(purchaseDetails);
        }

        notifyListeners();
      }
    }
  }

  void _onDone() {
    _subscription?.cancel();
  }

  void _onError(dynamic error) {
    _error = error.toString();
    notifyListeners();
  }

  Future<bool> buyRemoveAds() async {
    if (!_isAvailable || _product == null || kIsWeb) {
      return false;
    }

    final purchaseParam = PurchaseParam(productDetails: _product!);

    try {
      final success = await _inAppPurchase.buyNonConsumable(
        purchaseParam: purchaseParam,
      );
      return success;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> restorePurchases() async {
    if (!_isAvailable || kIsWeb) return;
    await _inAppPurchase.restorePurchases();
  }

  void setPurchased(bool purchased) {
    _isPurchased = purchased;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
