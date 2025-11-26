import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import 'explore_screen.dart';
import 'favourite_screen.dart';
import '../widgets/home_header.dart';
import '../widgets/popular_recipes.dart';
import '../widgets/category_list.dart';
import '../widgets/live_recipe.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  late final List<Widget> pages = [
    _homeTab(),
    const ExploreScreen(),
    const FavouriteScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
      ),
    );
  }

  Widget _homeTab() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: const [
            SizedBox(height: 20),
            HomeHeader(),
            SizedBox(height: 20),
            PopularRecipes(),
            SizedBox(height: 20),
            CategoryList(),
            SizedBox(height: 20),
            LiveRecipeCard(),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
