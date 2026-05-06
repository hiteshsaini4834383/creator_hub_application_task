
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../ home/home_view.dart';
// import '../../home/home_view.dart';
import '../../../ app/core/utils/internet_service.dart';
import '../../../data/services/auth_service.dart';

class SignupController extends GetxController {
  final AuthService _authService = AuthService();

  final nameController = TextEditingController();
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
  void showSnack(String title, String msg, Color color) {
    Get.snackbar(
      title,
      msg,
      backgroundColor: color,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
      icon: const Icon(Icons.info, color: Colors.white),
    );
  }

  // void signup() async {
  //   final name = nameController.text.trim();
  //   final email = emailController.text.trim();
  //   final password = passwordController.text.trim();
  //
  //   /// VALIDATION
  //   if (name.isEmpty || email.isEmpty || password.isEmpty) {
  //     showSnack("Error", "All fields are required", Colors.red);
  //     return;
  //   }
  //
  //   if (!isValidEmail(email)) {
  //     showSnack("Invalid Email", "Enter a valid email", Colors.orange);
  //     return;
  //   }
  //
  //   if (password.length < 6) {
  //     showSnack("Weak Password", "Min 6 characters required", Colors.orange);
  //     return;
  //   }
  //
  //   try {
  //     isLoading.value = true;
  //
  //     /// CREATE USER
  //     final user = await _authService.signUp(
  //       email: email,
  //       password: password,
  //     );
  //
  //     if (user == null) {
  //       showSnack("Signup Failed", "User creation failed", Colors.red);
  //       return;
  //     }
  //
  //     final DatabaseReference ref =
  //     FirebaseDatabase.instance.ref("users/${user.uid}");
  //
  //     await ref.set({
  //       'name': name,
  //       'email': email,
  //       'uid': user.uid,
  //       'createdAt': DateTime.now().millisecondsSinceEpoch,
  //     });
  //
  //     showSnack("Success", "Account created 🎉", Colors.green);
  //
  //     Get.offAll(() => const HomeView());
  //
  //   } catch (e) {
  //     showSnack("Error", e.toString(), Colors.red);
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  void signup() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    /// VALIDATION
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      showSnack("Error", "All fields are required", Colors.red);
      return;
    }

    if (!isValidEmail(email)) {
      showSnack("Invalid Email", "Enter a valid email", Colors.orange);
      return;
    }

    if (password.length < 6) {
      showSnack("Weak Password", "Min 6 characters required", Colors.orange);
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

      /// CREATE USER
      final user = await _authService.signUp(
        email: email,
        password: password,
      );

      if (user == null) {
        showSnack("Signup Failed", "User creation failed", Colors.red);
        return;
      }

      final DatabaseReference ref =
      FirebaseDatabase.instance.ref("users/${user.uid}");

      await ref.set({
        'name': name,
        'email': email,
        'uid': user.uid,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
      });

      showSnack("Success", "Account created 🎉", Colors.green);

      Get.offAll(() => const HomeView());

    } catch (e) {
      showSnack("Error", e.toString(), Colors.red);
    } finally {
      isLoading.value = false;
    }
  }
  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}