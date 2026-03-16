import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/config/app_routes.dart';
import 'core/theme/theme_bloc.dart';

import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/view/login_mobile.dart';

import 'features/dashboard/view/mobile/dashboard_mobile.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool loading = true;
  String? username;

  @override
  void initState() {
    super.initState();
    checkLogIn();
  }

  Future<void> checkLogIn() async {
    final store = await SharedPreferences.getInstance();
    username = store.getString("username");
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    if(loading){
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

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
                home: username == null ? const LoginMobile() : const DashboardMobile(),
                debugShowCheckedModeBanner: false,
                title: "LeetCode Stats",
                themeMode: themeMode,
                theme: ThemeData.light(),
                darkTheme: ThemeData.dark(),
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