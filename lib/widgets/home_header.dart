import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  final String logoPath = 'assets/images/logo.png';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        children: [
          Image.asset(
            logoPath,
            height: 60,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 10),
          const Text(
            "Welcome to RecipeApp!",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
