import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/meal_provider.dart';
import '../screens/meal_screen.dart';

class LiveRecipeCard extends ConsumerWidget {
  const LiveRecipeCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncMeal = ref.watch(randomMealProvider);

    return asyncMeal.when(
      data: (meal) {
        final image = meal.imageUrl.isNotEmpty
            ? meal.imageUrl
            : 'https://via.placeholder.com/500';

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MealDetailsScreen(
                  id: meal.id,
                  title: meal.title,
                  imageUrl: meal.imageUrl,
                  instructions: meal.instructions,
                  ingredients: meal.ingredients,
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
                  // 🔄 Reload button (top-right) - triggers provider refresh
                  Positioned(
                    top: 12,
                    right: 12,
                    child: InkWell(
                      onTap: () => ref.refresh(randomMealProvider),
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

                  // Title (bottom-left)
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Text(
                      meal.title,
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
      },
      loading: () => Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        height: 220,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          color: Colors.grey[300],
        ),
        child: const Center(child: CircularProgressIndicator()),
      ),
      error: (err, st) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          height: 220,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            color: Colors.grey[300],
          ),
          child: Center(
            child: Text(
              'Error loading recipe',
              style: TextStyle(color: Colors.red.shade700),
            ),
          ),
        );
      },
    );
  }
}
