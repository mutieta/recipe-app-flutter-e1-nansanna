import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/explore_provider.dart'; 
import '../screens/explore_screen.dart';

class CategoryList extends ConsumerWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // UI logic (Data defined locally, which is fine for this minimal widget)
    final categories = [
      {'label': 'Vegan', 'icon': 'assets/images/vegan.png'},
      {'label': 'Chicken', 'icon': 'assets/images/chicken.png'},
      {'label': 'Pork', 'icon': 'assets/images/pork.png'},
      {'label': 'Beef', 'icon': 'assets/images/beef.png'},
      {'label': 'Seafood', 'icon': 'assets/images/seafood.png'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Categories",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),

        const SizedBox(height: 10),

        SizedBox(
          height: 110,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              return _categoryItem(
                context,
                ref,
                cat['label']!,
                cat['icon']!,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _categoryItem(
    BuildContext context,
    WidgetRef ref,
    String label,
    String imagePath,
  ) {
    return GestureDetector(
      onTap: () {
        // This provider is now correctly available via the new import:
        ref.read(selectedCategoryProvider.notifier).state = label;
        
        Navigator.push(
          context,
          MaterialPageRoute(builder: (ctx) => const ExploreScreen()),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 15),
        child: Column(
          children: [
            Container(
              height: 60,
              width: 60,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Image.asset(imagePath, fit: BoxFit.contain),
            ),

            const SizedBox(height: 6),

            Text(
              label,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}