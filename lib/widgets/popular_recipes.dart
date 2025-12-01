import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../services/api_service.dart';
import '../screens/meal_screen.dart';

class PopularRecipes extends StatefulWidget {
  const PopularRecipes({super.key});

  @override
  State<PopularRecipes> createState() => _PopularRecipesState();
}

class _PopularRecipesState extends State<PopularRecipes> {
  late Future<List<Meal>> mealsFuture;

  @override
  void initState() {
    super.initState();
    mealsFuture = ApiService.fetchMeals();
  }

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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            height: 400,
            child: FutureBuilder<List<Meal>>(
              future: mealsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No meals found"));
                }

                final meals = snapshot.data!;

                return GridView.builder(
                  itemCount: meals.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.8,
                  ),
                  itemBuilder: (context, index) {
                    final meal = meals[index];

                    return GestureDetector(
                      onTap: () async {
                        final mealDetail = await ApiService.fetchMealById(meal.id);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MealDetailsScreen(
                              id: mealDetail.id,
                              title: mealDetail.title,
                              imageUrl: mealDetail.imageUrl,
                              instructions: mealDetail.instructions,
                              ingredients: mealDetail.ingredients,
                            ),
                          ),
                        );
                      },
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              image: DecorationImage(
                                image: NetworkImage(meal.imageUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.black.withOpacity(0.3),
                            ),
                          ),
                          Positioned(
                            left: 8,
                            bottom: 8,
                            child: Text(
                              meal.title,
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
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
