import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/meal.dart';
import '../models/category.dart';

class ApiService {
  static const String baseUrl = "https://meal-db-sandy.vercel.app";

  // 🔑 Use your own DB header
  static const String dbHeader = "d443dd4e-ac1d-4d5e-9885-cf05682f0ab9";

  static Map<String, String> get headers => {
        "X-DB-NAME": dbHeader,
        "Content-Type": "application/json",
      };

  // --------------------------------------------------------
  // Fetch all meals
  // --------------------------------------------------------
  static Future<List<Meal>> fetchMeals() async {
    final response = await http.get(
      Uri.parse("$baseUrl/meals"),
      headers: headers,
    );

    try {
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        List dataList;

        // Case 1: API returns a pure list
        if (decoded is List) {
          dataList = decoded;
        }

        // Case 2: API returns a map like { meals: [...] }
        else if (decoded is Map) {
          if (decoded['meals'] is List) {
            dataList = decoded['meals'];
          } else if (decoded['data'] is List) {
            dataList = decoded['data'];
          } else {
            // Try to detect any list inside map
            final firstList = decoded.values.firstWhere(
              (v) => v is List,
              orElse: () => [],
            );

            if (firstList is List) {
              dataList = firstList;
            } else {
              throw Exception(
                  "Unexpected API format. Expected list but got: ${decoded.runtimeType}");
            }
          }
        }

        // Case 3: invalid JSON type
        else {
          throw Exception('Unexpected JSON payload type: ${decoded.runtimeType}');
        }

        return dataList.map((e) => Meal.fromJson(e)).toList();
      }

      throw Exception(
        'Failed to load meals (status: ${response.statusCode}): ${response.body}',
      );
    } catch (e) {
      throw Exception('fetchMeals error: $e');
    }
  }

  // --------------------------------------------------------
  // Fetch meal by ID
  // --------------------------------------------------------
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

  // --------------------------------------------------------
  // Fetch categories
  // --------------------------------------------------------
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
