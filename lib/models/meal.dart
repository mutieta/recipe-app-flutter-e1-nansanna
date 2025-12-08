class Meal {
  final String id;
  final String title;
  final String imageUrl;
  final String instructions;
  final List<String> ingredients;
  final String? linkVideoUrl; // youtube or other video link
  final String? source; // original recipe url
  final String? area; // cuisine/area
  final String? category; // category
  final String? tiktokUrl; // optional tiktok link if provided

  Meal({
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

  // Convert JSON → Meal
  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json["idMeal"] ?? json["id"]?.toString() ?? "",
      title: json["strMeal"] ?? json["meal"] ?? json["name"] ?? "",
      imageUrl:
          json["strMealThumb"] ?? json["mealThumb"] ?? json["imageUrl"] ?? "",
      instructions: json["strInstructions"] ?? json["instructions"] ?? "",
      ingredients: _extractIngredients(json),
      linkVideoUrl: json["strYoutube"] ?? json["youtube"], // accept both keys
      source: json["source"] ?? json["strSource"],
      area: json["area"] ?? json["strArea"],
      category: json["category"] ?? json["strCategory"],
      tiktokUrl: json["tiktok"] ?? json["tiktokUrl"] ?? json["tikTok"],
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
      "source": source,
      "area": area,
      "category": category,
      "tiktokUrl": tiktokUrl,
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
      source: map["source"],
      area: map["area"],
      category: map["category"],
      tiktokUrl: map["tiktokUrl"],
    );
  }

  // Extract ingredients from API (MealDB format)
  static List<String> _extractIngredients(Map<String, dynamic> json) {
    // Handle two formats:
    // 1) MealDB style: keys strIngredient1..strIngredient20
    // 2) Our custom API: 'ingredients' is a List of { ingredient:, measure: }
    final List<String> list = [];

    if (json["ingredients"] is List) {
      try {
        for (final item in json["ingredients"] as List) {
          if (item is Map) {
            final ing = (item["ingredient"] ?? item["name"] ?? "").toString();
            final meas = (item["measure"] ?? item["qty"] ?? "").toString();
            if (ing.isNotEmpty) {
              list.add(meas.isNotEmpty ? "$ing — $meas" : ing);
            }
          }
        }
        if (list.isNotEmpty) return list;
      } catch (_) {}
    }

    for (int i = 1; i <= 20; i++) {
      final ingredient = json["strIngredient$i"];
      final measure = json["strMeasure$i"];
      if (ingredient != null && ingredient.toString().trim().isNotEmpty) {
        final ing = ingredient.toString().trim();
        final meas = measure != null ? measure.toString().trim() : "";
        list.add(meas.isNotEmpty ? "$ing — $meas" : ing);
      }
    }

    return list;
  }
}