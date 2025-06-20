import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/features/auth/screens/login_screen.dart';
import 'package:reddit/firebase_options.dart';
import 'package:reddit/theme/pallete.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase here if needed
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: Pallete.darkModeAppTheme,
      home: const LoginScreen(),
    );
  }
}


