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

  File? _selectedImage;

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

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_selectedImage != null) {
      try {
        // Pass the selected image to the controller's upload method
        userController.UpdateUserAvatar(_selectedImage!, context);
        userController.getUserData(context); // Refresh user data
      } catch (e) {
        Get.snackbar(
          "Error",
          "Failed to upload image: $e",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } else {
      Get.snackbar(
        "Error",
        "Please select an image first.",
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
                    radius: 50,
                    backgroundColor: Colors.grey[200],
                    backgroundImage:
                        (userController.userModel?.data?.avatar != null &&
                                userController.userModel?.data?.avatar != '')
                            ? CachedNetworkImageProvider(
                                userController.userModel!.data!.avatar!)
                            : const AssetImage('assets/icons/no_user.jpg')
                                as ImageProvider,
                  ),

                  const SizedBox(height: 20),

                  // Button to pick and upload image
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.image),
                    label: const Text("Choose Image"),
                  ),
                  if (_selectedImage != null) ...[
                    const SizedBox(height: 10),
                    Image.file(
                      _selectedImage!,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: _uploadImage,
                      icon: const Icon(Icons.upload),
                      label: const Text("Upload Image"),
                    ),
                  ],
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
