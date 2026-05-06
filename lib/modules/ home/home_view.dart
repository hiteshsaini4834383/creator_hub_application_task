import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../ feed/feed_view.dart';
import '../ product/product_list_view.dart';
// import '../product/product_list_view.dart';
import '../chat/chat_list_view.dart';
import 'home_controller.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  // ✅ Responsive helper — call once, use everywhere
  static _NavSizes _getSizes(BuildContext context) {
    final mq = MediaQuery.of(context);
    final shortestSide = mq.size.shortestSide;
    final isTablet = shortestSide >= 600;
    final isLargeTablet = shortestSide >= 900;

    return _NavSizes(
      barHeight:    isLargeTablet ? 80.0 : isTablet ? 68.0 : 60.0,
      iconSize:     isLargeTablet ? 30.0 : isTablet ? 26.0 : 22.0,
      fontSize:     isLargeTablet ? 14.0 : isTablet ? 12.0 : 11.0,
      spacing:      isLargeTablet ?  6.0 : isTablet ?  4.0 :  2.0,
      itemWidth:    isLargeTablet ? 120.0 : isTablet ? 100.0 : 80.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    final pages = [
      const FeedView(),
      const ChatListView(),
      const ProductListView(),
    ];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        if (controller.selectedIndex.value != 0) {
          controller.changeTab(0);
        } else {
          final shouldExit = await _showExitDialog(context);
          if (shouldExit == true) SystemNavigator.pop();
        }
      },
      child: Scaffold(
        body: Obx(() => pages[controller.selectedIndex.value]),
        // ✅ Use LayoutBuilder so nav re-computes on orientation change
        bottomNavigationBar: LayoutBuilder(
          builder: (context, constraints) {
            final sizes = _getSizes(context);
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                // ✅ SafeArea handles notch/home-bar on all phones & tablets
                child: SizedBox(
                  height: sizes.barHeight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _navItem(Icons.home_rounded,     "Feed",     0, controller, sizes),
                      _navItem(Icons.chat_rounded,     "Chat",     1, controller, sizes),
                      _navItem(Icons.shopping_bag_rounded, "Products", 2, controller, sizes),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _navItem(
      IconData icon,
      String label,
      int index,
      HomeController controller,
      _NavSizes sizes,
      ) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => controller.changeTab(index),
      child: Obx(() {
        final isSelected = controller.selectedIndex.value == index;
        return SizedBox(
          width: sizes.itemWidth,
          child: Column(
            mainAxisSize: MainAxisSize.min,       // ✅ never overflows
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(
                  horizontal: sizes.iconSize * 0.5,
                  vertical:   sizes.iconSize * 0.2,
                ),
                decoration: BoxDecoration(
                  // ✅ Pill indicator on selected tab
                  color: isSelected
                      ? const Color(0xFF1E3A8A).withOpacity(0.12)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(
                  icon,
                  size: sizes.iconSize,
                  color: isSelected
                      ? const Color(0xFF1E3A8A)
                      : Colors.grey.shade500,
                ),
              ),
              SizedBox(height: sizes.spacing),
              Text(
                label,
                style: TextStyle(
                  fontSize: sizes.fontSize,
                  color: isSelected
                      ? const Color(0xFF1E3A8A)
                      : Colors.grey.shade500,
                  fontWeight:
                  isSelected ? FontWeight.w700 : FontWeight.w400,
                  // ✅ Prevent text from wrapping on narrow phones
                  letterSpacing: 0.2,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        );
      }),
    );
  }

  Future<bool?> _showExitDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.exit_to_app_rounded,
                  color: Colors.redAccent, size: 48),
              const SizedBox(height: 16),
              const Text("Exit App?",
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text("Are you sure you want to exit?",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54)),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E3A8A)),
                    child: const Text("Exit",
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ✅ Immutable size bundle — computed once per build
class _NavSizes {
  final double barHeight;
  final double iconSize;
  final double fontSize;
  final double spacing;
  final double itemWidth;

  const _NavSizes({
    required this.barHeight,
    required this.iconSize,
    required this.fontSize,
    required this.spacing,
    required this.itemWidth,
  });
}