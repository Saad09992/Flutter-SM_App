// ignore_for_file: use_build_context_synchronously, prefer_final_fields, avoid_print

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  RxString _uid = "".obs;
  get uid => _uid.value;

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

  Future<void> updateUserAvatar(File imageFile, BuildContext context) async {
    try {
      // Log the file path for debugging
      print("Uploading file: ${imageFile.path}");

      final res = await ImageService.uploadFile(imageFile.path);
      Utils.displayMessages(res, context);
      _avatarPath = res.data['user']['image'];
    } catch (e) {
      // Log exception
      print("Upload exception: $e");
    }
  }

// Helper functions

  Future<void> getUserId() async {
    _uid.value = await _secureStorage.readStorageData('uid') as String;
  }

  void setIsEditing(bool value) {
    _isEditing.value = value;
  }
}
