import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/alphabet/bindings/alphabet_binding.dart';
import '../modules/alphabet/views/alphabet_view.dart';
import '../modules/puzzle/bindings/puzzle_binding.dart';
import '../modules/puzzle/views/puzzle_view.dart';
import '../modules/fruits/bindings/fruits_binding.dart';
import '../modules/fruits/views/fruits_view.dart';
import '../modules/numbers/bindings/numbers_binding.dart';
import '../modules/numbers/views/numbers_view.dart';
import '../modules/shadow_match/bindings/shadow_match_binding.dart';
import '../modules/shadow_match/views/shadow_match_view.dart';
import '../modules/shapes/bindings/shapes_binding.dart';
import '../modules/shapes/views/shapes_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.ALPHABET,
      page: () => const AlphabetView(),
      binding: AlphabetBinding(),
    ),
    GetPage(
      name: _Paths.PUZZLE,
      page: () => const PuzzleView(),
      binding: PuzzleBinding(),
    ),
    GetPage(
      name: _Paths.FRUITS,
      page: () => const FruitsView(),
      binding: FruitsBinding(),
    ),
    GetPage(
      name: _Paths.NUMBERS,
      page: () => const NumbersView(),
      binding: NumbersBinding(),
    ),
    GetPage(
      name: _Paths.SHADOW_MATCH,
      page: () => const ShadowMatchView(),
      binding: ShadowMatchBinding(),
    ),
    GetPage(
      name: _Paths.SHAPES,
      page: () => const ShapesView(),
      binding: ShapesBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
  ];
}


