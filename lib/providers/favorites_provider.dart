import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/meal.dart';
import '../services/db_service.dart';

// 📌 StateNotifier for managing favorite meals
class FavoritesNotifier extends StateNotifier<AsyncValue<List<Meal>>> {
  FavoritesNotifier() : super(const AsyncValue.loading()) {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      final meals = await DbService.instance.getFavoriteMeals();
      state = AsyncValue.data(meals);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addFavorite(Meal meal) async {
    try {
      await DbService.instance.insertMeal(meal);
      await _loadFavorites();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> removeFavorite(String mealId) async {
    try {
      await DbService.instance.deleteMeal(mealId);
      await _loadFavorites();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<bool> isFavorite(String mealId) async {
    return await DbService.instance.isFavorite(mealId);
  }
}

// 💾 Provider for managing favorites
final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, AsyncValue<List<Meal>>>((ref) {
      return FavoritesNotifier();
    });

// 🔍 Provider to check if a specific meal is favorited
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
