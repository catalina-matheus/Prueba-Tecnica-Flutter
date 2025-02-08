import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum ThemeModeState { system, light, dark }

class ThemeCubit extends Cubit<ThemeModeState> {
  ThemeCubit() : super(ThemeModeState.system);

  void setTheme(ThemeModeState theme) {
    emit(theme);
  }

  void toggleTheme() {
    if (state == ThemeModeState.dark) {
      emit(ThemeModeState.light);
    } else {
      emit(ThemeModeState.dark);
    }
  }

  bool isDarkMode(BuildContext context) {
    if (state == ThemeModeState.system) {
      return MediaQuery.of(context).platformBrightness == Brightness.dark;
    }
    return state == ThemeModeState.dark;
  }
}
