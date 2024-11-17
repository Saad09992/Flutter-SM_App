import 'package:sm_app/pages/home_page.dart';
import 'package:sm_app/pages/profile_page.dart';
import 'package:sm_app/pages/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:sm_app/pages/upload_post_page.dart';
import './routes_name.dart';
import '../../pages/sign_up_page.dart';
import '../../pages/login_page.dart';

class Routes {
  // generateRoute method
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // the settings contain the route and displays the page accrdingly
    switch (settings.name) {
      case RoutesName.login:
        return MaterialPageRoute(
            builder: (BuildContext context) => const LoginPage());
      case RoutesName.signup:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SignUpPage());
      case RoutesName.home:
        return MaterialPageRoute(
            builder: (BuildContext context) => const HomePage());
      case RoutesName.splash:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SplashPage());
      case RoutesName.profile:
        return MaterialPageRoute(
            builder: (BuildContext context) => const ProfilePage());
      case RoutesName.upload_post:
        return MaterialPageRoute(
            builder: (BuildContext context) => const UploadPostPage());

      // display this if route is invalid
      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(
              child: Text("No route defined"),
            ),
          );
        });
    }
  }
}
