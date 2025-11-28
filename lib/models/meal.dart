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

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      instructions: json['instructions'] ?? '',
      ingredients: List<String>.from(json['ingredients'] ?? []),
    );
  }

  // For SQFLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'instructions': instructions,
      // Store list as a single string
      'ingredients': ingredients.join(','),
    };
  }

  factory Meal.fromMap(Map<String, dynamic> map) {
    return Meal(
      id: map['id'],
      title: map['title'],
      imageUrl: map['imageUrl'],
      instructions: map['instructions'],
      ingredients: map['ingredients'].toString().split(','),
    );
  }
}
