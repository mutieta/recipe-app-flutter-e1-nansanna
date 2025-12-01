import 'package:flutter/material.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110, // increased height to fit title + icons
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Categories",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Horizontal scroll icons
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _cat(Icons.ramen_dining),
                _cat(Icons.local_pizza),
                _cat(Icons.fastfood),
                _cat(Icons.local_drink),
                _cat(Icons.cake),
                _cat(Icons.icecream),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _cat(IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Container(
        height: 55,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(
          icon,
          size: 28,
          color: Colors.orange[300],
        ),
      ),
    );
  }
}
