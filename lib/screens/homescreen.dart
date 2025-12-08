import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/navigation_provider.dart';
import '../widgets/bottom_nav_bar.dart';
import 'explore_screen.dart';
import 'favourite_screen.dart';
import '../widgets/home_header.dart';
import '../widgets/popular_recipes.dart';
import '../widgets/category_list.dart';
import '../widgets/live_recipe.dart';
import '../widgets/cuisine_country.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationIndexProvider);

    final pages = [_homeTab(), const ExploreScreen(), const FavouriteScreen()];

    return Scaffold(
      body: IndexedStack(index: currentIndex, children: pages),
      bottomNavigationBar: BottomNavBar(
        currentIndex: currentIndex,
        onTap: (i) => ref.read(navigationIndexProvider.notifier).state = i,
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
            LiveRecipeCard(),
            SizedBox(height: 20),
            CategoryList(),
            SizedBox(height: 5),
            CuisineCountry(),
            SizedBox(height: 20),
            PopularRecipes(),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
