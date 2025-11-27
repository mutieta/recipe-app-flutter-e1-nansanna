import 'package:flutter/material.dart';

class CuisineCountry extends StatelessWidget {
  const CuisineCountry({super.key});

  @override
  Widget build(BuildContext context) {
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
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
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
              return _chip(cuisines[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _chip(String label) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.yellow.shade600,                 // background
        border: Border.all(
          color: Colors.yellow.shade700,    // orange border
          width: 2,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 14,
        ),
      ),
    );
  }
}
