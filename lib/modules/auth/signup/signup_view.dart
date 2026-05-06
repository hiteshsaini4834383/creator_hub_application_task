
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../ app/core/ widgets/custom_button.dart';
import '../../../ app/core/ widgets/custom_textfield.dart';
import 'signup_controller.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                SizedBox(height: 60.h),

                GestureDetector(
                  onTap: () => Get.back(),
                  child: const Icon(Icons.arrow_back),
                ),

                SizedBox(height: 30.h),

                Text(
                  "Create Account 🚀",
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 8.h),

                Text(
                  "Signup to get started",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey,
                  ),
                ),

                SizedBox(height: 40.h),

                /// NAME
                CustomTextField(
                  hint: "Full Name",
                  controller: controller.nameController,
                ),

                /// EMAIL
                CustomTextField(
                  hint: "Email",
                  controller: controller.emailController,
                ),

                /// PASSWORD (TOGGLE ADDED)
                Obx(() => TextField(
                  controller: controller.passwordController,
                  obscureText: !controller.isPasswordVisible.value,
                  decoration: InputDecoration(
                    hintText: "Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isPasswordVisible.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        controller.isPasswordVisible.value =
                        !controller.isPasswordVisible.value;
                      },
                    ),
                  ),
                )),

                SizedBox(height: 15.h),

                /// BUTTON
                Obx(() => controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : CustomButton(
                  text: "Sign Up",
                  onTap: controller.signup,
                )),

                SizedBox(height: 20.h),

                /// LOGIN
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text("Login"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}