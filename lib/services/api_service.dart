import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/meal.dart';
import '../models/category.dart';

class ApiService {
  static const String baseUrl = "https://meal-db-sandy.vercel.app";

  // Your unique student GUID
  static const String dbHeader = "your-api-id-goes-here";

  static Map<String, String> get headers => {
        "X-DB-NAME": dbHeader,
        "Content-Type": "application/json",
      };

  // Fetch all meals
  static Future<List<Meal>> fetchMeals() async {
    final response = await http.get(
      Uri.parse("$baseUrl/meals"),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      if (decoded is List) {
        return decoded.map((e) => Meal.fromJson(e)).toList();
      } else if (decoded is Map && decoded['meals'] is List) {
        return (decoded['meals'] as List).map((e) => Meal.fromJson(e)).toList();
      } else {
        throw Exception("Unexpected API response: ${decoded.runtimeType}");
      }
    } else {
      throw Exception("Failed to fetch meals: ${response.statusCode} ${response.body}");
    }
  }

  // Fetch meal by ID
  static Future<Meal> fetchMealById(String id) async {
    final response = await http.get(
      Uri.parse("$baseUrl/meals/$id"),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return Meal.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load meal detail: ${response.statusCode}");
    }
  }

  // Fetch categories
  static Future<List<Category>> fetchCategories() async {
    final response = await http.get(
      Uri.parse("$baseUrl/categories"),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load categories: ${response.statusCode}");
    }
  }
}
