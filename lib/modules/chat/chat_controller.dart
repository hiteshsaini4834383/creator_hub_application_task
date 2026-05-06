
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/services/realtime_dbservice.dart';

class ChatController extends GetxController {
  final RealtimeDbService _db = RealtimeDbService();

  final messageController = TextEditingController();
  var isSending = false.obs;

  String chatId = "";
  String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  String otherUserId = "";

  void initChat(String otherUser) {
    otherUserId = otherUser;

    List ids = [currentUserId, otherUserId];
    ids.sort();
    chatId = ids.join("_");

    _db.createChat(chatId, currentUserId, otherUserId);
  }

  Stream getMessages() {
    return _db.getMessages(chatId);
  }

  Future<void> sendMessage() async{
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    isSending.value = true;

    await _db.sendMessage(
      chatId: chatId,
      senderId: currentUserId,
      receiverId: otherUserId,
      message: text,
    );

    messageController.clear();
    isSending.value = false;
  }
}