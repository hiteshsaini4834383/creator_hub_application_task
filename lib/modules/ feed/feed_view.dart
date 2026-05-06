
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import ' widgets/create_post_sheet.dart';
import ' widgets/post_card.dart';
import '../auth/login/login_view.dart';
import 'feed_controller.dart';

class FeedView extends StatefulWidget {
  const FeedView({super.key});

  @override
  State<FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView> {
  final controller = Get.put(FeedController());
  final ScrollController scrollController = ScrollController();

  bool isScrolled = false;

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (scrollController.offset > 30 && !isScrolled) {
        setState(() => isScrolled = true);
      } else if (scrollController.offset <= 30 && isScrolled) {
        setState(() => isScrolled = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f7fb),

      /// ================= APP BAR =================
      // appBar: AppBar(
      //   title: const Text(
      //     "Feed",
      //     style: TextStyle(
      //       color: Colors.black,
      //       fontWeight: FontWeight.bold,
      //     ),
      //   ),
      //   centerTitle: true,
      //
      //   elevation: 0,
      //   foregroundColor: Colors.white,
      //
      //   backgroundColor: isScrolled
      //       ? Colors.deepPurple
      //       : Colors.transparent,
      //
      //   flexibleSpace: AnimatedContainer(
      //     duration: const Duration(milliseconds: 300),
      //     decoration: BoxDecoration(
      //       gradient: isScrolled
      //           ? const LinearGradient(
      //         colors: [Colors.white, Colors.white],
      //       )
      //           : const LinearGradient(
      //         colors: [Colors.white, Colors.white],
      //       ),
      //     ),
      //   ),
      // ),
      appBar: AppBar(
        title: const Text(
          "Feed",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,

        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,

        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: () {
              Get.dialog(
                Center(
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      width: 300,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          )
                        ],
                      ),

                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          /// ICON
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.logout,
                              color: Colors.red,
                              size: 30,
                            ),
                          ),

                          const SizedBox(height: 15),

                          /// TITLE
                          const Text(
                            "Logout?",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),

                          /// SUBTITLE
                          const Text(
                            "Are you sure you want to logout?",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),

                          const SizedBox(height: 20),

                          /// BUTTONS
                          Row(
                            children: [

                              /// CANCEL
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => Get.back(),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text("Cancel"),
                                ),
                              ),

                              const SizedBox(width: 12),

                              /// LOGOUT
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    Get.back();

                                    await controller.logout();

                                    Get.deleteAll(force: true);

                                    Get.offAll(() => const LoginView());
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text("Logout"),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                barrierDismissible: true,
              );
            },
          ),
        ],
      ),
      /// ================= BODY =================
      // body: StreamBuilder(
      //   stream: FirebaseDatabase.instance.ref("posts").onValue,
      //   builder: (context, snapshot) {
      //     if (!snapshot.hasData) {
      //       return const Center(child: CircularProgressIndicator());
      //     }
      //
      //     final data = snapshot.data!.snapshot.value;
      //
      //     if (data == null) {
      //       return const Center(child: Text("No posts yet"));
      //     }
      //
      //     final posts = Map<String, dynamic>.from(data as Map);
      //     final list = posts.entries.toList();
      //
      //     list.sort((a, b) =>
      //         b.value["createdAt"].compareTo(a.value["createdAt"]));
      //
      //     return ListView.builder(
      //       controller: scrollController,
      //       padding: EdgeInsets.all(12.w),
      //       itemCount: list.length,
      //       itemBuilder: (context, index) {
      //         final postId = list[index].key;
      //         final post = list[index].value;
      //
      //         return Container(
      //           margin: EdgeInsets.only(bottom: 14.h),
      //
      //           decoration: BoxDecoration(
      //             color: Colors.white,
      //
      //             /// 🔥 BORDER + SHADOW (NEW LOOK)
      //             borderRadius: BorderRadius.circular(16.r),
      //             border: Border.all(
      //               color: Colors.grey.shade200,
      //               width: 1,
      //             ),
      //
      //             boxShadow: [
      //               BoxShadow(
      //                 color: Colors.black.withOpacity(0.04),
      //                 blurRadius: 10,
      //                 offset: const Offset(0, 4),
      //               )
      //             ],
      //           ),
      //
      //           child: PostCard(
      //             post: post,
      //             postId: postId,
      //           ),
      //         );
      //       },
      //     );
      //   },
      // ),
      body: StreamBuilder(
        stream: FirebaseDatabase.instance.ref("posts").onValue,
        builder: (context, snapshot) {
          /// ================= LOADING STATE (FADE PLACEHOLDER) =================
          if (!snapshot.hasData) {
            return ListView.builder(
              padding: EdgeInsets.all(12.w),
              itemCount: 6,
              itemBuilder: (context, index) {
                return AnimatedOpacity(
                  opacity: 1,
                  duration: const Duration(milliseconds: 600),
                  child: Container(
                    margin: EdgeInsets.only(bottom: 14.h),
                    height: 120.h,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                );
              },
            );
          }

          final data = snapshot.data!.snapshot.value;

          if (data == null) {
            return const Center(child: Text("No posts yet"));
          }

          final posts = Map<String, dynamic>.from(data as Map);
          final list = posts.entries.toList();

          list.sort((a, b) =>
              b.value["createdAt"].compareTo(a.value["createdAt"]));

          /// ================= REAL DATA (FADE IN LIST) =================
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: ListView.builder(
              key: ValueKey(list.length),
              controller: scrollController,
              padding: EdgeInsets.all(12.w),
              itemCount: list.length,
              itemBuilder: (context, index) {
                final postId = list[index].key;
                final post = list[index].value;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  margin: EdgeInsets.only(bottom: 14.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: Colors.grey.shade200,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: PostCard(
                    post: post,
                    postId: postId,
                  ),
                );
              },
            ),
          );
        },
      ),
      /// ================= FAB =================
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () {
          Get.bottomSheet(
            const CreatePostSheet(),
            isScrollControlled: true,
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}