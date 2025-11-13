import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:rukunin/pages/general/auth_wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rukunin/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('id_ID', null);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    _shouldUseMobilePreview()
        ? const MobilePreviewWrapper(child: MainApp())
        : const MainApp(),
  );
}

bool _shouldUseMobilePreview() {
  if (kIsWeb) return true; // Always force preview on web

  // Force preview only on desktop apps
  if (!Platform.isAndroid && !Platform.isIOS) return true;

  // Running on a real mobile device → don't wrap
  return false;
}

class MobilePreviewWrapper extends StatelessWidget {
  final Widget child;

  const MobilePreviewWrapper({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    const mobileWidth = 390.0; // iPhone 14 width in logical pixels

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Container(
            width: mobileWidth,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
              borderRadius: BorderRadius.circular(20),
            ),
            clipBehavior: Clip.hardEdge,
            child: child,
          ),
        ),
      ),
    );
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rukunin',
      theme: ThemeData(primarySwatch: Colors.yellow, useMaterial3: true),
      home: const AuthWrapper(),
    );
  }
}
