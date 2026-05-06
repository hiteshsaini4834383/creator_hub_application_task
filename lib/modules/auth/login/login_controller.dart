import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../ home/home_view.dart';
// import '../../home/home_view.dart';
import '../../../ app/core/utils/internet_service.dart';
import '../../../data/services/auth_service.dart';

class LoginController extends GetxController {
  final AuthService _authService = AuthService();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isLoading = false.obs;
  var isPasswordVisible = false.obs;

  /// EMAIL VALIDATION
  bool isValidEmail(String email) {
    return RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]+$",
    ).hasMatch(email);
  }

  /// COLORFUL SNACKBAR
  void showSnack(String title, String message, Color color) {
    Get.snackbar(
      title,
      message,
      backgroundColor: color,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
      icon: const Icon(Icons.info, color: Colors.white),
    );
  }

  // void login() async {
  //   final email = emailController.text.trim();
  //   final password = passwordController.text.trim();
  //
  //   if (email.isEmpty || password.isEmpty) {
  //     showSnack("Error", "All fields are required", Colors.red);
  //     return;
  //   }
  //
  //   if (!isValidEmail(email)) {
  //     showSnack("Invalid Email", "Please enter valid email", Colors.orange);
  //     return;
  //   }
  //
  //   try {
  //     isLoading.value = true;
  //
  //     await _authService.login(
  //       email: email,
  //       password: password,
  //     );
  //
  //     showSnack("Success", "Login successful 🎉", Colors.green);
  //
  //     Get.offAll(() => const HomeView());
  //   } catch (e) {
  //     showSnack("Login Failed", e.toString(), Colors.red);
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  void login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    /// EMPTY CHECK
    if (email.isEmpty || password.isEmpty) {
      showSnack("Error", "All fields are required", Colors.red);
      return;
    }

    /// EMAIL VALIDATION
    if (!isValidEmail(email)) {
      showSnack("Invalid Email", "Please enter valid email", Colors.orange);
      return;
    }

    /// 🌐 NO INTERNET CHECK (ADDED HERE)
    if (!await InternetService.hasInternet()) {
      showSnack(
        "No Internet",
        "Please check your internet connection",
        Colors.red,
      );
      return;
    }

    try {
      isLoading.value = true;

      await _authService.login(
        email: email,
        password: password,
      );

      showSnack("Success", "Login successful 🎉", Colors.green);

      Get.offAll(() => const HomeView());
    } catch (e) {
      showSnack("Login Failed", e.toString(), Colors.red);
    } finally {
      isLoading.value = false;
    }
  }
  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}