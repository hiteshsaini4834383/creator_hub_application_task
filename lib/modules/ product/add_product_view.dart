//
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
//
// import 'product_controller.dart';
//
// class AddProductView extends StatelessWidget {
//   const AddProductView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.find<ProductController>();
//
//     final titleController = TextEditingController();
//     final priceController = TextEditingController();
//
//     return Scaffold(
//       appBar: AppBar(title: const Text("Add Product")),
//
//       body: Padding(
//         padding: EdgeInsets.all(16.w),
//         child: Column(
//           children: [
//
//             TextField(
//               controller: titleController,
//               decoration: const InputDecoration(
//                 hintText: "Product Title",
//               ),
//             ),
//
//             SizedBox(height: 10.h),
//
//             TextField(
//               controller: priceController,
//               decoration: const InputDecoration(
//                 hintText: "Price",
//               ),
//             ),
//
//             SizedBox(height: 30.h),
//
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () async {
//                   await controller.addProduct(
//                     title: titleController.text,
//                     price: priceController.text,
//                   );
//
//                   Get.back();
//                 },
//                 child: const Text("Add Product"),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'product_controller.dart';
import '../../ app/core/ widgets/custom_textfield.dart';
import '../../ app/core/ widgets/custom_button.dart';

class AddProductView extends StatelessWidget {
  const AddProductView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductController>();

    final titleController = TextEditingController();
    final priceController = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xfff6f7fb),

      /// ================= APP BAR =================
      appBar: AppBar(
        title: Text(
          "Add Product",
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),

      /// ================= BODY =================
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// TITLE TEXT
                Text(
                  "Create New Product",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                SizedBox(height: 18.h),

                /// PRODUCT TITLE
                CustomTextField(
                  hint: "Product Title",
                  controller: titleController,
                ),

                /// PRICE
                CustomTextField(
                  hint: "Price",
                  controller: priceController,
                ),

                SizedBox(height: 10.h),

                /// IMAGE PICK UI (STATIC)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 14.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.image, color: Colors.grey),
                      SizedBox(width: 10.w),
                      Text(
                        "Add Product Image (Optional)",
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 25.h),

                /// BUTTON
                CustomButton(
                  text: "Add Product",
                  onTap: () async {
                    if (titleController.text.isEmpty ||
                        priceController.text.isEmpty) {
                      Get.snackbar(
                        "Error",
                        "Please fill all fields",
                        snackPosition: SnackPosition.BOTTOM,
                      );
                      return;
                    }

                    await controller.addProduct(
                      title: titleController.text,
                      price: priceController.text,
                    );

                    Get.back();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}