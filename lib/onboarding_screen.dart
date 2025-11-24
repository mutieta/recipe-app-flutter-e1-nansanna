// lib/onboarding_screen.dart

import 'package:flutter/material.dart';
import 'package:lab3/main.dart'; // Make sure to import your main app screen (or home screen)

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  // Controller to keep track of which page we're on
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // List of pages
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      _buildPage(
        title: "Find Your Next Favorite Meal",
        body: "Thousands of recipes in your pocket. Ready to get cooking?",
        imagePath: 'assets/onboarding1.png', // Placeholder image
      ),
      _buildPreferencesPage(),
      _buildIngredientsPage(),
      _buildFinalPage(),
    ];
  }

  // Generic page builder
  Widget _buildPage({required String title, required String body, required String imagePath}) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // You can use Image.network() for network images
          Image.asset(imagePath, height: 300),
          const SizedBox(height: 40),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            body,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  // Page 2: Preferences
  Widget _buildPreferencesPage() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "What are your cooking goals?",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text(
            "Select your preferences to get personalized recipe suggestions.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          const SizedBox(height: 32),
          // Using Wrap to let items flow to the next line
          Wrap(
            spacing: 12.0,
            runSpacing: 12.0,
            alignment: WrapAlignment.center,
            children: [
              _buildPreferenceChip("Quick & Easy", Icons.timer_outlined),
              _buildPreferenceChip("Healthy", Icons.favorite_border),
              _buildPreferenceChip("Vegetarian", Icons.eco_outlined),
              _buildPreferenceChip("Baking", Icons.cake_outlined),
            ],
          )
        ],
      ),
    );
  }

  // Helper for preference chips
  Widget _buildPreferenceChip(String label, IconData icon) {
    return Chip(
      label: Text(label),
      avatar: Icon(icon, size: 20),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }

  // Page 3: Ingredients
  Widget _buildIngredientsPage() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Cook with what you have",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text(
            "Tell us a few ingredients you have on hand.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          const SizedBox(height: 32),
          TextField(
            decoration: InputDecoration(
              hintText: "e.g., chicken, tomatoes...",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Final Page to get started
  Widget _buildFinalPage() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.restaurant_menu, size: 100, color: Colors.green),
          const SizedBox(height: 40),
          const Text(
            "You're all set!",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text(
            "Let's find some delicious recipes for you.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            ),
            onPressed: _finishOnboarding,
            child: const Text("Get Started"),
          )
        ],
      ),
    );
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _goToNextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  void _finishOnboarding() {
    // Here you would typically save a flag to shared_preferences
    // to not show this screen again.
    // For now, we'll just navigate to the home screen.
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MyHomePage(title: 'My Recipe App')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                children: _pages,
              ),
            ),
            // Bottom Controls
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Skip Button
                  TextButton(
                    onPressed: _finishOnboarding,
                    child: const Text("Skip"),
                  ),

                  // Dots Indicator
                  Row(
                    children: List.generate(_pages.length, (index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: _currentPage == index ? 24 : 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index ? Colors.blue : Colors.grey,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      );
                    }),
                  ),

                  // Next Button
                  if (_currentPage < _pages.length - 1)
                    ElevatedButton(
                      onPressed: _goToNextPage,
                      child: const Text("Next"),
                    )
                  else
                  // Show an empty container to keep the layout consistent
                    const SizedBox(width: 70), // Adjust width to match button
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}