import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leetcode_stats/core/theme/theme_bloc.dart';
import 'app.dart';
import 'core/theme/theme_event.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final themeBloc = ThemeBloc();
  themeBloc.add(LoadThemeEvent());
  runApp(
      BlocProvider(
        create: (context) => themeBloc,
        child: const MyApp(),
      )
  );
}

