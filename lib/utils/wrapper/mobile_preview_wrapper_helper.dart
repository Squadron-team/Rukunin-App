import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:rukunin/utils/wrapper/mobile_preview_wrapper_helper_stub.dart'
    if (dart.library.html) 'mobile_preview_wrapper_helper_web.dart'
    if (dart.library.io) 'mobile_preview_wrapper_helper_mobile.dart';

class MobilePreviewWrapperHelper {
  static bool shouldUseMobilePreview() {
    if (kIsWeb) {
      // On web, check if the device is mobile
      if (isWebMobile()) {
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
}
