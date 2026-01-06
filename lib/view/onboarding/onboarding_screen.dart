import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'onboarding_page.dart';
import '../WelcomePage.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int currentIndex = 0;

  final int totalPages = 3;

  bool get isLastPage => currentIndex == totalPages - 1;

  void nextPage() {
    if (!isLastPage) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Stack(
          children: [
            /// PageView
            PageView(
              controller: _controller,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              children: [
                 OnboardingPage(
                  title: 'Find Your Perfect Apartment'.tr,
                  subtitle: "The easiest and fastest way to book apartments".tr,
                  image: "images/House searching-rafiki.png",
                ),
                 OnboardingPage(
                  title: "Choose With Confidence".tr,
                  subtitle:
                      "Clear photos, full details, and transparent prices".tr,
                  image: "images/Apartment rent-amico.png",
                ),

                /// آخر صفحة onboarding
                OnboardingPage(
                  title: "Ready to Get Started?".tr,
                  subtitle: "Start your journey with MR.Dar today".tr,
                  image: "images/Apartment rent-pana.png",
                  bottomWidget: ElevatedButton(
                    onPressed: () {
                      Get.offAll(() => const WelcomePage());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child:  Text(
                      "Get Started".tr,
                      style: TextStyle(fontSize: 18, color:  Theme.of(context).colorScheme.onPrimary),
                    ),
                  ),
                ),
              ],
            ),

            /// Skip button (يختفي بالصفحة الأخيرة)
            if (!isLastPage)
              Positioned(
                top: 10,
                right: 10,
                child: TextButton(
                  onPressed: () {
                    _controller.animateToPage(
                      totalPages - 1,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );
                  },
                  child:  Text(
                    "Skip".tr,
                    style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.primary
                  ),
                  ),
                ),
              ),

            /// Dots + Next
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  /// Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(totalPages, (index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        width: currentIndex == index ? 20 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: currentIndex == index
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 20),

                  /// Next (يختفي بآخر صفحة)
                  if (!isLastPage)
                    ElevatedButton(
                      onPressed: nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        "Next".tr,
                        style: TextStyle(fontSize: 18, color:  Theme.of(context).colorScheme.onPrimary),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
