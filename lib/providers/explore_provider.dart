import 'package:flutter_riverpod/flutter_riverpod.dart';

// 🍽️ Provider for selected cuisine/area
final selectedCuisineProvider = StateProvider<String?>((ref) => null);

final selectedCategoriesProvider = StateProvider<String?>((ref) => null); 

// 🍽️ Provider for search query
final searchQueryProvider = StateProvider<String>((ref) => "");

// List of available cuisines
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

// List of available categories for the Home Screen (Static Data)
final categoryProvider = Provider<List<String>>((ref) {
  return [
    "Vegan",
    "Chicken",
    "Pork",
    "Beef",
    "Seafood",
  ];
});