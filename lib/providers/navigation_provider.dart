import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider for managing bottom navigation index
final navigationIndexProvider = StateProvider<int>((ref) => 0);
