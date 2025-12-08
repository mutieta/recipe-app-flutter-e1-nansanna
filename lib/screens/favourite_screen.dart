import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/favorites_provider.dart';
// NOTE: Make sure this import points to your Meal Details Screen
import '../screens/meal_screen.dart'; 

class FavouriteScreen extends ConsumerWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoritesProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Favorite Recipes',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: favoritesAsync.when(
        // --- DATA STATE ---
        data: (meals) {
          if (meals.isEmpty) {
            // ... (Empty state UI remains the same) ...
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "No favorite recipes yet!",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Tap the heart icon on any recipe to save it.",
                    style: TextStyle(color: Colors.black45),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: meals.length,
            itemBuilder: (context, index) {
              final meal = meals[index];
              
              // 💅 Use a Card for a prettier, modern look
              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  
                  // 🎯 IMPLEMENT NAVIGATION HERE
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => MealDetailsScreen(
                          id: meal.id,
                          title: meal.title,
                          imageUrl: meal.imageUrl,
                          instructions: meal.instructions,
                          ingredients: meal.ingredients,
                          linkVideoUrl: meal.linkVideoUrl,
                          source: meal.source,
                          area: meal.area,
                          category: meal.category,
                          tiktokUrl: meal.tiktokUrl,
                        ),
                      ),
                    );
                  },
                  
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        // 🖼️ Recipe Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            meal.imageUrl,
                            width: 80, // Increased size
                            height: 80, // Increased size
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        
                        // 📝 Title and Area/Category
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                meal.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              // Note: Re-adding Area/Category display here for context
                              Text(
                                meal.area != null && meal.area!.isNotEmpty
                                    ? meal.area!
                                    : meal.category ?? 'Recipe',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // 🗑️ Remove Favorite Button
                        IconButton(
                          icon: Icon(
                            Icons.favorite,
                            color: Colors.red.shade600,
                          ),
                          onPressed: () {
                            ref
                                .read(favoritesProvider.notifier)
                                .removeFavorite(meal.id);
                            // Show a small snackbar confirmation
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${meal.title} removed from favorites.'),
                                duration: const Duration(milliseconds: 1200),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        
        // --- LOADING STATE ---
        loading: () => const Center(child: CircularProgressIndicator()),
        
        // --- ERROR STATE ---
        error: (err, st) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Oops! Could not load favorites.\nError: $err",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ),
      ),
    );
  }
}