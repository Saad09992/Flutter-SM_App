// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
  File? selectedImage;

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

  Future<void> _handleAvatarUpdate() async {
    final ImagePicker picker = ImagePicker();

    try {
      final XFile? pickedImage = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedImage != null) {
        setState(() {
          selectedImage = File(pickedImage.path);
        });

        // Show confirmation dialog
        final bool? shouldUpload = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Upload New Avatar?'),
              content: SizedBox(
                width: 200,
                height: 200,
                child: Image.file(
                  selectedImage!,
                  fit: BoxFit.cover,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Upload'),
                ),
              ],
            );
          },
        );

        if (shouldUpload == true) {
          await userController.UpdateUserAvatar(selectedImage!, context);
        } else {
          setState(() {
            selectedImage = null;
          });
        }
      }
    } catch (e) {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      Get.snackbar(
        "Error",
        "Failed to update profile picture",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Page"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => userController.getUserData(context),
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
                  // Interactive avatar with hover effect
                  Stack(
                    children: [
                      Material(
                        elevation: 4,
                        shape: const CircleBorder(),
                        child: InkWell(
                          onTap: _handleAvatarUpdate,
                          customBorder: const CircleBorder(),
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.grey[200],
                            backgroundImage: selectedImage != null
                                ? FileImage(selectedImage!)
                                : (userController.userModel?.data?.avatar !=
                                            null &&
                                        userController
                                                .userModel?.data?.avatar !=
                                            '')
                                    ? CachedNetworkImageProvider(
                                        userController.userModel!.data!.avatar!)
                                    : const AssetImage(
                                            'assets/icons/no_user.jpg')
                                        as ImageProvider,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

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
                        userController.updateUserData(
                          usernameController.text,
                          bioController.text,
                          context,
                        );
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
