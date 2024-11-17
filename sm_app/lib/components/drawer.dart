import 'package:sm_app/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import '../utils/routes/routes_name.dart';
import 'package:get/get.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});
  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.find();

    return Drawer(
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                // Show Home or SignUp based on whether the user is logged in
                if (authController.isLoggedIn) ...[
                  _buildDrawerItem(
                      context, RoutesName.home, 'Home', Icons.home),
                  _buildDrawerItem(
                      context, RoutesName.profile, 'Profile', Icons.person),
                  _buildDrawerItem(context, RoutesName.upload_post,
                      'Upload Post', Icons.post_add),
                ] else ...[
                  _buildDrawerItem(
                      context, RoutesName.signup, 'SignUp', Icons.person),
                  _buildDrawerItem(
                      context, RoutesName.login, 'Login', Icons.info),
                ]
              ],
            ),
          ),
          // Footer with Logout Button - Only visible if the user is logged in
          if (authController.isLoggedIn)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  authController
                      .logout(); // Call logout method from authController
                  Navigator.pop(context); // Close the drawer after logout
                  Navigator.pushNamedAndRemoveUntil(
                      context, RoutesName.login, (route) => false);
                },
                icon: const Icon(Icons.exit_to_app),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
              ),
            ),
        ],
      ),
    );
  }

  ListTile _buildDrawerItem(
      BuildContext context, String route, String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue), // Stylish icons for each route
      title: Text(
        title,
        style: const TextStyle(
            fontWeight: FontWeight.bold, fontSize: 16), // Stylish text
      ),
      onTap: () {
        // Close the drawer and navigate to the route
        Navigator.pop(context);
        Navigator.pushNamed(context, route);
      },
    );
  }
}
