// ignore_for_file: use_build_context_synchronously, prefer_final_fields, avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sm_app/model/user_model.dart';
import 'package:sm_app/network/image_service.dart';
import 'package:sm_app/network/network_api_service.dart';
import 'package:sm_app/utils/secure_storage.dart';
import 'package:sm_app/utils/urls.dart';
import 'package:sm_app/utils/utils.dart';

class UserController extends GetxController {
  final _apiService = NetworkApiService();
  SecureStorage _secureStorage = SecureStorage();

  Rx<UserModel?> _userModel = Rx<UserModel?>(null);
  get userModel => _userModel.value;

  RxBool _isEditing = false.obs;
  bool get isEditing => _isEditing.value;

  RxString _avatarPath = ''.obs;
  get avatarPath => _avatarPath.value;

// Network functions
  Future<void> getUserData(BuildContext context) async {
    String? uid = await _secureStorage.readStorageData('uid');
    final Map data = {'uid': uid};
    final res = await _apiService.getPostApiResponse(Urls.getUserData, data);
    Utils.displayMessages(res, context);
    RxString _ImagePath = ''.obs;
    if (res['data']['avatar'] != null) {
      _ImagePath.value =
          '${Urls.baseUrl}/public/avatar_images/${res['data']['avatar']}';
    }
    print(_ImagePath.value);
    _userModel.value = UserModel(
      data: Data(
          username: res['data']['username'],
          email: res['data']['email'],
          bio: res['data']['bio'],
          avatar: _ImagePath.value),
    );
  }

  Future<void> updateUserData(
      String username, String bio, BuildContext context) async {
    String? uid = await _secureStorage.readStorageData('uid');
    final Map data = {'uid': uid, 'username': username, 'bio': bio};
    final res = await _apiService.getPostApiResponse(Urls.updateUserData, data);
    Utils.displayMessages(res, context);
  }

  void UpdateUserAvatar(File imageFile, BuildContext context) async {
    try {
      // Log the file path for debugging
      print("Uploading file: ${imageFile.path}");

      var response = await ImageService.uploadFile(imageFile.path);

      if (response.statusCode == 200) {
        // Log successful upload
        print("Upload successful: ${response.data}");

        _avatarPath = response.data['user']['image'];
        Get.snackbar(
          'Success',
          'Image uploaded successfully',
          margin: const EdgeInsets.only(top: 5, left: 10, right: 10),
        );
      } else if (response.statusCode == 401) {
        Get.offAllNamed('/sign_up');
      } else {
        // Log failure response
        print("Upload failed: ${response.statusCode} - ${response.data}");

        Get.snackbar(
          'Failed',
          'Error Code: ${response.statusCode}',
          margin: const EdgeInsets.only(top: 5, left: 10, right: 10),
        );
      }
    } catch (e) {
      // Log exception
      print("Upload exception: $e");

      Get.snackbar(
        'Error',
        'Failed to upload image: $e',
        margin: const EdgeInsets.only(top: 5, left: 10, right: 10),
      );
    }
  }

// Helper functions

  void setIsEditing(bool value) {
    _isEditing.value = value;
  }
}
