import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String receiverId,
    required String message,
  }) async {
    try {
      final chatDoc = _db.collection('chats').doc(chatId);

      /// Ensure chat exists
      await chatDoc.set({
        'participants': [senderId, receiverId],
        'lastMessage': message,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      /// Add message
      await chatDoc.collection('messages').add({
        'senderId': senderId,
        'receiverId': receiverId,
        'text': message,
        'timestamp': FieldValue.serverTimestamp(),
      });

    } catch (e) {
      print("❌ SEND ERROR: $e");
      rethrow;
    }
  }
  /// SEND MESSAGE
  Future<void> _sendMessage({
    required String chatId,
    required String senderId,
    required String receiverId, // ✅ ADD THIS
    required String message,
  }) async {
    try {
      log("🔥 [SEND_MESSAGE] chatId: $chatId");
      log("🔥 [SEND_MESSAGE] senderId: $senderId");
      log("🔥 [SEND_MESSAGE] message: $message");

      final chatDoc = _db.collection('chats').doc(chatId);

      /// 🔥 Ensure chat document exists
      await chatDoc.set({
        'participants': [senderId, receiverId], // can update later with both users
        'lastMessage': message,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      final messageRef = chatDoc.collection('messages');

      final docRef = await messageRef.add({
        'senderId': senderId,
        'text': message,
        'timestamp': FieldValue.serverTimestamp(),
      });

      log("✅ [SEND_SUCCESS] messageId: ${docRef.id}");
    } catch (e, stack) {
      log("❌ [SEND_ERROR]: $e");
      log("❌ [STACK]: $stack");
      rethrow;
    }
  }

  /// REAL-TIME STREAM
  Stream<QuerySnapshot> getMessages(String chatId) {
    log("📡 [STREAM_START] chatId: $chatId");

    return _db
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}