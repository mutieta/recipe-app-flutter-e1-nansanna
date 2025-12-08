import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/explore_provider.dart';
import '../screens/explore_screen.dart';

class CuisineCountry extends ConsumerWidget {
  const CuisineCountry({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<String> cuisines = [
      "Cambodia",
      "Indian",
      "Italian",
      "Mexican",
      "Vietnamese",
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Cuisine",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),

        const SizedBox(height: 12),

        SizedBox(
          height: 45,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: cuisines.length,
            itemBuilder: (context, index) {
              final label = cuisines[index];
              return _chip(context, ref, label);
            },
          ),
        ),
      ],
    );
  }

  Widget _chip(BuildContext context, WidgetRef ref, String label) {
    return GestureDetector(
      onTap: () {
        // set selected cuisine and navigate to Explore screen
        ref.read(selectedCuisineProvider.notifier).state = label;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (ctx) => const ExploreScreen()),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.yellow.shade600,
          border: Border.all(
            color: Colors.yellow.shade700, 
            width: 2,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: const TextStyle(color: Colors.black, fontSize: 14),
        ),
      ),
    );
  }
}
