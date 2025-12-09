import 'dart:ui_web' as ui_web;
import 'package:web/web.dart' as web;

void registerIFrameViewFactory(String viewType, String url) {
  ui_web.platformViewRegistry.registerViewFactory(viewType, (int viewId) {
    final iframe = web.HTMLIFrameElement()
      ..src = url
      ..style.border = 'none'
      ..style.height = '100%'
      ..style.width = '100%';
    return iframe;
  });
}
