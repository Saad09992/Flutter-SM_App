// ignore_for_file: use_build_context_synchronously, prefer_final_fields, avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sm_app/model/user_model.dart';
import 'package:sm_app/network/network_api_service.dart';
import 'package:sm_app/utils/secure_storage.dart';
import 'package:sm_app/utils/urls.dart';
import 'package:sm_app/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class UserController extends GetxController {
  final _apiService = NetworkApiService();
  SecureStorage _secureStorage = SecureStorage();

  Rx<UserModel?> _userModel = Rx<UserModel?>(null);
  get userModel => _userModel.value;

  RxBool _isEditing = false.obs;
  bool get isEditing => _isEditing.value;

// Network functions
  Future<void> getUserData(BuildContext context) async {
    String? uid = await _secureStorage.readStorageData('uid');
    final Map data = {'uid': uid};
    final res = await _apiService.getPostApiResponse(Urls.getUserData, data);
    Utils.displayMessages(res, context);
    _userModel.value = UserModel(
      data: Data(
          username: res['data']['username'],
          email: res['data']['email'],
          bio: res['data']['bio'],
          avatar: res['data']['avatar']),
    );
  }

  Future<void> updateUserData(
      String username, String bio, BuildContext context) async {
    String? uid = await _secureStorage.readStorageData('uid');
    final Map data = {'uid': uid, 'username': username, 'bio': bio};
    final res = await _apiService.getPostApiResponse(Urls.updateUserData, data);
    Utils.displayMessages(res, context);
  }

  Future<void> updateUserAvatar(File image, BuildContext context) async {
    final uri = Uri.parse(Urls.updateUserAvatar);

    // Create a Multipart request
    final request = http.MultipartRequest('POST', uri);

    // Attach the file
    final fileName = basename(image.path);
    request.files.add(
      await http.MultipartFile.fromPath(
        'image',
        image.path,
        filename: fileName,
      ),
    );

    final res = await request.send();
    Utils.displayMessages(res, context);
  }

// Helper functions

  void setIsEditing(bool value) {
    _isEditing.value = value;
  }
}
