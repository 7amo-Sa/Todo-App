import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageCubit extends Cubit<Locale> {
  static const String _prefKey = 'app_language';

  LanguageCubit() : super(const Locale('en')) {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCode = prefs.getString(_prefKey) ?? 'en';
    emit(Locale(savedCode));
  }

  Future<void> changeLanguage(String languageCode) async {
    if (state.languageCode == languageCode) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, languageCode);
    emit(Locale(languageCode));
  }
}
