import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sm_app/components/drawer.dart';
import 'package:sm_app/controller/user_controller.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserController userController = Get.find();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    userController.getUserData(context);
  }

  @override
  void dispose() {
    usernameController.dispose();
    bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Page"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              userController.getUserData(context);
            },
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: Center(
        child: Obx(
          () {
            if (userController.userModel == null) {
              return const CircularProgressIndicator();
            }
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Display the user's avatar
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(
                      userController.userModel?.data?.avatar ??
                          'https://via.placeholder.com/150',
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Display or edit the username
                  userController.isEditing
                      ? TextField(
                          controller: usernameController,
                          decoration: const InputDecoration(
                            labelText: "Username",
                            border: OutlineInputBorder(),
                          ),
                        )
                      : Text(
                          userController.userModel?.data?.username ??
                              'No username',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                  const SizedBox(height: 10),

                  // Display or edit the bio
                  userController.isEditing
                      ? TextField(
                          controller: bioController,
                          decoration: const InputDecoration(
                            labelText: "Bio",
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 3,
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            userController.userModel?.data?.bio ??
                                'No bio available',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                  const SizedBox(height: 20),

                  // Edit button
                  ElevatedButton.icon(
                    onPressed: () {
                      if (userController.isEditing) {
                        userController.updateUserData(usernameController.text,
                            bioController.text, context);
                        userController.userModel?.data?.username =
                            usernameController.text;
                        userController.userModel?.data?.bio =
                            bioController.text;
                      } else {
                        usernameController.text =
                            userController.userModel?.data?.username ?? "";
                        bioController.text =
                            userController.userModel?.data?.bio ?? "";
                      }
                      userController.setIsEditing(!userController.isEditing);
                    },
                    icon: Icon(
                        userController.isEditing ? Icons.check : Icons.edit),
                    label: Text(userController.isEditing ? "Save" : "Edit"),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
