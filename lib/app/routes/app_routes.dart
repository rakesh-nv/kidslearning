part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const HOME = _Paths.HOME;
  static const ALPHABET = _Paths.ALPHABET;
  static const PUZZLE = _Paths.PUZZLE;
  static const FRUITS = _Paths.FRUITS;
  static const NUMBERS = _Paths.NUMBERS;
  static const SHADOW_MATCH = _Paths.SHADOW_MATCH;
  static const SHAPES = _Paths.SHAPES;
  static const SPLASH = _Paths.SPLASH;
}

abstract class _Paths {
  _Paths._();
  static const HOME = '/home';
  static const ALPHABET = '/alphabet';
  static const PUZZLE = '/puzzle';
  static const FRUITS = '/fruits';
  static const NUMBERS = '/numbers';
  static const SHADOW_MATCH = '/shadow-match';
  static const SHAPES = '/shapes';
  static const SPLASH = '/splash';
}


