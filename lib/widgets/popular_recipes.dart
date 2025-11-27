import 'package:flutter/material.dart';

class PopularRecipes extends StatelessWidget {
  const PopularRecipes({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Popular Recipes",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 12),

        // 🟩 Replace ListView with GridView
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            height: 400, // adjust height freely
            child: GridView.builder(
              itemCount: 6,          // number of cards
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,   // 🟢 TWO CARDS PER ROW
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.8,
              ),
              itemBuilder: (context, index) {
                return _recipeCard(
                  "Recipe ${(index + 1)}",
                  "4.8 review",
                  "https://picsum.photos/20${index + 1}",
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _recipeCard(String title, String rate, String img) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: NetworkImage(img),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // dark overlay for text visibility
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.black.withOpacity(0.3),
            ),
          ),


          // Title (bottom left)
          Positioned(
            left: 8,
            bottom: 8,
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
