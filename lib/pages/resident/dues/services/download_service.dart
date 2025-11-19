import 'dart:typed_data';
import 'web_download_stub.dart'
    if (dart.library.html) 'web_download_web.dart'
    if (dart.library.io) 'web_download_mobile.dart';

export 'web_download_stub.dart'
    if (dart.library.html) 'web_download_web.dart'
    if (dart.library.io) 'web_download_mobile.dart';

// Now import this file instead of web_download_web.dart directly
// Example: import 'services/download_service.dart';
