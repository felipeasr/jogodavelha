import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../core/constants/app_constants.dart';

class AdService extends ChangeNotifier {
  RewardedAd? _rewardedAd;
  bool _isRewardedReady = false;
  bool _adsRemoved = false;

  bool get isRewardedReady => _isRewardedReady;
  bool get adsRemoved => _adsRemoved;

  String get _bannerAdUnitId =>
      kIsWeb ? AppConstants.bannerAdUnitIdWeb : AppConstants.bannerAdUnitIdAndroid;

  String get _rewardedAdUnitId =>
      kIsWeb ? AppConstants.rewardedAdUnitIdWeb : AppConstants.rewardedAdUnitIdAndroid;

  Future<void> init() async {
    if (kIsWeb) {
      return;
    }
    await MobileAds.instance.initialize();
    loadRewardedAd();
  }

  void setAdsRemoved(bool removed) {
    _adsRemoved = removed;
    notifyListeners();
  }

  BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: _bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('Banner ad loaded');
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('Banner ad failed to load: $error');
          ad.dispose();
        },
      ),
    );
  }

  void loadRewardedAd() {
    if (kIsWeb) return;

    RewardedAd.load(
      adUnitId: _rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isRewardedReady = true;
          notifyListeners();

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _isRewardedReady = false;
              loadRewardedAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _isRewardedReady = false;
              loadRewardedAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint('Rewarded ad failed to load: $error');
          _isRewardedReady = false;
        },
      ),
    );
  }

  Future<bool> showRewardedAd(Function onRewarded) async {
    if (!_isRewardedReady || _rewardedAd == null) return false;

    await _rewardedAd!.show(
      onUserEarnedReward: (ad, reward) {
        onRewarded();
      },
    );

    _rewardedAd = null;
    _isRewardedReady = false;
    return true;
  }

  void dispose() {
    _rewardedAd?.dispose();
    super.dispose();
  }
}
