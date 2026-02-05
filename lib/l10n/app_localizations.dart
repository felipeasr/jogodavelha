import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In pt, this message translates to:
  /// **'Jogo da Velha'**
  String get appTitle;

  /// No description provided for @play.
  ///
  /// In pt, this message translates to:
  /// **'Jogar'**
  String get play;

  /// No description provided for @settings.
  ///
  /// In pt, this message translates to:
  /// **'Configurações'**
  String get settings;

  /// No description provided for @store.
  ///
  /// In pt, this message translates to:
  /// **'Loja'**
  String get store;

  /// No description provided for @localGame.
  ///
  /// In pt, this message translates to:
  /// **'Jogo Local'**
  String get localGame;

  /// No description provided for @onlineGame.
  ///
  /// In pt, this message translates to:
  /// **'Jogo Online'**
  String get onlineGame;

  /// No description provided for @localGameDesc.
  ///
  /// In pt, this message translates to:
  /// **'Jogue com um amigo'**
  String get localGameDesc;

  /// No description provided for @onlineGameDesc.
  ///
  /// In pt, this message translates to:
  /// **'Jogue contra o computador'**
  String get onlineGameDesc;

  /// No description provided for @selectDifficulty.
  ///
  /// In pt, this message translates to:
  /// **'Selecione a Dificuldade'**
  String get selectDifficulty;

  /// No description provided for @normal.
  ///
  /// In pt, this message translates to:
  /// **'Normal'**
  String get normal;

  /// No description provided for @hard.
  ///
  /// In pt, this message translates to:
  /// **'Difícil'**
  String get hard;

  /// No description provided for @normalDesc.
  ///
  /// In pt, this message translates to:
  /// **'IA com jogadas básicas'**
  String get normalDesc;

  /// No description provided for @hardDesc.
  ///
  /// In pt, this message translates to:
  /// **'IA invencível (Minimax)'**
  String get hardDesc;

  /// No description provided for @startGame.
  ///
  /// In pt, this message translates to:
  /// **'Iniciar Jogo'**
  String get startGame;

  /// No description provided for @playerX.
  ///
  /// In pt, this message translates to:
  /// **'Jogador X'**
  String get playerX;

  /// No description provided for @playerO.
  ///
  /// In pt, this message translates to:
  /// **'Jogador O'**
  String get playerO;

  /// No description provided for @yourTurn.
  ///
  /// In pt, this message translates to:
  /// **'Sua vez'**
  String get yourTurn;

  /// No description provided for @opponentTurn.
  ///
  /// In pt, this message translates to:
  /// **'Vez do oponente'**
  String get opponentTurn;

  /// No description provided for @thinking.
  ///
  /// In pt, this message translates to:
  /// **'Pensando...'**
  String get thinking;

  /// No description provided for @youWin.
  ///
  /// In pt, this message translates to:
  /// **'Você Venceu!'**
  String get youWin;

  /// No description provided for @youLose.
  ///
  /// In pt, this message translates to:
  /// **'Você Perdeu!'**
  String get youLose;

  /// No description provided for @draw.
  ///
  /// In pt, this message translates to:
  /// **'Empate!'**
  String get draw;

  /// No description provided for @playerXWins.
  ///
  /// In pt, this message translates to:
  /// **'Jogador X Venceu!'**
  String get playerXWins;

  /// No description provided for @playerOWins.
  ///
  /// In pt, this message translates to:
  /// **'Jogador O Venceu!'**
  String get playerOWins;

  /// No description provided for @playAgain.
  ///
  /// In pt, this message translates to:
  /// **'Jogar Novamente'**
  String get playAgain;

  /// No description provided for @backToMenu.
  ///
  /// In pt, this message translates to:
  /// **'Voltar ao Menu'**
  String get backToMenu;

  /// No description provided for @hint.
  ///
  /// In pt, this message translates to:
  /// **'Dica'**
  String get hint;

  /// No description provided for @watchAdForHint.
  ///
  /// In pt, this message translates to:
  /// **'Assista um anúncio para receber uma dica'**
  String get watchAdForHint;

  /// No description provided for @watch.
  ///
  /// In pt, this message translates to:
  /// **'Assistir'**
  String get watch;

  /// No description provided for @cancel.
  ///
  /// In pt, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @language.
  ///
  /// In pt, this message translates to:
  /// **'Idioma'**
  String get language;

  /// No description provided for @portuguese.
  ///
  /// In pt, this message translates to:
  /// **'Português'**
  String get portuguese;

  /// No description provided for @english.
  ///
  /// In pt, this message translates to:
  /// **'Inglês'**
  String get english;

  /// No description provided for @sound.
  ///
  /// In pt, this message translates to:
  /// **'Som'**
  String get sound;

  /// No description provided for @on.
  ///
  /// In pt, this message translates to:
  /// **'Ligado'**
  String get on;

  /// No description provided for @off.
  ///
  /// In pt, this message translates to:
  /// **'Desligado'**
  String get off;

  /// No description provided for @removeAds.
  ///
  /// In pt, this message translates to:
  /// **'Remover Anúncios'**
  String get removeAds;

  /// No description provided for @removeAdsDesc.
  ///
  /// In pt, this message translates to:
  /// **'Remova todos os anúncios do jogo'**
  String get removeAdsDesc;

  /// No description provided for @price.
  ///
  /// In pt, this message translates to:
  /// **'R\$ 19,90'**
  String get price;

  /// No description provided for @buy.
  ///
  /// In pt, this message translates to:
  /// **'Comprar'**
  String get buy;

  /// No description provided for @purchased.
  ///
  /// In pt, this message translates to:
  /// **'Comprado'**
  String get purchased;

  /// No description provided for @restorePurchases.
  ///
  /// In pt, this message translates to:
  /// **'Restaurar Compras'**
  String get restorePurchases;

  /// No description provided for @purchaseSuccess.
  ///
  /// In pt, this message translates to:
  /// **'Compra realizada com sucesso!'**
  String get purchaseSuccess;

  /// No description provided for @purchaseError.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao realizar compra'**
  String get purchaseError;

  /// No description provided for @searchingOpponent.
  ///
  /// In pt, this message translates to:
  /// **'Procurando oponente...'**
  String get searchingOpponent;

  /// No description provided for @opponentFound.
  ///
  /// In pt, this message translates to:
  /// **'Oponente encontrado!'**
  String get opponentFound;

  /// No description provided for @connected.
  ///
  /// In pt, this message translates to:
  /// **'Conectado'**
  String get connected;

  /// No description provided for @round.
  ///
  /// In pt, this message translates to:
  /// **'Rodada'**
  String get round;

  /// No description provided for @score.
  ///
  /// In pt, this message translates to:
  /// **'Placar'**
  String get score;

  /// No description provided for @vs.
  ///
  /// In pt, this message translates to:
  /// **'vs'**
  String get vs;

  /// No description provided for @privacyPolicy.
  ///
  /// In pt, this message translates to:
  /// **'Política de Privacidade'**
  String get privacyPolicy;

  /// No description provided for @privacyPolicyIntro.
  ///
  /// In pt, this message translates to:
  /// **'Esta Política de Privacidade descreve como o aplicativo Jogo da Velha coleta, usa e protege suas informações.'**
  String get privacyPolicyIntro;

  /// No description provided for @privacyPolicyDataCollection.
  ///
  /// In pt, this message translates to:
  /// **'Coleta de Dados'**
  String get privacyPolicyDataCollection;

  /// No description provided for @privacyPolicyDataCollectionText.
  ///
  /// In pt, this message translates to:
  /// **'Nosso aplicativo não coleta dados pessoais identificáveis. As únicas informações armazenadas são suas preferências de jogo (como idioma e configurações de som), que ficam salvas localmente no seu dispositivo.'**
  String get privacyPolicyDataCollectionText;

  /// No description provided for @privacyPolicyAds.
  ///
  /// In pt, this message translates to:
  /// **'Anúncios'**
  String get privacyPolicyAds;

  /// No description provided for @privacyPolicyAdsText.
  ///
  /// In pt, this message translates to:
  /// **'Utilizamos o Google AdMob para exibir anúncios. O Google pode coletar e usar dados para personalizar anúncios. Para mais informações, consulte a Política de Privacidade do Google em: https://policies.google.com/privacy'**
  String get privacyPolicyAdsText;

  /// No description provided for @privacyPolicyPurchases.
  ///
  /// In pt, this message translates to:
  /// **'Compras no Aplicativo'**
  String get privacyPolicyPurchases;

  /// No description provided for @privacyPolicyPurchasesText.
  ///
  /// In pt, this message translates to:
  /// **'As compras no aplicativo são processadas pela Google Play Store. Não temos acesso às suas informações de pagamento.'**
  String get privacyPolicyPurchasesText;

  /// No description provided for @privacyPolicyChildren.
  ///
  /// In pt, this message translates to:
  /// **'Privacidade de Crianças'**
  String get privacyPolicyChildren;

  /// No description provided for @privacyPolicyChildrenText.
  ///
  /// In pt, this message translates to:
  /// **'Nosso aplicativo é adequado para todas as idades e não coleta intencionalmente informações de crianças.'**
  String get privacyPolicyChildrenText;

  /// No description provided for @privacyPolicyChanges.
  ///
  /// In pt, this message translates to:
  /// **'Alterações'**
  String get privacyPolicyChanges;

  /// No description provided for @privacyPolicyChangesText.
  ///
  /// In pt, this message translates to:
  /// **'Podemos atualizar esta política periodicamente. Recomendamos que você revise esta página regularmente.'**
  String get privacyPolicyChangesText;

  /// No description provided for @privacyPolicyContact.
  ///
  /// In pt, this message translates to:
  /// **'Contato'**
  String get privacyPolicyContact;

  /// No description provided for @privacyPolicyContactText.
  ///
  /// In pt, this message translates to:
  /// **'Se você tiver dúvidas sobre esta Política de Privacidade, entre em contato conosco.'**
  String get privacyPolicyContactText;

  /// No description provided for @privacyPolicyLastUpdate.
  ///
  /// In pt, this message translates to:
  /// **'Última atualização: Fevereiro de 2026'**
  String get privacyPolicyLastUpdate;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
