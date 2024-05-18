import 'package:dictionary_app/presentations/screens/add_edit_word/add_edit_word_screen.dart';
import 'package:dictionary_app/presentations/screens/home/home_screen.dart';
import 'package:dictionary_app/presentations/screens/word_detail/word_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class RouteGenerator {
  /// All the route paths. So that we can access them easily  across the app
  static const home = 'home_screen';

  static const addEditWord = 'add_edit_word_screen';

  static const wordDetail = 'word_detail_screen';

  /// Private static methods to route to page with transition
  /// REQUIRE use function
  static PageTransition<dynamic> _pageTransition({
    RouteSettings? settings,
    required Widget child,
  }) {
    return PageTransition(
      settings: settings,
      child: child,
      duration: const Duration(milliseconds: 150),
      reverseDuration: const Duration(milliseconds: 250),
      type: PageTransitionType.fade,
    );
  }

  /// Function generate routes
  /// Arguments:
  /// * `settings`: The RouteSettings for the current route.
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return _pageTransition(
          settings: settings,
          child: const HomeScreen(),
        );
      case addEditWord:
        return _pageTransition(
          settings: settings,
          child: const AddEditWordScreen(),
        );
      case wordDetail:
        return _pageTransition(
          settings: settings,
          child: const WordDetailScreen(),
        );

      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(
              child: Text('Not found ${settings.name}'),
            ),
          ),
        );
    }
  }
}
