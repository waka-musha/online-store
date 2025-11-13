import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class ThemeState {
  final ThemeMode mode;

  const ThemeState(this.mode);
}

final class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState(ThemeMode.light));

  void setLight() => emit(const ThemeState(ThemeMode.light));

  void setDark() => emit(const ThemeState(ThemeMode.dark));

  void toggle() => emit(
    ThemeState(
      state.mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark,
    ),
  );
}
