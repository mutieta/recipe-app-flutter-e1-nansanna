class Meal {
  final String id;
  final String title;
  final String imageUrl;
  final String instructions;
  final List<String> ingredients;
  final String? linkVideoUrl; // Add this field

  Meal({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.instructions,
    required this.ingredients,
    this.linkVideoUrl, // optional, since not all meals may have it
  });

  // Convert JSON → Meal
  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json["idMeal"] ?? "",
      title: json["strMeal"] ?? "",
      imageUrl: json["strMealThumb"] ?? "",
      instructions: json["strInstructions"] ?? "",
      ingredients: _extractIngredients(json),
      linkVideoUrl: json["strYoutube"], // MealDB returns YouTube video link
    );
  }

  // Convert Meal → Map (for database)
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "imageUrl": imageUrl,
      "instructions": instructions,
      "ingredients": ingredients.join("||"), // store as string
      "linkVideoUrl": linkVideoUrl,
    };
  }

  // SQLite maps back → Meal
  factory Meal.fromMap(Map<String, dynamic> map) {
    return Meal(
      id: map["id"],
      title: map["title"],
      imageUrl: map["imageUrl"],
      instructions: map["instructions"],
      ingredients: map["ingredients"].toString().split("||"),
      linkVideoUrl: map["linkVideoUrl"],
    );
  }

  // Extract ingredients from API (MealDB format)
  static List<String> _extractIngredients(Map<String, dynamic> json) {
    List<String> list = [];
    for (int i = 1; i <= 20; i++) {
      final ingredient = json["strIngredient$i"];
      if (ingredient != null && ingredient.toString().isNotEmpty) {
        list.add(ingredient.toString());
      }
    }
    return list;
  }
}
