import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/encrypt_screen.dart';
import 'screens/decrypt_screen.dart';
import 'screens/saved_screen.dart';

void main() {
  runApp(const EncryptoApp());
}

class EncryptoApp extends StatelessWidget {
  const EncryptoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Encrypto',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/encrypt': (context) => const EncryptScreen(),
        '/decrypt': (context) => const DecryptScreen(),
        '/saved': (context) => const SavedScreen(),
      },
    );
  }
}
