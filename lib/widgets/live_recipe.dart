import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../services/api_service.dart';
import '../screens/meal_screen.dart';
import 'dart:math';

class LiveRecipeCard extends StatefulWidget {
  const LiveRecipeCard({super.key});

  @override
  State<LiveRecipeCard> createState() => _LiveRecipeCardState();
}

class _LiveRecipeCardState extends State<LiveRecipeCard> {
  Meal? meal; // store fetched meal
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _fetchRandomMeal();
  }

  Future<void> _fetchRandomMeal() async {
    setState(() => loading = true);
    try {
      final meals = await ApiService.fetchMeals();
      final mealsWithImages =
          meals.where((m) => m.imageUrl.isNotEmpty).toList(); // filter
      if (mealsWithImages.isNotEmpty) {
        final randomIndex = Random().nextInt(mealsWithImages.length);
        meal = mealsWithImages[randomIndex];
      }
    } catch (e) {
      debugPrint("Error fetching meal: $e");
    }
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (loading || meal == null) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        height: 220,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          color: Colors.grey[300],
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    final image = meal!.imageUrl.isNotEmpty
        ? meal!.imageUrl
        : "https://via.placeholder.com/500"; // fallback

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MealDetailsScreen(
              id: meal!.id,
              title: meal!.title,
              imageUrl: meal!.imageUrl,
              instructions: meal!.instructions,
              ingredients: meal!.ingredients,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        height: 220,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          image: DecorationImage(
            image: NetworkImage(image),
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
                  onTap: _fetchRandomMeal,
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
              Positioned(
                bottom: 16,
                left: 16,
                child: Text(
                  meal!.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
