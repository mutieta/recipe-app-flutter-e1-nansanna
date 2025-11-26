import 'package:flutter/material.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          _cat(Icons.ramen_dining),
          _cat(Icons.fastfood),
          _cat(Icons.local_drink),
          _cat(Icons.cake),
          _cat(Icons.local_pizza),
        ],
      ),
    );
  }

  Widget _cat(IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Container(
        width: 55,
        height: 55,
        decoration: BoxDecoration(
          color: const Color(0xffd6d6c2),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, size: 28, color: Colors.black87),
      ),
    );
  }
}
