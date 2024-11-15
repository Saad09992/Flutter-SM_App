import 'package:sm_app/utils/init_dependencies.dart';
import 'package:sm_app/utils/routes/routes.dart';
import 'package:sm_app/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: InitDependencies(),
      theme: ThemeData(
          appBarTheme: const AppBarTheme(backgroundColor: Colors.blue)),

      initialRoute: RoutesName.splash,
      // sends current/changed route to generateRoute method in Routes class
      onGenerateRoute: Routes.generateRoute,
    );
  }
}
