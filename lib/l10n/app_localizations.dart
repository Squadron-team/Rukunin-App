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

  /// No description provided for @marketplaceTitle.
  ///
  /// In en, this message translates to:
  /// **'Community Market'**
  String get marketplaceTitle;

  /// No description provided for @searchProducts.
  ///
  /// In en, this message translates to:
  /// **'Search products...'**
  String get searchProducts;

  /// No description provided for @myShop.
  ///
  /// In en, this message translates to:
  /// **'My Shop'**
  String get myShop;

  /// No description provided for @openShop.
  ///
  /// In en, this message translates to:
  /// **'Open Shop'**
  String get openShop;

  /// No description provided for @manageShop.
  ///
  /// In en, this message translates to:
  /// **'Manage Shop'**
  String get manageShop;

  /// No description provided for @categoryAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get categoryAll;

  /// No description provided for @categoryVegetables.
  ///
  /// In en, this message translates to:
  /// **'Vegetables'**
  String get categoryVegetables;

  /// No description provided for @categoryFruits.
  ///
  /// In en, this message translates to:
  /// **'Fruits'**
  String get categoryFruits;

  /// No description provided for @categoryMeat.
  ///
  /// In en, this message translates to:
  /// **'Meat'**
  String get categoryMeat;

  /// No description provided for @categoryDrinks.
  ///
  /// In en, this message translates to:
  /// **'Drinks'**
  String get categoryDrinks;

  /// No description provided for @categoryTools.
  ///
  /// In en, this message translates to:
  /// **'Tools'**
  String get categoryTools;

  /// No description provided for @noProducts.
  ///
  /// In en, this message translates to:
  /// **'No products yet'**
  String get noProducts;

  /// No description provided for @errorLoadingProducts.
  ///
  /// In en, this message translates to:
  /// **'An error occurred: {error}'**
  String errorLoadingProducts(Object error);

  /// No description provided for @sold.
  ///
  /// In en, this message translates to:
  /// **'Sold'**
  String get sold;

  /// No description provided for @stock.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get stock;

  /// No description provided for @openShopTitle.
  ///
  /// In en, this message translates to:
  /// **'Open Your Shop'**
  String get openShopTitle;

  /// No description provided for @openShopSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start selling in the community market'**
  String get openShopSubtitle;

  /// No description provided for @openShopButton.
  ///
  /// In en, this message translates to:
  /// **'Open Shop'**
  String get openShopButton;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @addProduct.
  ///
  /// In en, this message translates to:
  /// **'Add Product'**
  String get addProduct;

  /// No description provided for @addProductTo.
  ///
  /// In en, this message translates to:
  /// **'Add to Store'**
  String get addProductTo;

  /// No description provided for @productPhoto.
  ///
  /// In en, this message translates to:
  /// **'Product Photo'**
  String get productPhoto;

  /// No description provided for @tapToChangeImage.
  ///
  /// In en, this message translates to:
  /// **'Tap to change image'**
  String get tapToChangeImage;

  /// No description provided for @maxImageSize.
  ///
  /// In en, this message translates to:
  /// **'Max. 2MB (JPG, PNG)'**
  String get maxImageSize;

  /// No description provided for @productInfo.
  ///
  /// In en, this message translates to:
  /// **'Product Information'**
  String get productInfo;

  /// No description provided for @productName.
  ///
  /// In en, this message translates to:
  /// **'Product Name'**
  String get productName;

  /// No description provided for @enterProductName.
  ///
  /// In en, this message translates to:
  /// **'Enter product name'**
  String get enterProductName;

  /// No description provided for @productNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Product name is required'**
  String get productNameRequired;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @selectCategory.
  ///
  /// In en, this message translates to:
  /// **'Select category'**
  String get selectCategory;

  /// No description provided for @selectCategoryHint.
  ///
  /// In en, this message translates to:
  /// **'Select product category'**
  String get selectCategoryHint;

  /// No description provided for @categoryRequired.
  ///
  /// In en, this message translates to:
  /// **'Select product category'**
  String get categoryRequired;

  /// No description provided for @priceAndStock.
  ///
  /// In en, this message translates to:
  /// **'Price & Stock'**
  String get priceAndStock;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @enterPrice.
  ///
  /// In en, this message translates to:
  /// **'Enter price'**
  String get enterPrice;

  /// No description provided for @priceRequired.
  ///
  /// In en, this message translates to:
  /// **'Price is required'**
  String get priceRequired;

  /// No description provided for @stockQuantity.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get stockQuantity;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @unit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get unit;

  /// No description provided for @unitRequired.
  ///
  /// In en, this message translates to:
  /// **'Select unit'**
  String get unitRequired;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @describeProduct.
  ///
  /// In en, this message translates to:
  /// **'Describe your product details...'**
  String get describeProduct;

  /// No description provided for @descriptionRequired.
  ///
  /// In en, this message translates to:
  /// **'Product description is required'**
  String get descriptionRequired;

  /// No description provided for @saveProduct.
  ///
  /// In en, this message translates to:
  /// **'Save Product'**
  String get saveProduct;

  /// No description provided for @productSaved.
  ///
  /// In en, this message translates to:
  /// **'✅ Product added successfully!'**
  String get productSaved;

  /// No description provided for @failedToSave.
  ///
  /// In en, this message translates to:
  /// **'❌ Failed to add product: {error}'**
  String failedToSave(Object error);

  /// No description provided for @addPhotoFirst.
  ///
  /// In en, this message translates to:
  /// **'❌ Please add a product photo'**
  String get addPhotoFirst;

  /// No description provided for @imageTooLarge.
  ///
  /// In en, this message translates to:
  /// **'❌ Maximum image size is 2MB'**
  String get imageTooLarge;

  /// No description provided for @selectImageSource.
  ///
  /// In en, this message translates to:
  /// **'Select Image Source'**
  String get selectImageSource;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @failedToPickImage.
  ///
  /// In en, this message translates to:
  /// **'❌ Failed to pick image: {error}'**
  String failedToPickImage(Object error);

  /// No description provided for @vegetables.
  ///
  /// In en, this message translates to:
  /// **'Vegetables'**
  String get vegetables;

  /// No description provided for @fruits.
  ///
  /// In en, this message translates to:
  /// **'Fruits'**
  String get fruits;

  /// No description provided for @meat.
  ///
  /// In en, this message translates to:
  /// **'Meat'**
  String get meat;

  /// No description provided for @drinks.
  ///
  /// In en, this message translates to:
  /// **'Drinks'**
  String get drinks;

  /// No description provided for @homemadeFood.
  ///
  /// In en, this message translates to:
  /// **'Homemade Food'**
  String get homemadeFood;

  /// No description provided for @equipment.
  ///
  /// In en, this message translates to:
  /// **'Equipment'**
  String get equipment;

  /// No description provided for @others.
  ///
  /// In en, this message translates to:
  /// **'Others'**
  String get others;

  /// No description provided for @cart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cart;

  /// No description provided for @cartAndOrders.
  ///
  /// In en, this message translates to:
  /// **'Cart & Orders'**
  String get cartAndOrders;

  /// No description provided for @inProcess.
  ///
  /// In en, this message translates to:
  /// **'In Process'**
  String get inProcess;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @emptyCart.
  ///
  /// In en, this message translates to:
  /// **'Cart is Empty'**
  String get emptyCart;

  /// No description provided for @noProductsInCart.
  ///
  /// In en, this message translates to:
  /// **'No products in your cart yet'**
  String get noProductsInCart;

  /// No description provided for @shopNow.
  ///
  /// In en, this message translates to:
  /// **'Shop Now'**
  String get shopNow;

  /// No description provided for @shippingAddress.
  ///
  /// In en, this message translates to:
  /// **'Shipping Address'**
  String get shippingAddress;

  /// No description provided for @productsInCart.
  ///
  /// In en, this message translates to:
  /// **'Shopping Products'**
  String get productsInCart;

  /// No description provided for @haveCoupon.
  ///
  /// In en, this message translates to:
  /// **'Have a coupon code?'**
  String get haveCoupon;

  /// No description provided for @enterCoupon.
  ///
  /// In en, this message translates to:
  /// **'Enter coupon code'**
  String get enterCoupon;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @couponApplied.
  ///
  /// In en, this message translates to:
  /// **'Coupon successfully applied!'**
  String get couponApplied;

  /// No description provided for @enterCouponCode.
  ///
  /// In en, this message translates to:
  /// **'Enter coupon code'**
  String get enterCouponCode;

  /// No description provided for @invalidCoupon.
  ///
  /// In en, this message translates to:
  /// **'Invalid coupon code'**
  String get invalidCoupon;

  /// No description provided for @paymentSummary.
  ///
  /// In en, this message translates to:
  /// **'Payment Summary'**
  String get paymentSummary;

  /// No description provided for @subtotal.
  ///
  /// In en, this message translates to:
  /// **'Sub Total'**
  String get subtotal;

  /// No description provided for @deliveryFee.
  ///
  /// In en, this message translates to:
  /// **'Delivery Fee'**
  String get deliveryFee;

  /// No description provided for @discount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discount;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @totalPayment.
  ///
  /// In en, this message translates to:
  /// **'Total Payment'**
  String get totalPayment;

  /// No description provided for @checkout.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkout;

  /// No description provided for @productRemoved.
  ///
  /// In en, this message translates to:
  /// **'Product removed from cart'**
  String get productRemoved;

  /// No description provided for @noOrdersInProcess.
  ///
  /// In en, this message translates to:
  /// **'No orders in process yet'**
  String get noOrdersInProcess;

  /// No description provided for @noCompletedOrders.
  ///
  /// In en, this message translates to:
  /// **'No completed orders yet'**
  String get noCompletedOrders;

  /// No description provided for @ordersWillAppear.
  ///
  /// In en, this message translates to:
  /// **'Orders will appear here'**
  String get ordersWillAppear;

  /// No description provided for @order.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get order;

  /// No description provided for @items.
  ///
  /// In en, this message translates to:
  /// **'items'**
  String get items;

  /// No description provided for @item.
  ///
  /// In en, this message translates to:
  /// **'item'**
  String get item;

  /// No description provided for @contactSeller.
  ///
  /// In en, this message translates to:
  /// **'Contact Seller'**
  String get contactSeller;

  /// No description provided for @trackOrder.
  ///
  /// In en, this message translates to:
  /// **'Track Order'**
  String get trackOrder;

  /// No description provided for @myProducts.
  ///
  /// In en, this message translates to:
  /// **'My Products'**
  String get myProducts;

  /// No description provided for @products.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get products;

  /// No description provided for @noProductsYet.
  ///
  /// In en, this message translates to:
  /// **'No products yet'**
  String get noProductsYet;

  /// No description provided for @addProductsToStart.
  ///
  /// In en, this message translates to:
  /// **'Add products to start\nselling in Community Market'**
  String get addProductsToStart;

  /// No description provided for @addFirstProduct.
  ///
  /// In en, this message translates to:
  /// **'Add First Product'**
  String get addFirstProduct;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// No description provided for @storeOrders.
  ///
  /// In en, this message translates to:
  /// **'Store Orders'**
  String get storeOrders;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @processing.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get processing;

  /// No description provided for @finished.
  ///
  /// In en, this message translates to:
  /// **'Finished'**
  String get finished;

  /// No description provided for @noPendingOrders.
  ///
  /// In en, this message translates to:
  /// **'No pending orders yet'**
  String get noPendingOrders;

  /// No description provided for @noProcessingOrders.
  ///
  /// In en, this message translates to:
  /// **'No orders in process yet'**
  String get noProcessingOrders;

  /// No description provided for @noFinishedOrders.
  ///
  /// In en, this message translates to:
  /// **'No completed orders yet'**
  String get noFinishedOrders;

  /// No description provided for @buyer.
  ///
  /// In en, this message translates to:
  /// **'Buyer'**
  String get buyer;

  /// No description provided for @contact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @markAsComplete.
  ///
  /// In en, this message translates to:
  /// **'Mark as Complete'**
  String get markAsComplete;

  /// No description provided for @confirmOrder.
  ///
  /// In en, this message translates to:
  /// **'Confirm Order'**
  String get confirmOrder;

  /// No description provided for @confirmOrderQuestion.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to confirm order from {buyer}?'**
  String confirmOrderQuestion(String buyer);

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @orderConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Order confirmed successfully'**
  String get orderConfirmed;

  /// No description provided for @rejectOrder.
  ///
  /// In en, this message translates to:
  /// **'Reject Order'**
  String get rejectOrder;

  /// No description provided for @rejectOrderQuestion.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reject order from {buyer}?'**
  String rejectOrderQuestion(String buyer);

  /// No description provided for @orderRejected.
  ///
  /// In en, this message translates to:
  /// **'Order rejected'**
  String get orderRejected;

  /// No description provided for @completeOrder.
  ///
  /// In en, this message translates to:
  /// **'Complete Order'**
  String get completeOrder;

  /// No description provided for @completeOrderQuestion.
  ///
  /// In en, this message translates to:
  /// **'Has this order been completed and received by the buyer?'**
  String get completeOrderQuestion;

  /// No description provided for @notYet.
  ///
  /// In en, this message translates to:
  /// **'Not Yet'**
  String get notYet;

  /// No description provided for @yesComplete.
  ///
  /// In en, this message translates to:
  /// **'Yes, Complete'**
  String get yesComplete;

  /// No description provided for @orderCompleted.
  ///
  /// In en, this message translates to:
  /// **'Order completed'**
  String get orderCompleted;

  /// No description provided for @manageProduct.
  ///
  /// In en, this message translates to:
  /// **'Manage Product'**
  String get manageProduct;

  /// No description provided for @editProduct.
  ///
  /// In en, this message translates to:
  /// **'Edit Product'**
  String get editProduct;

  /// No description provided for @changeProductInfo.
  ///
  /// In en, this message translates to:
  /// **'Change product information'**
  String get changeProductInfo;

  /// No description provided for @deactivateProduct.
  ///
  /// In en, this message translates to:
  /// **'Deactivate Product'**
  String get deactivateProduct;

  /// No description provided for @productNotInMarket.
  ///
  /// In en, this message translates to:
  /// **'Product will not appear in Community Market'**
  String get productNotInMarket;

  /// No description provided for @activateProduct.
  ///
  /// In en, this message translates to:
  /// **'Activate Product'**
  String get activateProduct;

  /// No description provided for @showProductInMarket.
  ///
  /// In en, this message translates to:
  /// **'Show product in Community Market'**
  String get showProductInMarket;

  /// No description provided for @deleteProduct.
  ///
  /// In en, this message translates to:
  /// **'Delete Product'**
  String get deleteProduct;

  /// No description provided for @deleteProductPermanently.
  ///
  /// In en, this message translates to:
  /// **'Delete product permanently'**
  String get deleteProductPermanently;

  /// No description provided for @deleteProductQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete Product?'**
  String get deleteProductQuestion;

  /// No description provided for @cannotBeUndone.
  ///
  /// In en, this message translates to:
  /// **'Deleted product cannot be restored'**
  String get cannotBeUndone;

  /// No description provided for @yesDelete.
  ///
  /// In en, this message translates to:
  /// **'Yes, Delete'**
  String get yesDelete;

  /// No description provided for @productDeleted.
  ///
  /// In en, this message translates to:
  /// **'✅ Product deleted successfully'**
  String get productDeleted;

  /// No description provided for @failedToDelete.
  ///
  /// In en, this message translates to:
  /// **'❌ Failed to delete product'**
  String get failedToDelete;

  /// No description provided for @productInfoLabel.
  ///
  /// In en, this message translates to:
  /// **'Product Information'**
  String get productInfoLabel;

  /// No description provided for @priceAndStockInfo.
  ///
  /// In en, this message translates to:
  /// **'Price & Stock Information'**
  String get priceAndStockInfo;

  /// No description provided for @productDescription.
  ///
  /// In en, this message translates to:
  /// **'Product Description'**
  String get productDescription;

  /// No description provided for @productManagement.
  ///
  /// In en, this message translates to:
  /// **'Manage Product'**
  String get productManagement;

  /// No description provided for @productUpdated.
  ///
  /// In en, this message translates to:
  /// **'✅ Product updated successfully!'**
  String get productUpdated;

  /// No description provided for @failedToUpdate.
  ///
  /// In en, this message translates to:
  /// **'❌ Failed to update product'**
  String get failedToUpdate;

  /// No description provided for @allFieldsRequired.
  ///
  /// In en, this message translates to:
  /// **'❌ All fields must be filled'**
  String get allFieldsRequired;

  /// No description provided for @productActivated.
  ///
  /// In en, this message translates to:
  /// **'✅ Product activated'**
  String get productActivated;

  /// No description provided for @productDeactivated.
  ///
  /// In en, this message translates to:
  /// **'⏸️ Product deactivated'**
  String get productDeactivated;

  /// No description provided for @failedToChangeStatus.
  ///
  /// In en, this message translates to:
  /// **'❌ Failed to change product status'**
  String get failedToChangeStatus;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// No description provided for @orderProducts.
  ///
  /// In en, this message translates to:
  /// **'Order Products'**
  String get orderProducts;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethod;

  /// No description provided for @eWallet.
  ///
  /// In en, this message translates to:
  /// **'E-Wallet'**
  String get eWallet;

  /// No description provided for @bankTransfer.
  ///
  /// In en, this message translates to:
  /// **'Bank Transfer'**
  String get bankTransfer;

  /// No description provided for @cashOnDelivery.
  ///
  /// In en, this message translates to:
  /// **'Cash on Delivery (COD)'**
  String get cashOnDelivery;

  /// No description provided for @payNow.
  ///
  /// In en, this message translates to:
  /// **'Pay Now'**
  String get payNow;

  /// No description provided for @paymentSuccess.
  ///
  /// In en, this message translates to:
  /// **'Payment Successful!'**
  String get paymentSuccess;

  /// No description provided for @buyerLabel.
  ///
  /// In en, this message translates to:
  /// **'Buyer'**
  String get buyerLabel;

  /// No description provided for @orderBeingProcessed.
  ///
  /// In en, this message translates to:
  /// **'Your order is being processed and will be delivered soon'**
  String get orderBeingProcessed;

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHome;

  /// No description provided for @viewMyOrders.
  ///
  /// In en, this message translates to:
  /// **'View My Orders'**
  String get viewMyOrders;

  /// No description provided for @buyNow.
  ///
  /// In en, this message translates to:
  /// **'Buy Now'**
  String get buyNow;

  /// No description provided for @addToCart.
  ///
  /// In en, this message translates to:
  /// **'Add to Cart'**
  String get addToCart;

  /// No description provided for @addedToCart.
  ///
  /// In en, this message translates to:
  /// **'{product} added to cart'**
  String addedToCart(Object product);

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// No description provided for @failedToAddToCart.
  ///
  /// In en, this message translates to:
  /// **'Failed to add to cart'**
  String get failedToAddToCart;

  /// No description provided for @pleaseLoginFirst.
  ///
  /// In en, this message translates to:
  /// **'Please login first'**
  String get pleaseLoginFirst;

  /// No description provided for @productDetail.
  ///
  /// In en, this message translates to:
  /// **'Product Detail'**
  String get productDetail;

  /// No description provided for @reviews.
  ///
  /// In en, this message translates to:
  /// **'reviews'**
  String get reviews;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @seller.
  ///
  /// In en, this message translates to:
  /// **'Seller'**
  String get seller;

  /// No description provided for @purchaseQuantity.
  ///
  /// In en, this message translates to:
  /// **'Purchase quantity'**
  String get purchaseQuantity;

  /// No description provided for @productDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Product Description'**
  String get productDescriptionLabel;

  /// No description provided for @buyerReviews.
  ///
  /// In en, this message translates to:
  /// **'Buyer Reviews'**
  String get buyerReviews;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @verified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verified;

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{days} days ago'**
  String daysAgo(Object days);

  /// No description provided for @weekAgo.
  ///
  /// In en, this message translates to:
  /// **'{weeks} week ago'**
  String weekAgo(Object weeks);

  /// No description provided for @productsFound.
  ///
  /// In en, this message translates to:
  /// **'{count} products found'**
  String productsFound(Object count);

  /// No description provided for @productNotFound.
  ///
  /// In en, this message translates to:
  /// **'Product not found'**
  String get productNotFound;

  /// No description provided for @tryOtherKeywords.
  ///
  /// In en, this message translates to:
  /// **'Try other keywords'**
  String get tryOtherKeywords;

  /// No description provided for @searchProductPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search products you need'**
  String get searchProductPlaceholder;

  /// No description provided for @errorOccurredGeneric.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get errorOccurredGeneric;

  /// No description provided for @myShopLabel.
  ///
  /// In en, this message translates to:
  /// **'My Shop'**
  String get myShopLabel;

  /// No description provided for @editShopInfo.
  ///
  /// In en, this message translates to:
  /// **'Edit shop info'**
  String get editShopInfo;

  /// No description provided for @awaitingApproval.
  ///
  /// In en, this message translates to:
  /// **'Awaiting Approval'**
  String get awaitingApproval;

  /// No description provided for @orderCount.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orderCount;

  /// No description provided for @addProductAction.
  ///
  /// In en, this message translates to:
  /// **'Add Product'**
  String get addProductAction;

  /// No description provided for @manageProducts.
  ///
  /// In en, this message translates to:
  /// **'Manage Products'**
  String get manageProducts;

  /// No description provided for @viewOrders.
  ///
  /// In en, this message translates to:
  /// **'View Orders'**
  String get viewOrders;

  /// No description provided for @noActivitiesScheduled.
  ///
  /// In en, this message translates to:
  /// **'No activities scheduled'**
  String get noActivitiesScheduled;

  /// No description provided for @activitiesScheduled.
  ///
  /// In en, this message translates to:
  /// **'{count} activities scheduled'**
  String activitiesScheduled(int count);

  /// No description provided for @peopleInterested.
  ///
  /// In en, this message translates to:
  /// **'{count} people interested'**
  String peopleInterested(int count);

  /// No description provided for @activityTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get activityTime;

  /// No description provided for @activityLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get activityLocation;

  /// No description provided for @activityDescription.
  ///
  /// In en, this message translates to:
  /// **'Activity Description'**
  String get activityDescription;

  /// No description provided for @registrationCancelled.
  ///
  /// In en, this message translates to:
  /// **'Registration cancelled'**
  String get registrationCancelled;

  /// No description provided for @registeredForActivity.
  ///
  /// In en, this message translates to:
  /// **'You have registered for this activity'**
  String get registeredForActivity;

  /// No description provided for @failedToUpdateRegistration.
  ///
  /// In en, this message translates to:
  /// **'Failed to update registration status'**
  String get failedToUpdateRegistration;

  /// No description provided for @alreadyRegistered.
  ///
  /// In en, this message translates to:
  /// **'Already Registered'**
  String get alreadyRegistered;

  /// No description provided for @joinActivity.
  ///
  /// In en, this message translates to:
  /// **'Join Activity'**
  String get joinActivity;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @noActivitiesTitle.
  ///
  /// In en, this message translates to:
  /// **'No Activities'**
  String get noActivitiesTitle;

  /// No description provided for @noActivitiesDesc.
  ///
  /// In en, this message translates to:
  /// **'No activities scheduled\non this date.'**
  String get noActivitiesDesc;

  /// No description provided for @suggestActivity.
  ///
  /// In en, this message translates to:
  /// **'Suggest Activity'**
  String get suggestActivity;

  /// No description provided for @suggestActivityFeature.
  ///
  /// In en, this message translates to:
  /// **'Suggest activity feature will be available soon'**
  String get suggestActivityFeature;

  /// No description provided for @organizer.
  ///
  /// In en, this message translates to:
  /// **'Organizer'**
  String get organizer;

  /// No description provided for @communityInformation.
  ///
  /// In en, this message translates to:
  /// **'Community Information'**
  String get communityInformation;

  /// No description provided for @populationInformation.
  ///
  /// In en, this message translates to:
  /// **'Population Information'**
  String get populationInformation;

  /// No description provided for @viewKtpKkData.
  ///
  /// In en, this message translates to:
  /// **'View your KTP/KK data'**
  String get viewKtpKkData;

  /// No description provided for @familyDataKk.
  ///
  /// In en, this message translates to:
  /// **'Family Data (KK)'**
  String get familyDataKk;

  /// No description provided for @manageFamilyMembers.
  ///
  /// In en, this message translates to:
  /// **'Manage family member information'**
  String get manageFamilyMembers;

  /// No description provided for @houseData.
  ///
  /// In en, this message translates to:
  /// **'House Data'**
  String get houseData;

  /// No description provided for @manageResidenceInfo.
  ///
  /// In en, this message translates to:
  /// **'Manage your residence information'**
  String get manageResidenceInfo;

  /// No description provided for @financeAndDues.
  ///
  /// In en, this message translates to:
  /// **'Finance & Dues'**
  String get financeAndDues;

  /// No description provided for @myDues.
  ///
  /// In en, this message translates to:
  /// **'My Dues'**
  String get myDues;

  /// No description provided for @monthlyDuesHistory.
  ///
  /// In en, this message translates to:
  /// **'Monthly dues payment history'**
  String get monthlyDuesHistory;

  /// No description provided for @financialTransparency.
  ///
  /// In en, this message translates to:
  /// **'Financial Transparency'**
  String get financialTransparency;

  /// No description provided for @rtRwFinancialReport.
  ///
  /// In en, this message translates to:
  /// **'RT/RW financial report'**
  String get rtRwFinancialReport;

  /// No description provided for @administration.
  ///
  /// In en, this message translates to:
  /// **'Administration'**
  String get administration;

  /// No description provided for @letterSubmission.
  ///
  /// In en, this message translates to:
  /// **'Letter Submission'**
  String get letterSubmission;

  /// No description provided for @submitLettersAndDocs.
  ///
  /// In en, this message translates to:
  /// **'Submit certificates and documents'**
  String get submitLettersAndDocs;
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
