import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/config/app_routes.dart';
import 'core/theme/theme_bloc.dart';

import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/view/login_mobile.dart';

import 'features/dashboard/view/mobile/dashboard_mobile.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(),
        ),
        BlocProvider(
          create: (_) => ThemeBloc(),
        ),
      ],
      child: Builder(
        builder: (context) {
          return BlocBuilder<ThemeBloc, ThemeMode>(
            builder: (context, themeMode) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: "LeetCode Stats",
                themeMode: themeMode,
                theme: ThemeData.light(),
                darkTheme: ThemeData.dark(),
                initialRoute: AppRoutes.login,
                routes: {
                  AppRoutes.login: (context) => const LoginMobile(),
                  AppRoutes.dashboard: (context) => const DashboardMobile(),
                },
              );
            },
          );
        }
      ),
    );
  }
}