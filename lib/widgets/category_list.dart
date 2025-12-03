import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/category_provider.dart';
import '../screens/explore_screen.dart';

class CategoryList extends ConsumerWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = [
      {'label': 'Chicken', 'icon': 'assets/images/chicken.png'},
      {'label': 'Fish', 'icon': 'assets/images/fish.png'},
      {'label': 'Pork', 'icon': 'assets/images/pork.png'},
      {'label': 'Beef', 'icon': 'assets/images/beef.png'},
      {'label': 'Seafood', 'icon': 'assets/images/seafood.png'},
      {'label': 'Vegan', 'icon': 'assets/images/vegan.png'},
    ];

    // FIX: Removed the SizedBox(height: 100) wrapper.
    // We return the Column directly so it takes the height it needs.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min, // Ensures it only takes necessary space
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Categories",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),

        const SizedBox(height: 10),

        // This holds the actual list
        SizedBox(
          height: 90, // Slightly increased from 80 to breathe
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              return _cat(
                context,
                ref,
                cat['label'] as String,
                cat['icon'] as String,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _cat(
    BuildContext context,
    WidgetRef ref,
    String label,
    String imagePath,
  ) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: () {
          ref.read(selectedCategoryProvider.notifier).state = label;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (ctx) => const ExploreScreen()),
          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 50,
              width: 50,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.black, // Changed to standard black for visibility
                borderRadius: BorderRadius.circular(14),
              ),
              child: Image.asset(imagePath, fit: BoxFit.contain),
            ),
            
            // Optional: If you wanted the text label to appear below the icon, 
            // uncomment the lines below. (Note: You might need to increase 
            // the ListView SizedBox height to 100 or 110 if you do this).
            
            /*
            const SizedBox(height: 5),
            Text(label, style: const TextStyle(fontSize: 12)),
            */
          ],
        ),
      ),
    );
  }
}