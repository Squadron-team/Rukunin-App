import 'package:rukunin/l10n/app_localizations.dart';

class FormValidator {
  final AppLocalizations l10n;

  FormValidator(this.l10n);

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return l10n.nameRequired;
    }
    if (value.length < 3) {
      return l10n.nameMinLength;
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return l10n.emailRequired;
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return l10n.emailInvalid;
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return l10n.passwordRequired;
    }
    if (value.length < 6) {
      return l10n.passwordMinLength;
    }
    return null;
  }

  String? validateStrongPassword(String? value) {
    final baseValidation = validatePassword(value);
    if (baseValidation != null) return baseValidation;

    if (!value!.contains(RegExp(r'[A-Z]'))) {
      return l10n.passwordUppercase;
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      return l10n.passwordLowercase;
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return l10n.passwordNumber;
    }
    return null;
  }

  String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return l10n.confirmPasswordRequired;
    }
    if (value != password) {
      return l10n.passwordMismatch;
    }
    return null;
  }
}
