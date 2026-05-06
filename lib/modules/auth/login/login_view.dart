//
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
//
// import '../../../ app/core/ widgets/custom_button.dart';
// import '../../../ app/core/ widgets/custom_textfield.dart';
// import '../signup/signup_view.dart';
// import 'login_controller.dart';
//
// class LoginView extends StatelessWidget {
//   const LoginView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(LoginController());
//
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 24.w),
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(height: 80.h),
//
//                 Text(
//                   "Welcome Back 👋",
//                   style: TextStyle(
//                     fontSize: 24.sp,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//
//                 SizedBox(height: 8.h),
//
//                 Text(
//                   "Login to continue",
//                   style: TextStyle(
//                     fontSize: 14.sp,
//                     color: Colors.grey,
//                   ),
//                 ),
//
//                 SizedBox(height: 40.h),
//
//                 CustomTextField(
//                   hint: "Email",
//                   controller: controller.emailController,
//                 ),
//
//                 CustomTextField(
//                   hint: "Password",
//                   isPassword: true,
//                   controller: controller.passwordController,
//                 ),
//
//                 SizedBox(height: 10.h),
//
//                 Obx(() => controller.isLoading.value
//                     ? const Center(child: CircularProgressIndicator())
//                     : CustomButton(
//                   text: "Login",
//                   onTap: controller.login,
//                 )),
//
//                 SizedBox(height: 20.h),
//
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       "Don't have an account?",
//                       style: TextStyle(fontSize: 13.sp),
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         Get.to(() => const SignupView());
//                       },
//                       child: Text(
//                         "Sign Up",
//                         style: TextStyle(fontSize: 13.sp),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../ app/core/ widgets/custom_button.dart';
// import '../../../app/core/widgets/custom_button.dart';
import '../signup/signup_view.dart';
import 'login_controller.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                SizedBox(height: 80.h),

                Text(
                  "Welcome Back 👋",
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 8.h),

                Text(
                  "Login to continue",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey,
                  ),
                ),

                SizedBox(height: 40.h),

                /// EMAIL FIELD
                TextField(
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                SizedBox(height: 15.h),

                /// PASSWORD FIELD (SHOW/HIDE)
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

                SizedBox(height: 20.h),

                /// LOGIN BUTTON
                Obx(() => controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : CustomButton(
                  text: "Login",
                  onTap: controller.login,
                )),

                SizedBox(height: 20.h),

                /// SIGNUP
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        Get.to(() => const SignupView());
                      },
                      child: const Text("Sign Up"),
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