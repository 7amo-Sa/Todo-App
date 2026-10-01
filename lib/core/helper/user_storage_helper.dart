import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/app_assets.dart';

class UserStorageHelper {
  static const String _imagePrefix = 'user_image_';

  static Future<void> saveUserImage(String username, String imagePath) async {
    if (username.isEmpty || imagePath.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('$_imagePrefix$username', imagePath);
    await prefs.setString('last_user_image', imagePath);
  }

  static Future<String?> getUserImage(String username) async {
    if (username.isEmpty) return null;
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('$_imagePrefix$username');
  }

  static Future<String?> getLastSavedUserImage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('last_user_image');
  }

  static ImageProvider getImageProvider(String? imagePath) {
    if (imagePath == null || imagePath.trim().isEmpty) {
      return AssetImage(AppImages.flag);
    }
    final trimmed = imagePath.trim();
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return NetworkImage(trimmed);
    }
    final file = File(trimmed);
    if (file.existsSync()) {
      return FileImage(file);
    }
    return AssetImage(AppImages.flag);
  }
}
