// ignore_for_file: prefer_final_fields, use_build_context_synchronously

import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sm_app/utils/secure_storage.dart';
import 'package:sm_app/utils/urls.dart';
import 'package:sm_app/utils/utils.dart';

class PostController extends GetxController {
  SecureStorage _secureStorage = SecureStorage();

  Future<void> uploadPost(File imageFile, String title, String description,
      BuildContext context) async {
    try {
      String fileName = imageFile.path.split('/').last;

      String? uid = await _secureStorage.readStorageData('uid');
      if (uid == null) {
        throw Exception("User ID (uid) is missing");
      }

      dio.FormData formData = dio.FormData.fromMap({
        'post-image': await dio.MultipartFile.fromFile(imageFile.path,
            filename: fileName),
        'title': title,
        'description': description,
        'uid': uid,
      });

      dio.Response response = await dio.Dio().post(
        Urls.uploadPost,
        data: formData,
        options: dio.Options(headers: {'Content-Type': 'multipart/form-data'}),
      );
      Utils.displayMessages(response.data, context);
    } catch (e) {
      rethrow;
    }
  }
}
