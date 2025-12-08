import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/meal.dart';

class DbService {
  static final DbService instance = DbService._init();
  static Database? _database;

  DbService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    // Note: Use `path_provider` to ensure the directory exists in a real app,
    // but `sqflite` often handles this implicitly.
    _database = await _initDB("meals.db");
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    // FIX: Added all missing columns (linkVideoUrl, source, area, category, tiktokUrl)
    await db.execute('''
      CREATE TABLE favorites (
        id TEXT PRIMARY KEY,
        title TEXT,
        imageUrl TEXT,
        instructions TEXT,
        ingredients TEXT,
        linkVideoUrl TEXT,
        source TEXT,
        area TEXT,
        category TEXT,
        tiktokUrl TEXT
      )
    ''');
  }

  // Add to favorite
  Future<void> insertMeal(Meal meal) async {
    final db = await instance.database;
    await db.insert(
      "favorites",
      meal.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Remove from favorite
  Future<void> deleteMeal(String id) async {
    final db = await instance.database;
    await db.delete(
      "favorites",
      where: "id = ?",
      whereArgs: [id],
    );
  }

  // Get all favorites
  Future<List<Meal>> getFavoriteMeals() async {
    final db = await instance.database;
    final result = await db.query("favorites");

    // Fix: Ensure we handle the Meal.fromMap conversion correctly
    return result.map((map) => Meal.fromMap(map)).toList();
  }

  // Check if meal exists in favorites
  Future<bool> isFavorite(String id) async {
    final db = await instance.database;
    final result =
        await db.query("favorites", where: "id = ?", whereArgs: [id]);
    return result.isNotEmpty;
  }
}