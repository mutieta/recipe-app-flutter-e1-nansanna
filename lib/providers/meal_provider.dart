import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/meal.dart';
import '../services/api_service.dart';

// 🍽️ Provider for fetching all meals
final mealsProvider = FutureProvider<List<Meal>>((ref) async {
  return await ApiService.fetchMeals();
});

// 🍽️ Provider for fetching a single meal by ID
final mealByIdProvider = FutureProvider.family<Meal, String>((ref, id) async {
  return await ApiService.fetchMealById(id);
});

// 🎲 Provider for random meal (useful for random suggestion feature)
final randomMealProvider = FutureProvider<Meal>((ref) async {
  final meals = await ref.watch(mealsProvider.future);
  if (meals.isEmpty) throw Exception("No meals available");

  // Use a true random index to avoid collisions on quick refreshes
  final rnd = Random();
  final randomIndex = rnd.nextInt(meals.length);
  return meals[randomIndex];
});

// 🔍 Search meals by name
final searchMealsProvider = FutureProvider.family<List<Meal>, String>((
  ref,
  query,
) async {
  final allMeals = await ref.watch(mealsProvider.future);
  return allMeals
      .where((meal) => meal.title.toLowerCase().contains(query.toLowerCase()))
      .toList();
});
