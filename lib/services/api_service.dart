import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/meal.dart';
import '../models/category.dart';

class ApiService {
  static Map<String, String> get headers => {
    "X-DB-NAME": dbHeader,
    "Content-Type": "application/json",
  };

  // -----------------------------
  // Fetch All Meals
  // -----------------------------
  static Future<List<Meal>> fetchMeals() async {
    final response = await http.get(
      Uri.parse("$baseUrl/meals"),
      headers: headers,
    );

    try {
      if (response.statusCode == 200) {
        final dynamic decoded = json.decode(response.body);

        // The API may return either a List at the top level or a Map containing
        // the list under a key like 'meals' or 'data'. Normalize both cases.
        List dataList;
        if (decoded is List) {
          dataList = decoded;
        } else if (decoded is Map) {
          if (decoded['meals'] is List) {
            dataList = decoded['meals'];
          } else if (decoded['data'] is List) {
            dataList = decoded['data'];
          } else {
            // Try to find the first List value in the map
            final firstList = decoded.values.firstWhere(
              (v) => v is List,
              orElse: () => null,
            );
            if (firstList is List) {
              dataList = firstList;
            } else {
              throw Exception(
                'Unexpected JSON structure for meals: ${decoded.runtimeType}',
              );
            }
          }
        } else {
          throw Exception('Unexpected JSON payload: ${decoded.runtimeType}');
        }

        return dataList.map((e) => Meal.fromJson(e)).toList();
      }

      // Non-200: include body to help debugging
      throw Exception(
        'Failed to load meals (status: ${response.statusCode}): ${response.body}',
      );
    } catch (e) {
      // Surface the exact error (useful during development)
      throw Exception('fetchMeals error: $e');
    }
  }

  // -----------------------------
  // Fetch Meal by ID
  // -----------------------------
  static Future<Meal> fetchMealById(String id) async {
    final response = await http.get(
      Uri.parse("$baseUrl/meals/$id"),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return Meal.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load meal detail");
    }
  }

  // -----------------------------
  // Fetch Categories
  // -----------------------------
  static Future<List<Category>> fetchCategories() async {
    final response = await http.get(
      Uri.parse("$baseUrl/categories"),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load categories");
    }
  }
}
