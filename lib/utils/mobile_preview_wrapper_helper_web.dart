import 'package:web/web.dart';

bool isWebMobile() {
  final ua = window.navigator.userAgent.toLowerCase();
  return ua.contains('iphone') ||
      ua.contains('android') ||
      ua.contains('ipad') ||
      ua.contains('mobile');
}
