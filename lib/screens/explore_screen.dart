import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/category_provider.dart';
// removed category icon helper import to revert to previous state
import '../providers/meal_provider.dart';
import '../providers/explore_provider.dart';
import '../screens/meal_screen.dart';

class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final mealsAsync = ref.watch(mealsProvider);
    final selectedCuisine = ref.watch(selectedCuisineProvider);
    final searchQuery = ref.watch(searchQueryProvider);
    final cuisines = ref.watch(cuisinesProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Explore Recipes',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                onChanged: (value) =>
                    ref.read(searchQueryProvider.notifier).state = value,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Search recipes...',
                  hintStyle: TextStyle(color: Colors.black54),
                  prefixIcon: const Icon(Icons.search, color: Colors.black54),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
              ),
            ),

            // Categories Title
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Categories',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),

            // Categories Chips
            categoriesAsync.when(
              data: (categories) => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: categories.map((category) {
                    final isSelected = selectedCategory == category.name;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(
                          category.name,
                          style: TextStyle(
                            color: isSelected ? Colors.black : Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: Colors.yellow.shade600,
                        backgroundColor: Colors.grey.shade100,
                        side: BorderSide(color: Colors.yellow.shade700),
                        onSelected: (_) {
                          ref.read(selectedCategoryProvider.notifier).state =
                              isSelected ? null : category.name;
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),

              loading: () => const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              ),

              error: (err, st) => Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Error: $err',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),

            // Cuisine Title
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Cuisine',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
            ),

            // Cuisine Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: cuisines.map((cuisine) {
                  final isSelected = selectedCuisine == cuisine;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(
                        cuisine,
                        style: TextStyle(
                          color: isSelected ? Colors.black : Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: Colors.yellow.shade600,
                      backgroundColor: Colors.grey.shade100,
                      side: BorderSide(color: Colors.yellow.shade700),
                      onSelected: (_) {
                        ref.read(selectedCuisineProvider.notifier).state =
                            isSelected ? null : cuisine;
                      },
                    ),
                  );
                }).toList(),
              ),
            ),

            // RESULTS LIST
            Expanded(
              child: mealsAsync.when(
                data: (meals) {
                  var filtered = meals;

                  // Filters
                  if (searchQuery.isNotEmpty) {
                    final q = searchQuery.toLowerCase();
                    filtered = filtered
                        .where((m) => m.title.toLowerCase().contains(q))
                        .toList();
                  }

                  if (selectedCategory != null) {
                    final q = selectedCategory.toLowerCase();
                    filtered = filtered
                        .where((m) => m.title.toLowerCase().contains(q))
                        .toList();
                  }

                  if (selectedCuisine != null) {
                    final q = selectedCuisine.toLowerCase();
                    filtered = filtered.where((m) {
                      final title = m.title.toLowerCase();
                      final area = (m.area ?? '').toLowerCase();
                      final category = (m.category ?? '').toLowerCase();
                      return title.contains(q) ||
                          area.contains(q) ||
                          category.contains(q);
                    }).toList();
                  }

                  if (filtered.isEmpty) {
                    return const Center(
                      child: Text(
                        'No meals found',
                        style: TextStyle(color: Colors.black54),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final meal = filtered[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              meal.imageUrl,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            meal.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.yellow.shade600,
                            size: 16,
                          ),
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
                                  source: meal.source,
                                  area: meal.area,
                                  category: meal.category,
                                  tiktokUrl: meal.tiktokUrl,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },

                loading: () => const Center(child: CircularProgressIndicator()),

                error: (err, st) => Center(
                  child: Text(
                    "Error: $err",
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
