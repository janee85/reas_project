
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/report_form_screen.dart';

class CustomerPurchaseApp extends StatelessWidget {
  const CustomerPurchaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Customer Purchase Record System',

      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF176B87),
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
      ),

      // Routes for navigating between screens
      routes: {
        '/report': (context) => const ReportFormScreen(),
      },

      // Initial screen
      home: const LoginScreen(),
    );
  }
}