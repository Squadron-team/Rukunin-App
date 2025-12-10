// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Rukunin';

  @override
  String get hello => 'Hello';

  @override
  String get welcome => 'Welcome to Rukunin';

  @override
  String get home => 'Home';

  @override
  String get welcomeBack => 'Welcome back!';

  @override
  String get residentRole => 'Resident RW 05';

  @override
  String get communityWorkThisWeek => 'Community Work This Week';

  @override
  String get announcementSecuritySchedule => 'Announcement: Security Schedule';

  @override
  String get securityScheduleChange => 'Night security schedule change';

  @override
  String get duesDeadline => 'Dues Deadline';

  @override
  String get payDuesSoon => 'Pay your dues this month soon';

  @override
  String get dues => 'Dues';

  @override
  String get payDues => 'Pay Dues';

  @override
  String get paymentHistory => 'Payment History';

  @override
  String get digitalReceipts => 'Digital Receipts';

  @override
  String get services => 'Services';

  @override
  String get submitLetter => 'Submit Letter';

  @override
  String get reportIssue => 'Report Issue';

  @override
  String get sendSuggestion => 'Send Suggestion';

  @override
  String get submissionStatus => 'Submission Status';

  @override
  String get community => 'Community';

  @override
  String get eventCalendar => 'Event Calendar';

  @override
  String get announcements => 'Announcements';

  @override
  String get residentsData => 'Residents Data';

  @override
  String get emergencyContacts => 'Emergency Contacts';

  @override
  String get language => 'Language';

  @override
  String get languageSubtitle => 'Choose your preferred language';

  @override
  String get english => 'English';

  @override
  String get indonesian => 'Indonesian';

  @override
  String get javanese => 'Javanese';

  @override
  String get signIn => 'Sign In';

  @override
  String get signInSubtitle =>
      'To access your account in the app,\nenter your email and password';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get continueButton => 'Continue';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get createAccount => 'Create Account';

  @override
  String get signInWithApple => 'Sign in with Apple';

  @override
  String get signInWithGoogle => 'Sign in with Google';

  @override
  String get termsPrefix =>
      'By clicking \"Continue\", I have read and agreed to ';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get and => ', ';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get signUp => 'Sign Up';

  @override
  String get signUpSubtitle =>
      'Create a new account to use\nthe Rukunin application';

  @override
  String get fullName => 'Full name';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get passwordRequirements => 'Password must contain:';

  @override
  String get minCharacters => 'Minimum 6 characters';

  @override
  String get uppercase => 'Uppercase letter (A-Z)';

  @override
  String get lowercase => 'Lowercase letter (a-z)';

  @override
  String get number => 'Number (0-9)';

  @override
  String get register => 'Register';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get signUpWithApple => 'Sign up with Apple';

  @override
  String get signUpWithGoogle => 'Sign up with Google';

  @override
  String get signUpTermsPrefix =>
      'By clicking \"Register\", I have read and agreed to ';

  @override
  String welcomeMessage(Object name) {
    return 'Welcome, $name!';
  }

  @override
  String accountCreated(Object name) {
    return 'Account created successfully! Welcome, $name';
  }

  @override
  String get nameRequired => 'Name cannot be empty';

  @override
  String get nameMinLength => 'Name must be at least 3 characters';

  @override
  String get emailRequired => 'Email cannot be empty';

  @override
  String get emailInvalid => 'Invalid email format';

  @override
  String get passwordRequired => 'Password cannot be empty';

  @override
  String get passwordMinLength => 'Password must be at least 6 characters';

  @override
  String get passwordUppercase => 'Password must contain uppercase letter';

  @override
  String get passwordLowercase => 'Password must contain lowercase letter';

  @override
  String get passwordNumber => 'Password must contain a number';

  @override
  String get confirmPasswordRequired => 'Password confirmation cannot be empty';

  @override
  String get passwordMismatch => 'Passwords do not match';

  @override
  String get enterEmailFirst => 'Enter your email first';

  @override
  String get resetEmailSent =>
      'Password reset email has been sent. Check your inbox.';

  @override
  String featureNotAvailable(Object feature) {
    return '$feature not yet available';
  }

  @override
  String errorOccurred(Object error) {
    return 'An error occurred: $error';
  }

  @override
  String get welcomeToRukunin => 'Welcome to Rukunin!';

  @override
  String get onboardingWelcomeDesc =>
      'Complete your registration by filling in your identity data';

  @override
  String get letsStart => 'Let\'s Start';

  @override
  String get step => 'Step';

  @override
  String get ofLabel => 'of';

  @override
  String get ktpData => 'KTP Data';

  @override
  String get ktpDataDesc =>
      'Please fill in your KTP (Identity Card) information accurately';

  @override
  String get nik => 'NIK (ID Number)';

  @override
  String get enterNik => 'Enter NIK';

  @override
  String get nikRequired => 'NIK cannot be empty';

  @override
  String get nikInvalid => 'NIK must be 16 digits';

  @override
  String get birthPlace => 'Birth Place';

  @override
  String get enterBirthPlace => 'Enter birth place';

  @override
  String get birthPlaceRequired => 'Birth place cannot be empty';

  @override
  String get birthDate => 'Birth Date';

  @override
  String get selectBirthDate => 'Select birth date';

  @override
  String get birthDateRequired => 'Birth date cannot be empty';

  @override
  String get gender => 'Gender';

  @override
  String get male => 'Male';

  @override
  String get female => 'Female';

  @override
  String get genderRequired => 'Gender cannot be empty';

  @override
  String get address => 'Address';

  @override
  String get enterAddress => 'Enter complete address';

  @override
  String get addressRequired => 'Address cannot be empty';

  @override
  String get rtRw => 'RT/RW';

  @override
  String get enterRtRw => 'Enter RT/RW';

  @override
  String get rtRwRequired => 'RT/RW cannot be empty';

  @override
  String get subDistrict => 'Sub-district';

  @override
  String get enterSubDistrict => 'Enter sub-district';

  @override
  String get subDistrictRequired => 'Sub-district cannot be empty';

  @override
  String get district => 'District';

  @override
  String get enterDistrict => 'Enter district';

  @override
  String get districtRequired => 'District cannot be empty';

  @override
  String get religion => 'Religion';

  @override
  String get selectReligion => 'Select religion';

  @override
  String get religionRequired => 'Religion cannot be empty';

  @override
  String get islam => 'Islam';

  @override
  String get christianity => 'Christianity';

  @override
  String get catholicism => 'Catholicism';

  @override
  String get hinduism => 'Hinduism';

  @override
  String get buddhism => 'Buddhism';

  @override
  String get confucianism => 'Confucianism';

  @override
  String get maritalStatus => 'Marital Status';

  @override
  String get selectMaritalStatus => 'Select marital status';

  @override
  String get maritalStatusRequired => 'Marital status cannot be empty';

  @override
  String get single => 'Single';

  @override
  String get married => 'Married';

  @override
  String get divorced => 'Divorced';

  @override
  String get widowed => 'Widowed';

  @override
  String get occupation => 'Occupation';

  @override
  String get enterOccupation => 'Enter occupation';

  @override
  String get occupationRequired => 'Occupation cannot be empty';

  @override
  String get nationality => 'Nationality';

  @override
  String get enterNationality => 'Enter nationality';

  @override
  String get nationalityRequired => 'Nationality cannot be empty';

  @override
  String get kkData => 'KK Data (Family Card)';

  @override
  String get kkDataDesc =>
      'Please fill in your KK (Family Card) information accurately';

  @override
  String get kkNumber => 'KK Number';

  @override
  String get enterKkNumber => 'Enter KK number';

  @override
  String get kkNumberRequired => 'KK number cannot be empty';

  @override
  String get kkNumberInvalid => 'KK number must be 16 digits';

  @override
  String get familyHeadName => 'Family Head Name';

  @override
  String get enterFamilyHeadName => 'Enter family head name';

  @override
  String get familyHeadNameRequired => 'Family head name cannot be empty';

  @override
  String get relationshipToHead => 'Relationship to Family Head';

  @override
  String get selectRelationship => 'Select relationship';

  @override
  String get relationshipRequired => 'Relationship cannot be empty';

  @override
  String get head => 'Head';

  @override
  String get spouse => 'Spouse';

  @override
  String get child => 'Child';

  @override
  String get parent => 'Parent';

  @override
  String get sibling => 'Sibling';

  @override
  String get other => 'Other';

  @override
  String get next => 'Next';

  @override
  String get previous => 'Previous';

  @override
  String get submit => 'Submit';

  @override
  String get submittingData => 'Submitting data...';

  @override
  String get onboardingSuccess => 'Registration completed successfully!';

  @override
  String get onboardingFailed => 'Registration failed. Please try again.';

  @override
  String get dataVerificationNotice =>
      'Your submitted data will be verified by RT/RW administrators';

  @override
  String get navHome => 'Home';

  @override
  String get navMarketplace => 'Market';

  @override
  String get navActivities => 'Activities';

  @override
  String get navCommunity => 'Community';

  @override
  String get navAccount => 'Account';

  @override
  String get account => 'Account';

  @override
  String get fullNameLabel => 'Full Name';

  @override
  String get enterFullName => 'Enter full name';

  @override
  String get fullNameRequired => 'Full name cannot be empty';

  @override
  String get nicknameLabel => 'Nickname';

  @override
  String get enterNickname => 'Enter nickname';

  @override
  String get genderLabel => 'Gender';

  @override
  String get birthdateLabel => 'Birth Date';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get settings => 'Settings';

  @override
  String get changePassword => 'Change Password';

  @override
  String get biometricAuth => 'Biometric Authentication';

  @override
  String get biometricAuthDesc =>
      'Use fingerprint or face ID to unlock the app';

  @override
  String get biometricNotAvailableWeb => 'Not available on web platform';

  @override
  String get biometricNotAvailableDevice => 'Not available on this device';

  @override
  String get notifications => 'Notifications';

  @override
  String get helpSupport => 'Help & Support';

  @override
  String get userGuide => 'User Guide';

  @override
  String get aboutApp => 'About App';

  @override
  String get logout => 'Logout';

  @override
  String get profileUpdatedSuccess => 'Profile updated successfully';

  @override
  String failedToLoadData(Object error) {
    return 'Failed to load data: $error';
  }

  @override
  String failedToSaveData(Object error) {
    return 'Failed to save data: $error';
  }

  @override
  String failedToLogout(Object error) {
    return 'Failed to logout: $error';
  }

  @override
  String featureComingSoon(Object feature) {
    return '$feature feature will be available soon';
  }

  @override
  String get biometricNotAvailable =>
      'Biometric not available. Make sure your device supports it and is set up.';

  @override
  String get noBiometricEnrolled =>
      'No biometric enrolled. Please set up fingerprint or face ID in device settings.';

  @override
  String get authenticationCancelled =>
      'Authentication cancelled or failed. Please try again.';

  @override
  String get biometricEnabled => 'Biometric authentication enabled';

  @override
  String get biometricDisabled => 'Biometric authentication disabled';

  @override
  String errorOccurredBiometric(Object error) {
    return 'An error occurred: $error';
  }

  @override
  String languageChangedSuccess(Object language) {
    return 'Language successfully changed to $language';
  }

  @override
  String get editProfilePhoto => 'edit profile photo';

  @override
  String get changePasswordFeature => 'change password';

  @override
  String get notificationSettings => 'notification settings';

  @override
  String get helpFeature => 'help';
}
