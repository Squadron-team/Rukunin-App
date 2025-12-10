import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class JavaneseMaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const JavaneseMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'jv';

  @override
  Future<MaterialLocalizations> load(Locale locale) async {
    // Load Indonesian material localizations for Javanese
    return GlobalMaterialLocalizations.delegate.load(const Locale('id'));
  }

  @override
  bool shouldReload(JavaneseMaterialLocalizationsDelegate old) => false;
}

class JavaneseWidgetsLocalizationsDelegate
    extends LocalizationsDelegate<WidgetsLocalizations> {
  const JavaneseWidgetsLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'jv';

  @override
  Future<WidgetsLocalizations> load(Locale locale) async {
    // Load Indonesian widget localizations for Javanese
    return GlobalWidgetsLocalizations.delegate.load(const Locale('id'));
  }

  @override
  bool shouldReload(JavaneseWidgetsLocalizationsDelegate old) => false;
}

class JavaneseCupertinoLocalizationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const JavaneseCupertinoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'jv';

  @override
  Future<CupertinoLocalizations> load(Locale locale) async {
    // Load Indonesian cupertino localizations for Javanese
    return GlobalCupertinoLocalizations.delegate.load(const Locale('id'));
  }

  @override
  bool shouldReload(JavaneseCupertinoLocalizationsDelegate old) => false;
}
