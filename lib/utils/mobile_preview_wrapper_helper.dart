import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:web/web.dart';

class MobilePreviewWrapperHelper {
  static bool shouldUseMobilePreview() {
    if (kIsWeb) {
      // On web, check if the device is mobile
      if (_isWebMobile()) {
        return false; // Running on a phone → NO wrapper
      } else {
        return true; // Running on desktop browser → wrapper
      }
    }

    // Force preview only on desktop apps
    if (!Platform.isAndroid && !Platform.isIOS) return true;

    // Running on a real mobile device → don't wrap
    return false;
  }

  static bool _isWebMobile() {
    final ua = window.navigator.userAgent.toLowerCase();
    return ua.contains('iphone') ||
        ua.contains('android') ||
        ua.contains('ipad') ||
        ua.contains('mobile');
  }
}
