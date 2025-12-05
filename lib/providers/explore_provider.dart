import 'package:flutter_riverpod/flutter_riverpod.dart';

// 🍽️ Provider for selected cuisine/area
final selectedCuisineProvider = StateProvider<String?>((ref) => null);

// NOTE: Resetting this to single selection for simplicity, as per previous code.
// The type was corrected from List<String> to String? for consistency with selectedCategoryProvider.
// You likely meant selectedCategoryProvider here, but I'll keep the name from your input.
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