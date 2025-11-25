import 'package:flutter/material.dart';
import 'package:lab3/main.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // 1. CHECK YOUR IMAGE PATHS HERE
  // Ensure these match exactly where you put the files in your project folder
  final List<Map<String, String>> _onboardingData = [
    {
      "title": "Find Your Next Favorite Meal",
      "body": "Thousands of recipes in your pocket. Ready to get cooking?",
      "image": "assets/images/onboarding1.png",
    },
    {
      "title": "Cook With What You Have",
      "body": "Select ingredients you have at home and we'll find the perfect recipe.",
      "image": "assets/images/onboarding2.png",
    },
    {
      "title": "Personalized For You",
      "body": "Select your diet preferences and never see a recipe you can't eat.",
      "image": "assets/images/onboarding3.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [

            // 2. TOP SECTION: SKIP BUTTON (Top Right)
            Padding(
              padding: const EdgeInsets.only(top: 16.0, right: 16.0),
              child: Align(
                alignment: Alignment.topRight,
                child: _currentPage == _onboardingData.length - 1
                    ? const SizedBox(height: 48) // Hide Skip on last page, keep space
                    : TextButton(
                  onPressed: _finishOnboarding,
                  child: const Text("Skip", style: TextStyle(fontSize: 16)),
                ),
              ),
            ),

            // 3. MIDDLE SECTION: PAGE CONTENT
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (value) {
                  setState(() {
                    _currentPage = value;
                  });
                },
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) => _buildPage(
                  title: _onboardingData[index]['title']!,
                  body: _onboardingData[index]['body']!,
                  imagePath: _onboardingData[index]['image']!,
                ),
              ),
            ),

            // 4. BOTTOM SECTION: DOTS AND NEXT BUTTON
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Dots Indicator (Left Side)
                  Row(
                    children: List.generate(_onboardingData.length, (index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: _currentPage == index ? 24 : 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index ? Colors.blue : Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                      );
                    }),
                  ),

                  // Next / Start Button (Right Side)
                  ElevatedButton(
                    onPressed: () {
                      if (_currentPage == _onboardingData.length - 1) {
                        _finishOnboarding();
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(_currentPage == _onboardingData.length - 1 ? "Start" : "Next"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Page Builder Helper
  Widget _buildPage({required String title, required String body, required String imagePath}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image Area
          Expanded(
            flex: 3,
            child: Image.asset(
              imagePath,
              fit: BoxFit.contain,
              // Add error builder to see if image is failing to load
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Text("Image not found.\nCheck path!", textAlign: TextAlign.center, style: TextStyle(color: Colors.red)),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          // Text Area
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text(
                  body,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _finishOnboarding() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MyHomePage(title: 'Recipe App')),
    );
  }
}