

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'chat_view.dart';

class ChatListView extends StatelessWidget {
  const ChatListView({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: const Color(0xfff6f7fb),

      /// ================= APP BAR =================
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        title: const Text(
          "Chats",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      /// ================= BODY =================

      body: StreamBuilder(
        stream: FirebaseDatabase.instance.ref("users").onValue,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return ListView.builder(
              itemCount: 6,
              itemBuilder: (context, index) => Container(
                margin: EdgeInsets.all(12),
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }

          final data = snapshot.data!.snapshot.value;

          if (data == null) {
            return const Center(child: Text("No users found"));
          }

          final users = Map<String, dynamic>.from(data as Map);

          final list = users.entries.where((e) {
            return e.key != currentUser;
          }).toList();

          return ListView.builder(
            padding: EdgeInsets.only(bottom: 80.h, top: 10.h),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final userId = list[index].key;
              final user = list[index].value;

              final name = user['name'] ?? "User";
              final online = user['online'] ?? false;

              return Container(
                margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),

                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 8.h,
                  ),

                  /// ================= AVATAR =================
                  leading: Stack(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.deepPurple.shade100,
                        child: Text(
                          name.isNotEmpty ? name[0].toUpperCase() : "U",
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

                  /// ================= NAME =================
                  title: Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),

                  /// ================= LAST MESSAGE =================
                  subtitle: StreamBuilder(
                    stream: FirebaseDatabase.instance.ref("chats").onValue,
                    builder: (context, chatSnap) {
                      String lastMsg = "Start chatting...";

                      if (chatSnap.hasData &&
                          chatSnap.data!.snapshot.value != null) {
                        final chats = Map<String, dynamic>.from(
                          chatSnap.data!.snapshot.value as Map,
                        );

                        try {
                          final chat = chats.values.firstWhere((c) {
                            final participants =
                            Map<String, dynamic>.from(c['participants'] ?? {});
                            return participants.containsKey(currentUser) &&
                                participants.containsKey(userId);
                          });

                          lastMsg = chat['lastMessage'] ?? "Start chatting...";
                        } catch (e) {
                          lastMsg = "Start chatting...";
                        }
                      }

                      return Text(
                        lastMsg,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      );
                    },
                  ),

                  /// ================= CHAT ICON RIGHT =================
                  trailing: Icon(
                    Icons.chat_bubble_outline,
                    color: Colors.deepPurple,
                    size: 20,
                  ),

                  onTap: () {
                    Get.to(() => ChatView(otherUserId: userId));
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// ================= TIME FORMAT =================
  String _formatTime(int timestamp) {
    if (timestamp == 0) return "";
    final dt = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
  }
}