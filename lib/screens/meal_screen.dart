import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
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
  final String? source;
  final String? area;
  final String? category;
  final String? tiktokUrl;

  const MealDetailsScreen({
    super.key,
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.instructions,
    required this.ingredients,
    this.linkVideoUrl,
    this.source,
    this.area,
    this.category,
    this.tiktokUrl,
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
      source: widget.source,
      area: widget.area,
      category: widget.category,
      tiktokUrl: widget.tiktokUrl,
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
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  if (widget.category != null || widget.area != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          if (widget.category != null)
                            Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.yellow.shade600,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                widget.category!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          if (widget.area != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.yellow.shade600,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                widget.area!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 12),

                  // ----------------------------
                  //     INGREDIENTS SECTION
                  // ----------------------------
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: const Text(
                      "Ingredients",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.yellow.shade100,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: widget.ingredients.map((line) {
                          final parts = line.split(RegExp(r'[-–:]'));
                          final name = parts[0].trim();
                          final amount = parts.length > 1
                              ? parts[1].trim()
                              : "";

                          final isLast = line == widget.ingredients.last;

                          return Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                child: Row(
                                  children: [
                                    // Ingredient name on the left
                                    Expanded(
                                      child: Text(
                                        name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),

                                    // Amount on the right
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        amount,
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.orange.shade600,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              if (!isLast)
                                Divider(
                                  color: Colors.yellow.shade300,
                                  height: 1,
                                  thickness: 1,
                                ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ----------------------------
                  //           STEPS
                  // ----------------------------
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: const Text(
                      "Steps",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
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

                  // ----------------------------
                  //     ACTION BUTTONS
                  // ----------------------------
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        if (widget.source != null)
                          ElevatedButton.icon(
                            onPressed: () async {
                              final uri = Uri.tryParse(widget.source!);
                              if (uri != null)
                                await launchUrl(
                                  uri,
                                  mode: LaunchMode.externalApplication,
                                );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.yellow.shade600,
                              foregroundColor: Colors.black,
                            ),
                            icon: const Icon(Icons.open_in_new),
                            label: const Text('Full recipe'),
                          ),

                        const SizedBox(width: 8),

                        if (widget.linkVideoUrl != null)
                          ElevatedButton.icon(
                            onPressed: () async {
                              final uri = Uri.tryParse(widget.linkVideoUrl!);
                              if (uri != null)
                                await launchUrl(
                                  uri,
                                  mode: LaunchMode.externalApplication,
                                );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.yellow.shade600,
                              foregroundColor: Colors.black,
                            ),
                            icon: const Icon(Icons.play_circle_outline),
                            label: const Text('Watch'),
                          ),

                        const SizedBox(width: 8),

                        if (widget.tiktokUrl != null)
                          ElevatedButton.icon(
                            onPressed: () async {
                              final uri = Uri.tryParse(widget.tiktokUrl!);
                              if (uri != null)
                                await launchUrl(
                                  uri,
                                  mode: LaunchMode.externalApplication,
                                );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                            ),
                            icon: const Icon(Icons.video_collection),
                            label: const Text('TikTok'),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
