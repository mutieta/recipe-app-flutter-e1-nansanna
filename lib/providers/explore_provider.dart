import 'package:flutter_riverpod/flutter_riverpod.dart';

// 🍽️ Provider for selected cuisine/area
final selectedCuisineProvider = StateProvider<String?>((ref) => null);

// 🍽️ Renamed for consistency and clarity:
final selectedCategoryProvider = StateProvider<String?>((ref) => null); 

// 🍽️ Provider for search query
final searchQueryProvider = StateProvider<String>((ref) => "");

// List of available cuisines (Static and Instantly Available)
final cuisinesProvider = Provider<List<String>>((ref) {
  return [
    "Cambodia",
    "Indian",
    "Italian",
    "Mexican",
    "Vietnamese",
    "Thai",
    "Chinese",
  ];
});

// List of available categories (STATIC, FAST, and Minimal)
// Note: You listed 6 items in your request, but only 5 in your provider file. 
// I will use the 5 from your last provided file for safety.
final categoryItemsProvider = Provider<List<String>>((ref) {
  return [
    "Vegan",
    "Chicken",
    "Pork",
    "Beef",
    "Seafood",
  ];
});