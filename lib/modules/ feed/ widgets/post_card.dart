
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../feed_controller.dart';

class PostCard extends StatelessWidget {
  final Map post;
  final String postId;

  const PostCard({
    super.key,
    required this.post,
    required this.postId,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FeedController>();
    final currentUser = FirebaseAuth.instance.currentUser!.uid;

    final likedBy = Map<String, dynamic>.from(post["likedBy"] ?? {});
    final isLiked = likedBy.containsKey(currentUser);

    final userId = post["userId"] ?? "";

    return StreamBuilder(
      stream: FirebaseDatabase.instance.ref("users/$userId").onValue,
      builder: (context, snapshot) {
        final userData = snapshot.data?.snapshot.value as Map?;

        final userName = userData?["name"] ?? "User";
        final online = userData?["online"] ?? false;

        return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
              )
            ],
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// ================= USER ROW =================
              Row(
                children: [

                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.deepPurple.shade100,
                        child: Text(
                          userName.isNotEmpty
                              ? userName[0].toUpperCase()
                              : "U",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold),
                        ),
                      ),

                      if (online)
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            height: 10,
                            width: 10,
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),

                  SizedBox(width: 10.w),

                  Expanded(
                    child: Text(
                      userName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10.h),

              /// ================= POST TEXT =================
              Text(
                post["text"] ?? "",
                style: const TextStyle(fontSize: 14),
              ),

              SizedBox(height: 10.h),

              /// ================= IMAGE =================
              // if ((post["image"] ?? "").toString().isNotEmpty)
              //   ClipRRect(
              //     borderRadius: BorderRadius.circular(12),
              //     child: Image.network(
              //       post["image"],
              //       height: 180,
              //       width: double.infinity,
              //       fit: BoxFit.cover,
              //     ),
              //   ),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  (post["image"] ?? "").toString().isNotEmpty
                      ? post["image"]
                      : "https://images.unsplash.com/photo-1522202176988-66273c2fd55f",
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,

                  /// fallback if network fails
                  errorBuilder: (context, error, stackTrace) {
                    return Image.network(
                      "https://images.unsplash.com/photo-1522202176988-66273c2fd55f",
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
              SizedBox(height: 10.h),

              /// ================= LIKE SECTION =================
              Row(
                children: [

                  GestureDetector(
                    onTap: () {
                      // controller.likePost(postId, likedBy);
                      controller.likePost(postId);
                    },
                    child: Icon(
                      Icons.favorite,
                      color: isLiked ? Colors.red : Colors.grey,
                      size: 22,
                    ),
                  ),

                  SizedBox(width: 6.w),

                  Text(
                    "${post["likes"] ?? 0}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  SizedBox(width: 10.w),

                  const Text(
                    "Like",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}