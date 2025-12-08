import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; 
import 'package:url_launcher/url_launcher.dart';
import '../widgets/recipe_header.dart';
import '../models/meal.dart';
import '../providers/favorites_provider.dart';



// 1. Change to ConsumerStatefulWidget
class MealDetailsScreen extends ConsumerStatefulWidget {
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
  // 2. Change to ConsumerState
  ConsumerState<MealDetailsScreen> createState() => _MealDetailsScreenState();
}

// 3. Change to ConsumerState
class _MealDetailsScreenState extends ConsumerState<MealDetailsScreen> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    // Start checking favorite status right away
    _checkFavorite();
  }

  // Check favorite status using Riverpod Notifier
  Future<void> _checkFavorite() async {
    // We use the `isFavorite` method on the Notifier, which uses the DB check.
    final fav = await ref.read(favoritesProvider.notifier).isFavorite(widget.id);
    setState(() => isFavorite = fav);
  }

  // Modified to use the Riverpod Notifier for instant state update
  Future<void> _toggleFavorite() async {
    // 1. Create a full Meal object from the widget's properties
    final meal = Meal(
      id: widget.id,
      title: widget.title,
      imageUrl: widget.imageUrl,
      instructions: widget.instructions,
      ingredients: widget.ingredients,
      // Ensure all optional fields are included for DB insertion
      linkVideoUrl: widget.linkVideoUrl,
      source: widget.source,
      area: widget.area,
      category: widget.category,
      tiktokUrl: widget.tiktokUrl,
    );

    // 2. Access the Riverpod Notifier for state management
    final notifier = ref.read(favoritesProvider.notifier);
    
    // 3. Toggle favorite status and update the provider
    if (isFavorite) {
      // Meal is currently a favorite, so remove it
      await notifier.removeFavorite(widget.id); 
      setState(() => isFavorite = false); // Update local state for the heart icon
    } else {
      // Meal is NOT a favorite, so add it
      await notifier.addFavorite(meal);
      setState(() => isFavorite = true); // Update local state for the heart icon
    }
    
    // The FavoritesNotifier will handle updating its state instantly
    // and saving the change to the database in the background.
  }

  // Smarter Parsing Logic (Remains unchanged) 
  Map<String, String> _parseIngredient(String line) {
    final regex = RegExp(r'[:\-\u2013\u2014\u2212]');
    final match = regex.firstMatch(line);

    if (match != null) {
      final name = line.substring(0, match.start).trim();
      final amount = line.substring(match.end).trim();
      return {'name': name, 'amount': amount};
    }
    return {'name': line, 'amount': ''};
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
                  
                  // Title
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

                  // Tags
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
                  const SizedBox(height: 12),
                  
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: Colors.grey.shade50, // Light background
                      elevation: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: widget.ingredients.asMap().entries.map((entry) {
                            final index = entry.key;
                            final line = entry.value;
                            
                            // Use the new smart parser
                            final parsed = _parseIngredient(line);
                            final name = parsed['name']!;
                            final amount = parsed['amount']!;
                            
                            final isLast = index == widget.ingredients.length - 1;

                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Ingredient Name (Left)
                                      Expanded(
                                        child: Text(
                                          name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey.shade800,
                                              ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      
                                      // Amount (Right - Orange/Yellow)
                                      Text(
                                        amount,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.amber.shade800, 
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (!isLast)
                                  Divider(
                                    color: Colors.grey.withOpacity(0.3),
                                    height: 1,
                                  ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ----------------------------
                  //           INSTRUCTIONS
                  // ----------------------------
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: const Text(
                      "Instructions",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: Colors.grey.shade50,
                      elevation: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          widget.instructions,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(height: 1.6),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ----------------------------
                  //     EXTERNAL LINKS
                  // ----------------------------
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (widget.linkVideoUrl != null && widget.linkVideoUrl!.isNotEmpty) ...[
                          ElevatedButton(
                            onPressed: () async {
                              final uri = Uri.tryParse(widget.linkVideoUrl!);
                              if (uri != null) {
                                await launchUrl(uri, mode: LaunchMode.externalApplication);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text('Watch on YouTube'),
                          ),
                          const SizedBox(height: 8),
                        ],

                        if (widget.source != null && widget.source!.isNotEmpty) ...[
                          OutlinedButton(
                            onPressed: () async {
                              final uri = Uri.tryParse(widget.source!);
                              if (uri != null) {
                                await launchUrl(uri, mode: LaunchMode.externalApplication);
                              }
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.black),
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text('View Full Recipe'),
                          ),
                          const SizedBox(height: 8),
                        ],

                        if (widget.tiktokUrl != null && widget.tiktokUrl!.isNotEmpty) ...[
                          ElevatedButton(
                            onPressed: () async {
                              final uri = Uri.tryParse(widget.tiktokUrl!);
                              if (uri != null) {
                                await launchUrl(uri, mode: LaunchMode.externalApplication);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text('TikTok'),
                          ),
                        ],
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