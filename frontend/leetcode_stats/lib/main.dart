import 'package:flutter/material.dart';
import 'package:leetcode_stats/features/dashboard/view/dashboard.dart';
import 'package:leetcode_stats/screens/profile_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        home: DashboardScreen(),
    );
  }
}
