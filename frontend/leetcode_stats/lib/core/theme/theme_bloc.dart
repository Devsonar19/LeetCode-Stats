import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leetcode_stats/core/theme/theme_event.dart';
import 'package:leetcode_stats/core/theme/theme_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState>{
  static const _key  = "theme_mode";

  ThemeBloc() : super(ThemeState(themeMode: ThemeMode.system)){
    on<ToggleThemeEvent>(_onToggleTheme);
    on<LoadThemeEvent>(_onLoadTheme);
    on<ChangeThemeEvent>(_onChangeTheme);
  }

  Future<void> _onLoadTheme(
      LoadThemeEvent event,
      Emitter<ThemeState> emit,
      ) async {

    final prefs = await SharedPreferences.getInstance();
    final themeMode = prefs.getInt(_key);

    if(themeMode != null){
      emit(ThemeState(themeMode: ThemeMode.values[themeMode]));
    }
  }

  Future<void> _onToggleTheme(
      ToggleThemeEvent event,
      Emitter<ThemeState> emit,
      ) async {
    final prefs = await SharedPreferences.getInstance();
    final themeMode = prefs.getInt(_key);
    final newMode = state.themeMode == ThemeMode.dark
      ? ThemeMode.light
      : ThemeMode.dark;

    await prefs.setInt(_key, newMode.index);
    emit(ThemeState(themeMode: newMode));

  }

  Future<void> _onChangeTheme(
      ChangeThemeEvent event,
      Emitter<ThemeState> emit,
      ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_key, event.themeMode.index);

    emit(ThemeState(themeMode: event.themeMode));
  }

}