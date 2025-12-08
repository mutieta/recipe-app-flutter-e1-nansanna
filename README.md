# 🍳 Recipe App - Flutter

A mobile recipe application built with Flutter that allows users to explore, search, and save their favorite recipes. 

## ✨ Features

- **Onboarding Screen**: Welcome screen for new users
- **Home Screen**: Browse popular meals, random suggestions, categories, and cuisines
- **Explore Screen**: Filter and browse meals by categories
- **Meal Details**: View complete recipe information with ingredients and video links
- **Favorites**: Save and manage favorite recipes locally with SQLite
- **Bottom Navigation**: Seamless navigation between Home, Explore, and Favorites
- **API Integration**: Real-time data from JSON Server API
- **Local Database**: Persistent storage for favorite meals

## 📱 Screens

- **Onboarding Screen**: Introduction slides before app entry
- **Home Screen**: 
  - Popular meals section
  - Random meal suggestion
  - Category cards with filter navigation
  - Cuisine/Area cards for discovery
- **Explore Screen**: 
  - Category filter chips
  - Dynamic meal list based on selection
- **Meal Detail Screen**: 
  - Full recipe information (ingredients, instructions, image, video)
  - Favorite/unfavorite toggle
- **Favourite Screen**: View and manage all saved recipes
- **Bottom Navigation**: Home, Explore, Favorites tabs

## 🛠️ Tech Stack

- **Framework**: Flutter
- **Language**: Dart
- **State Management**: Riverpod 
- **Database**: SQLite (sqflite)
- **HTTP Client**: http package
- **API**: JSON Server (Meal DB)
- **UI**: Material Design 3

## 📦 Dependencies

- `http: ^1.2.0` - For API requests
- `sqflite: ^2.3.0` - Local SQLite database
- `path: ^1.9.0` - File path handling
- `cupertino_icons: ^1.0.8` - iOS icons

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (^3.10.0)
- Dart SDK
- IDE: Android Studio, VS Code, or Xcode

### Installation

1. Clone the repository:
```bash
git clone https://github.com/mutieta/recipe-app-flutter-e1-nansanna.git
cd recipe-app-flutter-e1-nansanna
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## 📁 Project Structure

```
lib/
├── main.dart              # App entry point
├── models/                # Data models
│   ├── category.dart
│   ├── meal.dart
├── screens/               # UI screens
│   ├── explore_screen.dart
│   ├── favourite_screen.dart
│   ├── homescreen.dart
│   ├── meal_screen.dart
│   └── onboarding_screen.dart
├── services/              # API and database services
│   ├── api_service.dart
│   └── db_service.dart
└── widgets/               # Reusable widgets
    ├── bottom_nav_bar.dart
    ├── category_list.dart
    ├── cuisine_country.dart
    ├── home_header.dart
    ├── live_recipe.dart
    ├── popular_recipes.dart
    └── recipe_header.dart
```

## 📚 Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Language Guide](https://dart.dev/guides)
- [SQLite with Flutter](https://docs.flutter.dev/cookbook/persistence/sqlite)

## 📄 License

This project is part of RUPP MAD II Lab 3 coursework.

## 👨‍💻 Author

Created as a learning project for Mobile Application Development II

## ✅ Assignment Completion Checklist

### Minimum Feature Requirements
- [x] **Onboarding Screens** - Welcome introduction slides
- [x] **Home Screen** 
  - [x] Show popular meals
  - [x] Show random food suggestion (LiveRecipe)
  - [x] Display category cards
  - [x] Display area/cuisine cards
  - [x] Navigation from sections to meal list
  - [x] Bottom navigation (Home, Explore, Favourite)
- [x] **Explore Screen**
  - [x] Show categories as filter chips
  - [x] Display filtered meal list
- [x] **Meal Detail Screen**
  - [x] Display meal information
  - [x] Favorite/unfavorite option
- [x] **Favourite Screen**
  - [x] Save favorites locally using SQLite
  - [x] List all saved meals

### Technical Requirements
- [x] Dart - Programming language
- [x] Flutter - UI framework
- [x] State Management
- [x] Asynchronous Operations - Using async/await with FutureBuilder
- [x] API Integration - Using http package with JSON Server
- [x] Local Database - Using SQLite (sqflite)

## 📝 API Configuration

The app uses a dedicated JSON Server API with unique student GUID:
```
Base URL: https://meal-db-sandy.vercel.app
Header: X-DB-NAME: [Your Student GUID]
```

### Available Endpoints
- `GET /meals` - Fetch all meals
- `GET /meals/:id` - Fetch meal by ID
- `GET /categories` - Fetch all categories

