import 'package:dictionary_app/common/config/hive_services.dart';
import 'package:dictionary_app/common/config/route/navigation_service.dart';
import 'package:dictionary_app/common/config/route/route_generator.dart';
import 'package:dictionary_app/common/injector.dart';
import 'package:dictionary_app/presentations/widgets/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  configLocator();
  final hiveSetUp = getIt<HiveServices>();
  await hiveSetUp.init();

  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      initialRoute: RouteGenerator.home,
      onGenerateRoute: RouteGenerator.generateRoutes,
      navigatorKey: NavigationService.navigatorKey,
      scaffoldMessengerKey: AppSnackbar.snackBarKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
          },
          child: child,
        );
      },
    );
  }
}
