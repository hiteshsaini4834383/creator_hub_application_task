
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'chat_controller.dart';

class ChatView extends StatefulWidget {
  final String otherUserId;

  const ChatView({super.key, required this.otherUserId});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final controller = Get.put(ChatController());

  final ScrollController scrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    controller.initChat(widget.otherUserId);

    /// when keyboard opens → scroll bottom
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        Future.delayed(
          const Duration(milliseconds: 300),
          scrollToBottom,
        );
      }
    });
  }

  /// 🔥 AUTO SCROLL FUNCTION
  void scrollToBottom() {
    if (!scrollController.hasClients) return;

    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  /// 🔥 CALL AFTER UI BUILD
  void scrollAfterBuild() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToBottom();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f7fb),

      /// ================= APP BAR =================
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        title: const Text(
          "Chat",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      /// ================= BODY =================
      body: Column(
        children: [

          /// ================= MESSAGES =================
          Expanded(
            child: StreamBuilder(
              stream: controller.getMessages(),
              builder: (context, snapshot) {

                /// LOADING UI
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final data = snapshot.data!.snapshot.value;

                if (data == null) {
                  return const Center(child: Text("No messages"));
                }

                final map = Map<String, dynamic>.from(data as Map);
                final messages = map.entries.toList();

                messages.sort(
                      (a, b) => a.value['timestamp']
                      .compareTo(b.value['timestamp']),
                );

                /// 🔥 AUTO SCROLL ON NEW MESSAGE
                scrollAfterBuild();

                return ListView.builder(
                  controller: scrollController,
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 10.h,
                  ),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index].value;
                    final isMe =
                        msg['senderId'] == controller.currentUserId;

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      alignment: isMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      margin: EdgeInsets.symmetric(vertical: 5.h),

                      child: Container(
                        constraints: BoxConstraints(maxWidth: 260.w),
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 10.h,
                        ),

                        decoration: BoxDecoration(
                          color: isMe
                              ? Colors.deepPurple
                              : Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(14.r),
                            topRight: Radius.circular(14.r),
                            bottomLeft:
                            Radius.circular(isMe ? 14.r : 0),
                            bottomRight:
                            Radius.circular(isMe ? 0 : 14.r),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            )
                          ],
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [

                            Text(
                              msg['text'] ?? "",
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: isMe
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                            ),

                            SizedBox(height: 4.h),

                            Text(
                              _formatTime(msg['timestamp']),
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: isMe
                                    ? Colors.white70
                                    : Colors.black45,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          /// ================= INPUT BAR =================
          SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 10.w,
                vertical: 8.h,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  )
                ],
              ),

              child: Row(
                children: [

                  /// TEXT FIELD
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(25.r),
                      ),
                      child: TextField(
                        focusNode: focusNode,
                        controller: controller.messageController,

                        onTap: () {
                          Future.delayed(
                            const Duration(milliseconds: 300),
                            scrollToBottom,
                          );
                        },

                        decoration: const InputDecoration(
                          hintText: "Type a message...",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 10,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 8.w),

                  /// SEND BUTTON
                  Obx(
                        () => controller.isSending.value
                        ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                        : GestureDetector(
                      onTap: () async {
                        await controller.sendMessage();

                        Future.delayed(
                          const Duration(milliseconds: 300),
                          scrollToBottom,
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(10.w),
                        decoration: const BoxDecoration(
                          color: Colors.deepPurple,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(int t) {
    final dt = DateTime.fromMillisecondsSinceEpoch(t);
    return "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
  }
}