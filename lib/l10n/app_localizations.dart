import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';
import 'app_localizations_jv.dart';

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
    Locale('id'),
    Locale('jv'),
  ];

  /// The application title
  ///
  /// In en, this message translates to:
  /// **'Rukunin'**
  String get appTitle;

  /// A greeting message
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get hello;

  /// Welcome message
  ///
  /// In en, this message translates to:
  /// **'Welcome to Rukunin'**
  String get welcome;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back!'**
  String get welcomeBack;

  /// No description provided for @residentRole.
  ///
  /// In en, this message translates to:
  /// **'Resident RW 05'**
  String get residentRole;

  /// No description provided for @communityWorkThisWeek.
  ///
  /// In en, this message translates to:
  /// **'Community Work This Week'**
  String get communityWorkThisWeek;

  /// No description provided for @announcementSecuritySchedule.
  ///
  /// In en, this message translates to:
  /// **'Announcement: Security Schedule'**
  String get announcementSecuritySchedule;

  /// No description provided for @securityScheduleChange.
  ///
  /// In en, this message translates to:
  /// **'Night security schedule change'**
  String get securityScheduleChange;

  /// No description provided for @duesDeadline.
  ///
  /// In en, this message translates to:
  /// **'Dues Deadline'**
  String get duesDeadline;

  /// No description provided for @payDuesSoon.
  ///
  /// In en, this message translates to:
  /// **'Pay your dues this month soon'**
  String get payDuesSoon;

  /// No description provided for @dues.
  ///
  /// In en, this message translates to:
  /// **'Dues'**
  String get dues;

  /// No description provided for @payDues.
  ///
  /// In en, this message translates to:
  /// **'Pay Dues'**
  String get payDues;

  /// No description provided for @paymentHistory.
  ///
  /// In en, this message translates to:
  /// **'Payment History'**
  String get paymentHistory;

  /// No description provided for @digitalReceipts.
  ///
  /// In en, this message translates to:
  /// **'Digital Receipts'**
  String get digitalReceipts;

  /// No description provided for @services.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get services;

  /// No description provided for @submitLetter.
  ///
  /// In en, this message translates to:
  /// **'Submit Letter'**
  String get submitLetter;

  /// No description provided for @reportIssue.
  ///
  /// In en, this message translates to:
  /// **'Report Issue'**
  String get reportIssue;

  /// No description provided for @sendSuggestion.
  ///
  /// In en, this message translates to:
  /// **'Send Suggestion'**
  String get sendSuggestion;

  /// No description provided for @submissionStatus.
  ///
  /// In en, this message translates to:
  /// **'Submission Status'**
  String get submissionStatus;

  /// No description provided for @community.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get community;

  /// No description provided for @eventCalendar.
  ///
  /// In en, this message translates to:
  /// **'Event Calendar'**
  String get eventCalendar;

  /// No description provided for @announcements.
  ///
  /// In en, this message translates to:
  /// **'Announcements'**
  String get announcements;

  /// No description provided for @residentsData.
  ///
  /// In en, this message translates to:
  /// **'Residents Data'**
  String get residentsData;

  /// No description provided for @emergencyContacts.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contacts'**
  String get emergencyContacts;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred language'**
  String get languageSubtitle;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @indonesian.
  ///
  /// In en, this message translates to:
  /// **'Indonesian'**
  String get indonesian;

  /// No description provided for @javanese.
  ///
  /// In en, this message translates to:
  /// **'Javanese'**
  String get javanese;
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
      <String>['en', 'id', 'jv'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
    case 'jv':
      return AppLocalizationsJv();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
