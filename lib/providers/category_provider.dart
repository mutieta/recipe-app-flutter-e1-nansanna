import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category.dart';
import '../services/api_service.dart';

// 📂 Provider for fetching all categories
final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  return await ApiService.fetchCategories();
});

// 🎯 Provider for selected category (state management)
final selectedCategoryProvider = StateProvider<String?>((ref) => null);
