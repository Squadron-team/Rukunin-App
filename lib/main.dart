import 'package:flutter/material.dart';
import 'package:rukunin/pages/general/sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rukunin/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: Center(child: SignIn())),
    );
  }
}
