import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/meal.dart';
import '../services/db_service.dart';

// StateNotifier for managing favorite meals
class FavoritesNotifier extends StateNotifier<AsyncValue<List<Meal>>> {
  FavoritesNotifier() : super(const AsyncValue.loading()) {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      final meals = await DbService.instance.getFavoriteMeals();
      state = AsyncValue.data(meals);
    } catch (e, st) {
      print('CRITICAL ERROR LOADING FAVORITES: $e'); // Print error for debugging
      state = AsyncValue.error(e, st);
    }
  }

  // OPTIMIZED: Update in-memory state FIRST, then update DB.
  Future<void> addFavorite(Meal meal) async {
    if (state.hasValue) {
      // 1. Optimistic Update: Add to the current list
      final updatedList = [...state.value!, meal];
      state = AsyncValue.data(updatedList);
    }
    
    // 2. Perform Database Operation
    try {
      await DbService.instance.insertMeal(meal);
    } catch (e) {
      // If DB fails, revert the state (optional but good practice)
      print('DB INSERT FAILED: $e');
      _loadFavorites(); // Fallback to full reload if insertion failed
    }
  }

  // OPTIMIZED: Update in-memory state FIRST, then update DB.
  Future<void> removeFavorite(String mealId) async {
    if (state.hasValue) {
      // 1. Optimistic Update: Filter out the meal from the current list
      final updatedList = state.value!.where((m) => m.id != mealId).toList();
      state = AsyncValue.data(updatedList);
    }

    // 2. Perform Database Operation
    try {
      await DbService.instance.deleteMeal(mealId);
    } catch (e) {
      // If DB fails, revert the state
      print('DB DELETE FAILED: $e');
      _loadFavorites(); // Fallback to full reload if deletion failed
    }
  }

  // This check is simple and correct, but using the other provider is better.
  Future<bool> isFavorite(String mealId) async {
    return await DbService.instance.isFavorite(mealId);
  }
}

// Provider for managing favorites
final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, AsyncValue<List<Meal>>>((ref) {
      return FavoritesNotifier();
    });

// Provider to check if a specific meal is favorited
final isMealFavoriteProvider = FutureProvider.family<bool, String>((
  ref,
  mealId,
) async {
  final favoritesAsync = ref.watch(favoritesProvider);
  return favoritesAsync.when(
    data: (favorites) => favorites.any((meal) => meal.id == mealId),
    loading: () => false,
    error: (_, __) => false,
  );
});