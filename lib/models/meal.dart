class Meal {
  final String id;
  final String title;
  final String imageUrl;
  final String instructions;
  final List<String> ingredients;

  Meal({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.instructions,
    required this.ingredients,
  });

  // Convert JSON → Meal
  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json["idMeal"] ?? "",
      title: json["strMeal"] ?? "",
      imageUrl: json["strMealThumb"] ?? "",
      instructions: json["strInstructions"] ?? "",
      ingredients: _extractIngredients(json),
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
