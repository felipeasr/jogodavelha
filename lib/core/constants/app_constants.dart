class AppConstants {
  // AdMob IDs (Test IDs - Replace with real IDs for production)
  static const String bannerAdUnitIdAndroid =
      'ca-app-pub-8176879609037766/4064154778';
  static const String rewardedAdUnitIdAndroid =
      'ca-app-pub-8176879609037766/9628646108';

  // Web uses test IDs as well
  static const String bannerAdUnitIdWeb =
      'ca-app-pub-8176879609037766/4064154778';
  static const String rewardedAdUnitIdWeb =
      'ca-app-pub-8176879609037766/9628646108';

  // In-App Purchase Product IDs
  static const String removeAdsProductId = 'remove_ads';

  // Prices
  static const String priceBRL = 'R\$ 19,90';
  static const String priceUSD = '\$ 3.99';

  // Game Settings
  static const int boardSize = 3;
  static const int botThinkingDelayMs = 1500;
  static const int onlineSearchDelayMs = 3000;

  // Storage Keys
  static const String keyLanguage = 'language';
  static const String keySoundEnabled = 'sound_enabled';
  static const String keyAdsRemoved = 'ads_removed';
  static const String keyHighScore = 'high_score';

  // Bot Names for Online Mode
  static const List<String> botNames = [
    'Alpha Bot',
    'Master X',
    'Pro Player',
    'Champion',
    'Ninja Bot',
    'Speed Master',
    'TicTac Pro',
    'Game Master',
    'Bot Legend',
    'Smart AI',
  ];
}
