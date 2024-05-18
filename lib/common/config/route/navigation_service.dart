import 'package:dictionary_app/common/config/route/route_generator.dart';
import 'package:dictionary_app/common/constants/app_logger.dart';
import 'package:flutter/material.dart';

class NavigationService {
  // Last router
  static String lastRouter = '';

  // List ROUTER STACK in session
  static List<String> stackRouter = <String>[RouteGenerator.home];

  // Navigator key
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  /// "Return a Future that completes with the route string."
  ///
  /// The `Future.microtask` function is a helper function that creates a Future that completes with the
  /// result of the given function
  ///
  /// Arguments:
  ///
  /// * `route`: The route to build.
  ///
  /// Returns:
  ///
  /// A Future<String>
  static Future<String> _buildRouteAsync(String route) async {
    return Future.microtask(() {
      return route;
    });
  }

  /// The function `routeTo` logs an analytics event, updates the stackRouter, and navigates to a
  /// specified route with optional arguments.
  ///
  /// Arguments:
  ///
  /// * `route`: The `route` parameter is a string that represents the name of the route to navigate to.
  /// It is used to identify the destination route in the application.
  /// * `arguments`: The `arguments` parameter is an optional dynamic parameter that allows you to pass
  /// additional data or arguments to the route you are navigating to. It can be used to provide context
  /// or data that the destination route may need in order to properly display or function.
  ///
  /// Returns:
  ///
  /// the result of the `pushNamed` method called on the `navigatorKey.currentState`.
  static Future<dynamic> routeTo(String route, {dynamic arguments}) async {
    //await AnalyticsExtension.logEvent(route);

    // Check and add route to stack
    if (stackRouter.contains(route)) {
      stackRouter
        ..remove(route)
        ..addAll([route]);
    } else {
      stackRouter.addAll([route]);
    }

    // Set current route
    lastRouter = route;

    logger.v('Navigate to $route\nROUTER STACK: $stackRouter');
    return navigatorKey.currentState?.pushNamed(
      await _buildRouteAsync(route),
      arguments: arguments,
    );
  }

  /// The function `routeToAndReplacement` logs an analytics event, updates the stackRouter, and
  /// navigates to a new route with replacement.
  ///
  /// Arguments:
  ///
  /// * `route`: The `route` parameter is a string that represents the destination route that you want
  /// to navigate to. It is used to identify the specific route in the application.
  /// * `arguments`: The `arguments` parameter is an optional parameter of type `Object?`. It allows you
  /// to pass additional data or arguments to the route that you are navigating to. This data can be
  /// accessed in the destination route using the `ModalRoute.of(context).settings.arguments` property.
  ///
  /// Returns:
  ///
  /// the result of the `pushReplacementNamed` method called on the `navigatorKey.currentState`.
  static dynamic routeToAndReplacement(
    String route, {
    Object? arguments,
  }) async {
    //await AnalyticsExtension.logEvent(route);

    // Check and add route to stack
    if (stackRouter.contains(route)) {
      stackRouter
        ..remove(route)
        ..removeLast()
        ..addAll([route]);
    } else {
      stackRouter
        ..removeLast()
        ..addAll([route]);
    }

    // Set current route
    lastRouter = route;

    logger.v('Navigate to $route\nROUTER STACK: $stackRouter');
    return navigatorKey.currentState?.pushReplacementNamed(
      await _buildRouteAsync(route),
      arguments: arguments,
    );
  }

  /// The function `routeToAndRemoveUntil` logs an analytics event, updates the router stack, and
  /// navigates to a specified route while removing all previous routes until a given predicate is
  /// satisfied.
  ///
  /// Arguments:
  ///
  /// * `route`: The route parameter is a string that represents the name of the route to navigate to.
  /// * `predicate`: The `predicate` parameter is a function that takes a `Route<dynamic>` object as
  /// input and returns a boolean value. It is used to determine whether a route should be removed from
  /// the navigation stack or not. If the predicate function returns `true`, the route will be removed
  /// from the stack, and
  /// * `arguments`: The `arguments` parameter is an optional argument that allows you to pass
  /// additional data to the route being navigated to. It can be of any type (`Object?`), allowing you
  /// to pass any kind of data that is needed by the destination route.
  ///
  /// Returns:
  ///
  /// the result of the `pushNamedAndRemoveUntil` method, which is a `Future` representing the result of
  /// the navigation operation.
  static dynamic routeToAndRemoveUntil(
    String route,
    bool Function(Route<dynamic> route) predicate, {
    Object? arguments,
  }) async {
    //await AnalyticsExtension.logEvent(route);

    // Check and add route to stack
    stackRouter
      ..clear()
      ..addAll([route]);

    // Set current route
    lastRouter = route;

    logger.v('Navigate to $route \nROUTER STACK: $stackRouter');
    return navigatorKey.currentState?.pushNamedAndRemoveUntil(
      await _buildRouteAsync(route),
      predicate,
      arguments: arguments,
    );
  }

  /// The function `goBackUtil` removes all routes after a specified route from the stack and navigates
  /// back to that route.
  ///
  /// Arguments:
  ///
  /// * `route`: The "route" parameter is a string that represents the name of the route to navigate
  /// back to.
  ///
  /// Returns:
  ///
  /// the result of the `popUntil` method, which is a `Future` that completes when the navigation stack
  /// has been popped until the specified route.
  static dynamic goBackUtil(String route) async {
    // Check and remove route to stack
    stackRouter.removeRange(stackRouter.indexOf(route) + 1, stackRouter.length);

    // Set current route
    lastRouter = route;

    logger.v('Navigate to $route\nROUTER STACK: $stackRouter');
    return navigatorKey.currentState?.popUntil(
      ModalRoute.withName(route),
    );
  }

  /// The function `goBack` is used to navigate back to the previous screen in a Flutter app, and it
  /// also removes the last route from the stack.
  ///
  /// Arguments:
  ///
  /// * `value`: The `value` parameter is a dynamic type, which means it can accept any type of value.
  /// It is used as the argument to be passed back when calling the `pop` method of the current state of
  /// the navigator.
  ///
  /// Returns:
  ///
  /// the result of the `pop` method called on the current state of the `navigatorKey` if it exists and
  /// can pop, otherwise it returns `null`.
  static dynamic goBack({dynamic value}) {
    final canPop = navigatorKey.currentState?.canPop() ?? false;
    if (navigatorKey.currentState != null && canPop) {
      // Check and remove route to stack
      if (lastRouter != RouteGenerator.home) {
        stackRouter.remove(lastRouter);
        lastRouter = stackRouter.last;
      }

      logger.v('ROUTER STACK: $stackRouter');
      return navigatorKey.currentState?.pop(value);
    }
    return;
  }

  /// The function checks if a given route exists in a stack router.
  ///
  /// Arguments:
  ///
  /// * `route`: The parameter "route" is a string that represents a route in a router.
  ///
  /// Returns:
  ///
  /// a boolean value.
  static bool routerExists(String route) {
    return stackRouter.contains(route);
  }

  /// The function returns the last element in the stackRouter list.
  ///
  /// Returns:
  ///
  /// The last element in the stackRouter.
  static String currentRouter() {
    return lastRouter;
  }
}
