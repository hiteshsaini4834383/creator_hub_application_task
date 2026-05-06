
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class FeedController extends GetxController {
  final DatabaseReference db = FirebaseDatabase.instance.ref();

  final postController = TextEditingController();
  final picker = ImagePicker();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var imageFile = Rxn<File>();
  var isLoading = false.obs;

  /// ✅ SAFE USER ID
  String? currentUserId;

  @override
  void onInit() {
    super.onInit();

    final user = _auth.currentUser;
    currentUserId = user?.uid;
  }

  /// PICK IMAGE
  Future<void> pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      imageFile.value = File(picked.path);
    }
  }

  /// LOGOUT
  Future<void> logout() async {
    await _auth.signOut();

    postController.clear();
    imageFile.value = null;
    currentUserId = null;
  }

  /// UPLOAD IMAGE
  Future<String> uploadImage(File file) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('posts/${DateTime.now().millisecondsSinceEpoch}.jpg');

    await ref.putFile(file);

    return await ref.getDownloadURL();
  }

  /// CREATE POST (SAFE)
  Future<void> createPost({required String text}) async {
    if (currentUserId == null) {
      Get.snackbar("Error", "User not logged in");
      return;
    }

    if (text.trim().isEmpty && imageFile.value == null) {
      Get.snackbar("Error", "Write something or add image");
      return;
    }

    isLoading.value = true;

    try {
      String imageUrl = "";

      /// upload image if exists
      if (imageFile.value != null) {
        imageUrl = await uploadImage(imageFile.value!);
      }

      final postRef = db.child("posts").push();

      await postRef.set({
        "postId": postRef.key,
        "userId": currentUserId ?? "",
        "text": text,
        "image": imageUrl,
        "likes": 0,
        "likedBy": {},
        "createdAt": DateTime.now().millisecondsSinceEpoch,
      });

      postController.clear();
      imageFile.value = null;

    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// LIKE POST
  Future<void> likePost(String postId) async {
    if (currentUserId == null) return;

    final postRef = db.child("posts/$postId");

    await postRef.runTransaction((data) {
      if (data == null) return Transaction.abort();

      final Map post = Map<String, dynamic>.from(data as Map);

      Map likedBy = Map<String, dynamic>.from(post["likedBy"] ?? {});
      int likes = post["likes"] ?? 0;

      if (likedBy.containsKey(currentUserId)) {
        likedBy.remove(currentUserId);
        likes--;
      } else {
        likedBy[currentUserId!] = true;
        likes++;
      }

      post["likedBy"] = likedBy;
      post["likes"] = likes;

      return Transaction.success(post);
    });
  }
}