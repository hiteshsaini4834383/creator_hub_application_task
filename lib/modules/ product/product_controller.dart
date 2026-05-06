import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  final DatabaseReference db = FirebaseDatabase.instance.ref("products");

  var products = <Map>[].obs;

  /// FETCH PRODUCTS (REALTIME)
  void fetchProducts() {
    db.onValue.listen((event) {
      final data = event.snapshot.value;

      if (data != null) {
        final map = Map<String, dynamic>.from(data as Map);

        products.value = map.entries.map((e) {
          return {
            "id": e.key,
            ...Map<String, dynamic>.from(e.value),
          };
        }).toList();
      }
    });
  }

  /// ADD PRODUCT
  Future<void> addProduct({
    required String title,
    required String price,
  }) async {
    final ref = db.push();

    await ref.set({
      "id": ref.key,
      "title": title,
      "price": price,
      "image":
      "https://images.unsplash.com/photo-1523275335684-37898b6baf30", // dummy image
      "createdAt": DateTime.now().millisecondsSinceEpoch,
    });
  }
}