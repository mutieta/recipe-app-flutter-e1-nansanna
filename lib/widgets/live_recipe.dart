import 'package:flutter/material.dart';
import 'dart:math';

class LiveRecipeCard extends StatefulWidget {
  const LiveRecipeCard({super.key});

  @override
  State<LiveRecipeCard> createState() => _LiveRecipeCardState();
}

class _LiveRecipeCardState extends State<LiveRecipeCard> {
  String imageUrl = "https://picsum.photos/500";

  void _reloadRecipe() {
    // Generate a new random image from picsum
    final randomNum = Random().nextInt(300) + 200;
    setState(() {
      imageUrl = "https://picsum.photos/$randomNum";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          color: Colors.black.withOpacity(0.3),
        ),
        child: Stack(
          children: [
            // 🔄 Reload Button (Top Right)
            Positioned(
              top: 12,
              right: 12,
              child: InkWell(
                onTap: _reloadRecipe,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white70,
                  ),
                  child: const Icon(
                    Icons.refresh,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
              ),
            ),

            // Text (Bottom Left)
            const Positioned(
              bottom: 16,
              left: 16,
              child: Text(
                "You might like this !",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
