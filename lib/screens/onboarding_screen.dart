import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lab3/screens/homescreen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // 1. YOUR IMAGE PATHS HERE
  final List<String> _onboardingImages = [
    'assets/images/onboarding1.png',
    'assets/images/onboarding2.png',
    'assets/images/onboarding3.png',
  ];

  @override
  void initState() {
    super.initState();
       rootBundle
        .loadString('AssetManifest.json')
        .then((manifest) {
          debugPrint('--- AssetManifest.json ---');
           final lines = manifest.split('\n');
          for (final line in lines) {
            if (line.contains('onboarding')) debugPrint(line);
          }
          debugPrint('--- end manifest ---');
        })
        .catchError((e) {
          debugPrint('Could not read AssetManifest.json: $e');
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // 2. TOP SECTION: SKIP BUTTON (Top Right)
            Padding(
              padding: const EdgeInsets.only(top: 16.0, right: 16.0),
              child: Align(
                alignment: Alignment.topRight,
                child: _currentPage == _onboardingImages.length - 1
                    ? const SizedBox(
                        height: 48,
                      ) // Hide Skip on last page, keep space
                    : TextButton(
                        onPressed: _finishOnboarding,
                        child: const Text(
                          "Skip",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
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
                itemCount: _onboardingImages.length,
                itemBuilder: (context, index) =>
                    _buildPage(imagePath: _onboardingImages[index]),
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
                    children: List.generate(_onboardingImages.length, (index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: _currentPage == index ? 24 : 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? Colors.yellow[800]
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                      );
                    }),
                  ),

                  // Next / Start Button (Right Side)
                  ElevatedButton(
                    onPressed: () {
                      if (_currentPage == _onboardingImages.length - 1) {
                        _finishOnboarding();
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow[800],
                      foregroundColor: Colors.black,
                    ),
                    child: Text(
                      _currentPage == _onboardingImages.length - 1
                          ? "Start"
                          : "Next",
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

  // Page Builder Helper (images only)
  Widget _buildPage({required String imagePath}) {
    // Use a Stack so the image can be full-bleed (background) and we can
    // still show an error message if the asset fails to load.
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background image (full cover)
        Image.asset(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // Log the error to console so user can see the reason in terminal
            debugPrint('Failed to load asset: $imagePath -> $error');
            return const Center(
              child: Icon(Icons.broken_image, size: 64, color: Colors.white),
            );
          },
        ),

        // Slight overlay for better contrast (optional)
        Container(color: const Color.fromRGBO(0, 0, 0, 0.12)),
      ],
    );
  }

  void _finishOnboarding() {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
  }
}
