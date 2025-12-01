import 'package:flutter/material.dart';

class RecipeHeader extends StatelessWidget {
  final String title;
  final bool isFavorite;
  final VoidCallback onBack;
  final VoidCallback onFavorite;

  const RecipeHeader({
    super.key,
    required this.title,
    required this.isFavorite,
    required this.onBack,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 50, // status bar
        left: 16,
        right: 16,
      ),
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          GestureDetector(
            onTap: onBack,
            child: const Icon(Icons.arrow_back, size: 28),
          ),

          // Recipe title
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Favorite button
          GestureDetector(
            onTap: onFavorite,
            child: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              size: 28,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
