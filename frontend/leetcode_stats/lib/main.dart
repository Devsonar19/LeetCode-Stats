import 'package:flutter/material.dart';
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
        home: ProfileScreen(),
        // ResponsiveLayout(
        //   mobileScaffold: const MobileScaffold(),
        //   tabletScaffold: const TabletScaffold(),
        //   desktopScaffold: const DesktopScaffold(),
        // ),
    );
  }
}
