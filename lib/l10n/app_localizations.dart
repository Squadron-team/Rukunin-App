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

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @signInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'To access your account in the app,\nenter your email and password'**
  String get signInSubtitle;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @signInWithApple.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Apple'**
  String get signInWithApple;

  /// No description provided for @signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get signInWithGoogle;

  /// No description provided for @termsPrefix.
  ///
  /// In en, this message translates to:
  /// **'By clicking \"Continue\", I have read and agreed to '**
  String get termsPrefix;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @and.
  ///
  /// In en, this message translates to:
  /// **', '**
  String get and;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @signUpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create a new account to use\nthe Rukunin application'**
  String get signUpSubtitle;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullName;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @passwordRequirements.
  ///
  /// In en, this message translates to:
  /// **'Password must contain:'**
  String get passwordRequirements;

  /// No description provided for @minCharacters.
  ///
  /// In en, this message translates to:
  /// **'Minimum 6 characters'**
  String get minCharacters;

  /// No description provided for @uppercase.
  ///
  /// In en, this message translates to:
  /// **'Uppercase letter (A-Z)'**
  String get uppercase;

  /// No description provided for @lowercase.
  ///
  /// In en, this message translates to:
  /// **'Lowercase letter (a-z)'**
  String get lowercase;

  /// No description provided for @number.
  ///
  /// In en, this message translates to:
  /// **'Number (0-9)'**
  String get number;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @signUpWithApple.
  ///
  /// In en, this message translates to:
  /// **'Sign up with Apple'**
  String get signUpWithApple;

  /// No description provided for @signUpWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign up with Google'**
  String get signUpWithGoogle;

  /// No description provided for @signUpTermsPrefix.
  ///
  /// In en, this message translates to:
  /// **'By clicking \"Register\", I have read and agreed to '**
  String get signUpTermsPrefix;

  /// No description provided for @welcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome, {name}!'**
  String welcomeMessage(Object name);

  /// No description provided for @accountCreated.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully! Welcome, {name}'**
  String accountCreated(Object name);

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name cannot be empty'**
  String get nameRequired;

  /// No description provided for @nameMinLength.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 3 characters'**
  String get nameMinLength;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email cannot be empty'**
  String get emailRequired;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid email format'**
  String get emailInvalid;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password cannot be empty'**
  String get passwordRequired;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMinLength;

  /// No description provided for @passwordUppercase.
  ///
  /// In en, this message translates to:
  /// **'Password must contain uppercase letter'**
  String get passwordUppercase;

  /// No description provided for @passwordLowercase.
  ///
  /// In en, this message translates to:
  /// **'Password must contain lowercase letter'**
  String get passwordLowercase;

  /// No description provided for @passwordNumber.
  ///
  /// In en, this message translates to:
  /// **'Password must contain a number'**
  String get passwordNumber;

  /// No description provided for @confirmPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password confirmation cannot be empty'**
  String get confirmPasswordRequired;

  /// No description provided for @passwordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordMismatch;

  /// No description provided for @enterEmailFirst.
  ///
  /// In en, this message translates to:
  /// **'Enter your email first'**
  String get enterEmailFirst;

  /// No description provided for @resetEmailSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset email has been sent. Check your inbox.'**
  String get resetEmailSent;

  /// No description provided for @featureNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'{feature} not yet available'**
  String featureNotAvailable(Object feature);

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred: {error}'**
  String errorOccurred(Object error);

  /// No description provided for @welcomeToRukunin.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Rukunin!'**
  String get welcomeToRukunin;

  /// No description provided for @onboardingWelcomeDesc.
  ///
  /// In en, this message translates to:
  /// **'Complete your registration by filling in your identity data'**
  String get onboardingWelcomeDesc;

  /// No description provided for @letsStart.
  ///
  /// In en, this message translates to:
  /// **'Let\'s Start'**
  String get letsStart;

  /// No description provided for @step.
  ///
  /// In en, this message translates to:
  /// **'Step'**
  String get step;

  /// No description provided for @ofLabel.
  ///
  /// In en, this message translates to:
  /// **'of'**
  String get ofLabel;

  /// No description provided for @ktpData.
  ///
  /// In en, this message translates to:
  /// **'KTP Data'**
  String get ktpData;

  /// No description provided for @ktpDataDesc.
  ///
  /// In en, this message translates to:
  /// **'Please fill in your KTP (Identity Card) information accurately'**
  String get ktpDataDesc;

  /// No description provided for @nik.
  ///
  /// In en, this message translates to:
  /// **'NIK (ID Number)'**
  String get nik;

  /// No description provided for @enterNik.
  ///
  /// In en, this message translates to:
  /// **'Enter NIK'**
  String get enterNik;

  /// No description provided for @nikRequired.
  ///
  /// In en, this message translates to:
  /// **'NIK cannot be empty'**
  String get nikRequired;

  /// No description provided for @nikInvalid.
  ///
  /// In en, this message translates to:
  /// **'NIK must be 16 digits'**
  String get nikInvalid;

  /// No description provided for @birthPlace.
  ///
  /// In en, this message translates to:
  /// **'Birth Place'**
  String get birthPlace;

  /// No description provided for @enterBirthPlace.
  ///
  /// In en, this message translates to:
  /// **'Enter birth place'**
  String get enterBirthPlace;

  /// No description provided for @birthPlaceRequired.
  ///
  /// In en, this message translates to:
  /// **'Birth place cannot be empty'**
  String get birthPlaceRequired;

  /// No description provided for @birthDate.
  ///
  /// In en, this message translates to:
  /// **'Birth Date'**
  String get birthDate;

  /// No description provided for @selectBirthDate.
  ///
  /// In en, this message translates to:
  /// **'Select birth date'**
  String get selectBirthDate;

  /// No description provided for @birthDateRequired.
  ///
  /// In en, this message translates to:
  /// **'Birth date cannot be empty'**
  String get birthDateRequired;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @genderRequired.
  ///
  /// In en, this message translates to:
  /// **'Gender cannot be empty'**
  String get genderRequired;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @enterAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter complete address'**
  String get enterAddress;

  /// No description provided for @addressRequired.
  ///
  /// In en, this message translates to:
  /// **'Address cannot be empty'**
  String get addressRequired;

  /// No description provided for @rtRw.
  ///
  /// In en, this message translates to:
  /// **'RT/RW'**
  String get rtRw;

  /// No description provided for @enterRtRw.
  ///
  /// In en, this message translates to:
  /// **'Enter RT/RW'**
  String get enterRtRw;

  /// No description provided for @rtRwRequired.
  ///
  /// In en, this message translates to:
  /// **'RT/RW cannot be empty'**
  String get rtRwRequired;

  /// No description provided for @subDistrict.
  ///
  /// In en, this message translates to:
  /// **'Sub-district'**
  String get subDistrict;

  /// No description provided for @enterSubDistrict.
  ///
  /// In en, this message translates to:
  /// **'Enter sub-district'**
  String get enterSubDistrict;

  /// No description provided for @subDistrictRequired.
  ///
  /// In en, this message translates to:
  /// **'Sub-district cannot be empty'**
  String get subDistrictRequired;

  /// No description provided for @district.
  ///
  /// In en, this message translates to:
  /// **'District'**
  String get district;

  /// No description provided for @enterDistrict.
  ///
  /// In en, this message translates to:
  /// **'Enter district'**
  String get enterDistrict;

  /// No description provided for @districtRequired.
  ///
  /// In en, this message translates to:
  /// **'District cannot be empty'**
  String get districtRequired;

  /// No description provided for @religion.
  ///
  /// In en, this message translates to:
  /// **'Religion'**
  String get religion;

  /// No description provided for @selectReligion.
  ///
  /// In en, this message translates to:
  /// **'Select religion'**
  String get selectReligion;

  /// No description provided for @religionRequired.
  ///
  /// In en, this message translates to:
  /// **'Religion cannot be empty'**
  String get religionRequired;

  /// No description provided for @islam.
  ///
  /// In en, this message translates to:
  /// **'Islam'**
  String get islam;

  /// No description provided for @christianity.
  ///
  /// In en, this message translates to:
  /// **'Christianity'**
  String get christianity;

  /// No description provided for @catholicism.
  ///
  /// In en, this message translates to:
  /// **'Catholicism'**
  String get catholicism;

  /// No description provided for @hinduism.
  ///
  /// In en, this message translates to:
  /// **'Hinduism'**
  String get hinduism;

  /// No description provided for @buddhism.
  ///
  /// In en, this message translates to:
  /// **'Buddhism'**
  String get buddhism;

  /// No description provided for @confucianism.
  ///
  /// In en, this message translates to:
  /// **'Confucianism'**
  String get confucianism;

  /// No description provided for @maritalStatus.
  ///
  /// In en, this message translates to:
  /// **'Marital Status'**
  String get maritalStatus;

  /// No description provided for @selectMaritalStatus.
  ///
  /// In en, this message translates to:
  /// **'Select marital status'**
  String get selectMaritalStatus;

  /// No description provided for @maritalStatusRequired.
  ///
  /// In en, this message translates to:
  /// **'Marital status cannot be empty'**
  String get maritalStatusRequired;

  /// No description provided for @single.
  ///
  /// In en, this message translates to:
  /// **'Single'**
  String get single;

  /// No description provided for @married.
  ///
  /// In en, this message translates to:
  /// **'Married'**
  String get married;

  /// No description provided for @divorced.
  ///
  /// In en, this message translates to:
  /// **'Divorced'**
  String get divorced;

  /// No description provided for @widowed.
  ///
  /// In en, this message translates to:
  /// **'Widowed'**
  String get widowed;

  /// No description provided for @occupation.
  ///
  /// In en, this message translates to:
  /// **'Occupation'**
  String get occupation;

  /// No description provided for @enterOccupation.
  ///
  /// In en, this message translates to:
  /// **'Enter occupation'**
  String get enterOccupation;

  /// No description provided for @occupationRequired.
  ///
  /// In en, this message translates to:
  /// **'Occupation cannot be empty'**
  String get occupationRequired;

  /// No description provided for @nationality.
  ///
  /// In en, this message translates to:
  /// **'Nationality'**
  String get nationality;

  /// No description provided for @enterNationality.
  ///
  /// In en, this message translates to:
  /// **'Enter nationality'**
  String get enterNationality;

  /// No description provided for @nationalityRequired.
  ///
  /// In en, this message translates to:
  /// **'Nationality cannot be empty'**
  String get nationalityRequired;

  /// No description provided for @kkData.
  ///
  /// In en, this message translates to:
  /// **'KK Data (Family Card)'**
  String get kkData;

  /// No description provided for @kkDataDesc.
  ///
  /// In en, this message translates to:
  /// **'Please fill in your KK (Family Card) information accurately'**
  String get kkDataDesc;

  /// No description provided for @kkNumber.
  ///
  /// In en, this message translates to:
  /// **'KK Number'**
  String get kkNumber;

  /// No description provided for @enterKkNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter KK number'**
  String get enterKkNumber;

  /// No description provided for @kkNumberRequired.
  ///
  /// In en, this message translates to:
  /// **'KK number cannot be empty'**
  String get kkNumberRequired;

  /// No description provided for @kkNumberInvalid.
  ///
  /// In en, this message translates to:
  /// **'KK number must be 16 digits'**
  String get kkNumberInvalid;

  /// No description provided for @familyHeadName.
  ///
  /// In en, this message translates to:
  /// **'Family Head Name'**
  String get familyHeadName;

  /// No description provided for @enterFamilyHeadName.
  ///
  /// In en, this message translates to:
  /// **'Enter family head name'**
  String get enterFamilyHeadName;

  /// No description provided for @familyHeadNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Family head name cannot be empty'**
  String get familyHeadNameRequired;

  /// No description provided for @relationshipToHead.
  ///
  /// In en, this message translates to:
  /// **'Relationship to Family Head'**
  String get relationshipToHead;

  /// No description provided for @selectRelationship.
  ///
  /// In en, this message translates to:
  /// **'Select relationship'**
  String get selectRelationship;

  /// No description provided for @relationshipRequired.
  ///
  /// In en, this message translates to:
  /// **'Relationship cannot be empty'**
  String get relationshipRequired;

  /// No description provided for @head.
  ///
  /// In en, this message translates to:
  /// **'Head'**
  String get head;

  /// No description provided for @spouse.
  ///
  /// In en, this message translates to:
  /// **'Spouse'**
  String get spouse;

  /// No description provided for @child.
  ///
  /// In en, this message translates to:
  /// **'Child'**
  String get child;

  /// No description provided for @parent.
  ///
  /// In en, this message translates to:
  /// **'Parent'**
  String get parent;

  /// No description provided for @sibling.
  ///
  /// In en, this message translates to:
  /// **'Sibling'**
  String get sibling;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @submittingData.
  ///
  /// In en, this message translates to:
  /// **'Submitting data...'**
  String get submittingData;

  /// No description provided for @onboardingSuccess.
  ///
  /// In en, this message translates to:
  /// **'Registration completed successfully!'**
  String get onboardingSuccess;

  /// No description provided for @onboardingFailed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed. Please try again.'**
  String get onboardingFailed;

  /// No description provided for @dataVerificationNotice.
  ///
  /// In en, this message translates to:
  /// **'Your submitted data will be verified by RT/RW administrators'**
  String get dataVerificationNotice;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navMarketplace.
  ///
  /// In en, this message translates to:
  /// **'Market'**
  String get navMarketplace;

  /// No description provided for @navActivities.
  ///
  /// In en, this message translates to:
  /// **'Activities'**
  String get navActivities;

  /// No description provided for @navCommunity.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get navCommunity;

  /// No description provided for @navAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get navAccount;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @fullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullNameLabel;

  /// No description provided for @enterFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter full name'**
  String get enterFullName;

  /// No description provided for @fullNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Full name cannot be empty'**
  String get fullNameRequired;

  /// No description provided for @nicknameLabel.
  ///
  /// In en, this message translates to:
  /// **'Nickname'**
  String get nicknameLabel;

  /// No description provided for @enterNickname.
  ///
  /// In en, this message translates to:
  /// **'Enter nickname'**
  String get enterNickname;

  /// No description provided for @genderLabel.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get genderLabel;

  /// No description provided for @birthdateLabel.
  ///
  /// In en, this message translates to:
  /// **'Birth Date'**
  String get birthdateLabel;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @biometricAuth.
  ///
  /// In en, this message translates to:
  /// **'Biometric Authentication'**
  String get biometricAuth;

  /// No description provided for @biometricAuthDesc.
  ///
  /// In en, this message translates to:
  /// **'Use fingerprint or face ID to unlock the app'**
  String get biometricAuthDesc;

  /// No description provided for @biometricNotAvailableWeb.
  ///
  /// In en, this message translates to:
  /// **'Not available on web platform'**
  String get biometricNotAvailableWeb;

  /// No description provided for @biometricNotAvailableDevice.
  ///
  /// In en, this message translates to:
  /// **'Not available on this device'**
  String get biometricNotAvailableDevice;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @userGuide.
  ///
  /// In en, this message translates to:
  /// **'User Guide'**
  String get userGuide;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get aboutApp;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @profileUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdatedSuccess;

  /// No description provided for @failedToLoadData.
  ///
  /// In en, this message translates to:
  /// **'Failed to load data: {error}'**
  String failedToLoadData(Object error);

  /// No description provided for @failedToSaveData.
  ///
  /// In en, this message translates to:
  /// **'Failed to save data: {error}'**
  String failedToSaveData(Object error);

  /// No description provided for @failedToLogout.
  ///
  /// In en, this message translates to:
  /// **'Failed to logout: {error}'**
  String failedToLogout(Object error);

  /// No description provided for @featureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'{feature} feature will be available soon'**
  String featureComingSoon(Object feature);

  /// No description provided for @biometricNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Biometric not available. Make sure your device supports it and is set up.'**
  String get biometricNotAvailable;

  /// No description provided for @noBiometricEnrolled.
  ///
  /// In en, this message translates to:
  /// **'No biometric enrolled. Please set up fingerprint or face ID in device settings.'**
  String get noBiometricEnrolled;

  /// No description provided for @authenticationCancelled.
  ///
  /// In en, this message translates to:
  /// **'Authentication cancelled or failed. Please try again.'**
  String get authenticationCancelled;

  /// No description provided for @biometricEnabled.
  ///
  /// In en, this message translates to:
  /// **'Biometric authentication enabled'**
  String get biometricEnabled;

  /// No description provided for @biometricDisabled.
  ///
  /// In en, this message translates to:
  /// **'Biometric authentication disabled'**
  String get biometricDisabled;

  /// No description provided for @errorOccurredBiometric.
  ///
  /// In en, this message translates to:
  /// **'An error occurred: {error}'**
  String errorOccurredBiometric(Object error);

  /// No description provided for @languageChangedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Language successfully changed to {language}'**
  String languageChangedSuccess(Object language);

  /// No description provided for @editProfilePhoto.
  ///
  /// In en, this message translates to:
  /// **'edit profile photo'**
  String get editProfilePhoto;

  /// No description provided for @changePasswordFeature.
  ///
  /// In en, this message translates to:
  /// **'change password'**
  String get changePasswordFeature;

  /// No description provided for @notificationSettings.
  ///
  /// In en, this message translates to:
  /// **'notification settings'**
  String get notificationSettings;

  /// No description provided for @helpFeature.
  ///
  /// In en, this message translates to:
  /// **'help'**
  String get helpFeature;

  /// No description provided for @notificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationTitle;

  /// No description provided for @markAllAsRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all'**
  String get markAllAsRead;

  /// No description provided for @allMarkedAsRead.
  ///
  /// In en, this message translates to:
  /// **'All notifications marked as read'**
  String get allMarkedAsRead;

  /// No description provided for @notificationTabAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get notificationTabAll;

  /// No description provided for @notificationTabAdmin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get notificationTabAdmin;

  /// No description provided for @notificationTabCommunity.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get notificationTabCommunity;

  /// No description provided for @notificationTabEvent.
  ///
  /// In en, this message translates to:
  /// **'Event'**
  String get notificationTabEvent;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications'**
  String get noNotifications;

  /// No description provided for @noNotificationsDesc.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any notifications yet'**
  String get noNotificationsDesc;

  /// No description provided for @noNotificationsInCategory.
  ///
  /// In en, this message translates to:
  /// **'No notifications in this category'**
  String get noNotificationsInCategory;
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
