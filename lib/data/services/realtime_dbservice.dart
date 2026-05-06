// import 'package:firebase_database/firebase_database.dart';
// import 'dart:developer';
//
// class RealtimeDbService {
//   final DatabaseReference _db = FirebaseDatabase.instance.ref();
//
//   /// SEND MESSAGE
//   Future<void> sendMessage({
//     required String chatId,
//     required String senderId,
//     required String receiverId,
//     required String message,
//   }) async {
//     try {
//       log("🔥 [RTDB SEND] $message");
//
//       /// Chat node
//       final chatRef = _db.child("chats/$chatId");
//
//       /// Ensure chat exists
//       await chatRef.update({
//         "participants/$senderId": true,
//         "participants/$receiverId": true,
//         "lastMessage": message,
//         "updatedAt": DateTime.now().millisecondsSinceEpoch,
//       });
//
//       /// Message node
//       final msgRef = _db.child("messages/$chatId").push();
//
//       await msgRef.set({
//         "senderId": senderId,
//         "receiverId": receiverId,
//         "text": message,
//         "timestamp": DateTime.now().millisecondsSinceEpoch,
//       });
//
//       log("✅ MESSAGE SENT");
//
//     } catch (e) {
//       log("❌ ERROR: $e");
//       rethrow;
//     }
//   }
//
//   /// STREAM MESSAGES
//   Stream<DatabaseEvent> getMessages(String chatId) {
//     return _db
//         .child("messages/$chatId")
//         .orderByChild("timestamp")
//         .onValue;
//   }
//
//   /// GET CHAT LIST
//   Stream<DatabaseEvent> getChats() {
//     return _db.child("chats").onValue;
//   }
// }
import 'package:firebase_database/firebase_database.dart';

class RealtimeDbService {
  final db = FirebaseDatabase.instance.ref();

  /// SEND MESSAGE
  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String receiverId,
    required String message,
  }) async {
    final msgRef = db.child("chats/$chatId/messages").push();

    await msgRef.set({
      "senderId": senderId,
      "receiverId": receiverId,
      "text": message,
      "timestamp": DateTime.now().millisecondsSinceEpoch,
    });

    await db.child("chats/$chatId").update({
      "lastMessage": message,
      "updatedAt": DateTime.now().millisecondsSinceEpoch,
    });
  }

  /// GET MESSAGES
  Stream<DatabaseEvent> getMessages(String chatId) {
    return db.child("chats/$chatId/messages").onValue;
  }

  /// GET CHATS
  Stream<DatabaseEvent> getChats() {
    return db.child("chats").onValue;
  }

  /// CREATE CHAT IF NOT EXISTS
  Future<void> createChat(String chatId, String uid1, String uid2) async {
    await db.child("chats/$chatId").update({
      "participants": {
        uid1: true,
        uid2: true,
      }
    });
  }
}