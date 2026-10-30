import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

// 0 = Teacher, 1 = Parent
final peopleTabProvider = StateProvider<int>((ref) => 0);
