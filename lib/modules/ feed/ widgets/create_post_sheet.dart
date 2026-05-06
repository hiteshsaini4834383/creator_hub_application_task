
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../feed_controller.dart';

class CreatePostSheet extends StatelessWidget {
  const CreatePostSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FeedController>();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          /// HANDLE
          Container(
            height: 4.h,
            width: 40.w,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),

          SizedBox(height: 14.h),

          /// TITLE
          Text(
            "Create Post",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              height: 1.2, // lh
              color: Colors.black,
            ),
          ),

          SizedBox(height: 14.h),

          /// TEXT FIELD
          TextField(
            controller: controller.postController,
            maxLines: 4,
            style: TextStyle(
              fontSize: 14.sp,
              height: 1.4, // lh
            ),
            decoration: InputDecoration(
              hintText: "What's on your mind?",
              hintStyle: TextStyle(
                fontSize: 13.sp,
                color: Colors.grey,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 12.h,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.r),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.r),
                borderSide: BorderSide(color: Colors.deepPurple),
              ),
            ),
          ),

          SizedBox(height: 10.h),

          /// IMAGE PICKER (FULL CLICKABLE)
          Obx(() => controller.imageFile.value == null
              ? GestureDetector(
            onTap: controller.pickImage,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 10.w,
                vertical: 8.h,
              ),
              child: Row(
                children: [
                  Icon(Icons.image,
                      size: 22.sp, color: Colors.grey),

                  SizedBox(width: 8.w),

                  Text(
                    "Add Image",
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          )
              : ClipRRect(
            borderRadius: BorderRadius.circular(14.r),
            child: Image.file(
              controller.imageFile.value!,
              height: 140.h,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          )),

          SizedBox(height: 14.h),

          /// POST BUTTON
          Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: Obx(() => SizedBox(
              width: double.infinity,
              height: 45.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple, // 🔥 button color
                  foregroundColor: Colors.white,
                  elevation: 3,
                  shadowColor: Colors.black12,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                onPressed: controller.isLoading.value
                    ? null
                    : () async {
                  await controller.createPost(
                    text: controller.postController.text,
                  );

                  controller.postController.clear();
                  controller.imageFile.value = null;

                  Get.back();
                },
                child: controller.isLoading.value
                    ? SizedBox(
                  height: 18.h,
                  width: 18.w,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : Text(
                  "Post",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )),
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }
}