import 'package:flutter/material.dart';
import 'package:leetcode_stats/core/responsive/responsive_layout.dart';
import 'package:leetcode_stats/features/dashboard/view/desktop/dashboard_desktop.dart';
import 'package:leetcode_stats/features/dashboard/view/mobile/dashboard_mobile.dart';
import 'package:leetcode_stats/features/dashboard/view/tablet/dashboard_tablet.dart';


class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: const DashboardMobile(),
      tablet: const DashboardTablet(),
      desktop: const DashboardDesktop(),
    );
  }
}
