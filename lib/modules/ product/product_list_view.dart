//
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
//
// import ' widgets/product_card.dart';
// // import 'widgets/product_card.dart';
// import 'add_product_view.dart';
// import 'product_controller.dart';
//
// class ProductListView extends StatelessWidget {
//   const ProductListView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(ProductController());
//     controller.fetchProducts();
//
//     return Scaffold(
//       backgroundColor: const Color(0xfff6f7fb),
//
//       /// ================= APP BAR =================
//       appBar: AppBar(
//         title: Text(
//           "My Products",
//           style: TextStyle(
//             fontSize: 18.sp,
//             fontWeight: FontWeight.w600,
//             color: Colors.black,
//           ),
//         ),
//         centerTitle: true,
//         elevation: 0,
//         foregroundColor: Colors.white,
//         backgroundColor: Colors.white,
//
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Colors.white, Colors.white],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//       ),
//
//       /// ================= BODY =================
//       body: Obx(() {
//         if (controller.products.isEmpty) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//
//                 Icon(
//                   Icons.inventory_2_outlined,
//                   size: 80.sp,
//                   color: Colors.grey,
//                 ),
//
//                 SizedBox(height: 10.h),
//
//                 Text(
//                   "No Products Found",
//                   style: TextStyle(
//                     fontSize: 16.sp,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.grey,
//                   ),
//                 ),
//
//                 SizedBox(height: 5.h),
//
//                 Text(
//                   "Add your first product",
//                   style: TextStyle(
//                     fontSize: 13.sp,
//                     color: Colors.grey.shade600,
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }
//
//         return ListView.builder(
//           padding: EdgeInsets.all(16.w),
//           itemCount: controller.products.length,
//           itemBuilder: (context, index) {
//             final product = controller.products[index];
//
//             return Padding(
//               padding: EdgeInsets.only(bottom: 8.h),
//               child: ProductCard(product: product),
//             );
//           },
//         );
//       }),
//
//       /// ================= FLOATING BUTTON =================
//       floatingActionButton: FloatingActionButton.extended(
//         backgroundColor: Colors.deepPurple,
//         icon: const Icon(Icons.add, color: Colors.white),
//         label: Text(
//           "Add Product",
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 13.sp,
//           ),
//         ),
//         onPressed: () {
//           Get.to(() => const AddProductView());
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import ' widgets/product_card.dart';
// import 'widgets/product_card.dart';
import 'add_product_view.dart';
import 'product_controller.dart';

class ProductListView extends StatelessWidget {
  const ProductListView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductController());
    controller.fetchProducts();

    return Scaffold(
      backgroundColor: const Color(0xfff6f7fb),

      /// ================= APP BAR =================
      appBar: AppBar(
        title: Text(
          "My Products",
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),

      /// ================= BODY =================
      body: Obx(() {
        if (controller.products.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inventory_2_outlined,
                  size: 80.sp,
                  color: Colors.grey,
                ),
                SizedBox(height: 10.h),
                Text(
                  "No Products Found",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  "Add your first product",
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(16.w),
          itemCount: controller.products.length,
          itemBuilder: (context, index) {
            final product = controller.products[index];

            /// 🔥 FADE + SLIDE ANIMATION
            return TweenAnimationBuilder(
              duration: Duration(milliseconds: 300 + (index * 100)),
              tween: Tween<double>(begin: 0, end: 1),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 30 * (1 - value)),
                    child: child,
                  ),
                );
              },
              child: Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: ProductCard(product: product),
              ),
            );
          },
        );
      }),

      /// ================= FLOATING BUTTON =================
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.deepPurple,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          "Add Product",
          style: TextStyle(
            color: Colors.white,
            fontSize: 13.sp,
          ),
        ),
        onPressed: () {
          Get.to(() => const AddProductView());
        },
      ),
    );
  }
}