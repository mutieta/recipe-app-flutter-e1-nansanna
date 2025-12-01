import 'package:flutter/material.dart';
import '../widgets/recipe_header.dart';
import '../services/db_service.dart';
import '../models/meal.dart';

class MealDetailsScreen extends StatefulWidget {
  final String id;
  final String title;
  final String imageUrl;
  final String instructions;
  final List<String> ingredients;
  final String? linkVideoUrl;

  const MealDetailsScreen({
    super.key,
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.instructions,
    required this.ingredients,
    this.linkVideoUrl,
  });

  @override
  State<MealDetailsScreen> createState() => _MealDetailsScreenState();
}

class _MealDetailsScreenState extends State<MealDetailsScreen> {
  final DbService dbService = DbService.instance;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkFavorite();
  }

  Future<void> _checkFavorite() async {
    final fav = await dbService.isFavorite(widget.id);
    setState(() => isFavorite = fav);
  }

  Future<void> _toggleFavorite() async {
    setState(() => isFavorite = !isFavorite);
    final meal = Meal(
      id: widget.id,
      title: widget.title,
      imageUrl: widget.imageUrl,
      instructions: widget.instructions,
      ingredients: widget.ingredients,
    );

    if (isFavorite) {
      await dbService.insertMeal(meal);
    } else {
      await dbService.deleteMeal(widget.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Custom header with favorite button
          RecipeHeader(
            title: widget.title,
            isFavorite: isFavorite,
            onBack: () => Navigator.pop(context),
            onFavorite: _toggleFavorite,
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    widget.imageUrl,
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      widget.title,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: const Text(
                      "Ingredients",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      widget.ingredients.map((e) => "• $e").join("\n"),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: const Text(
                      "Steps",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      widget.instructions,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
