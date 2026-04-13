import 'package:flutter/material.dart';

abstract class ThemeEvent {}

class ToggleThemeEvent extends ThemeEvent{}

class LoadThemeEvent extends ThemeEvent{}

class ChangeThemeEvent extends ThemeEvent{
  final ThemeMode themeMode;
  ChangeThemeEvent(this.themeMode);
}