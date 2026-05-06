import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InternetService {
  /// CHECK INTERNET
  static Future<bool> hasInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// SHOW NO INTERNET SNACKBAR
  static void showNoInternet() {
    Get.snackbar(
      "No Internet",
      "Please check your internet connection",
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(12),
      icon: const Icon(Icons.wifi_off, color: Colors.white),
    );
  }
}