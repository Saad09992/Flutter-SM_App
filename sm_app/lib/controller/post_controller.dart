// ignore_for_file: prefer_final_fields, use_build_context_synchronously

import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sm_app/model/post_model.dart';
import 'package:sm_app/network/network_api_service.dart';
import 'package:sm_app/utils/secure_storage.dart';
import 'package:sm_app/utils/urls.dart';
import 'package:sm_app/utils/utils.dart';

class PostController extends GetxController {
  SecureStorage _secureStorage = SecureStorage();
  final _apiService = NetworkApiService();

  Rx<PostModel?> _postModel = Rx<PostModel?>(null);
  get postModel => _postModel.value;

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

  Future<void> getPosts(BuildContext context) async {
    try {
      // Fetch the posts from the API
      final res = await _apiService.getGetApiResponse(Urls.getPosts);

      // Check if the response contains data
      if (res is Map<String, dynamic> && res.containsKey('data')) {
        // Create a new PostModel instance from the response
        _postModel.value = PostModel.fromJson(res);

        // Display success message using the string message
        if (res['msg'] != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(res['msg'].toString())),
          );
        }
      } else {
        throw Exception('Invalid response format');
      }
    } catch (e) {
      print("Error fetching posts: $e");
      // Display error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch posts')),
      );
      rethrow;
    }
  }

  Future<void> likePost(BuildContext context, String postId) async {
    try {
      // Get the user ID from secure storage
      String? uid = await _secureStorage.readStorageData('uid');

      if (uid == null) {
        throw Exception('User ID not found');
      }
      print('Uid: $uid');
      print('postId $postId');
      // Prepare the data to send to the backend
      final Map data = {
        'postId': postId,
        'uid': uid,
      };

      // Make the API call to like the post
      final res = await _apiService.getPostApiResponse(
        Urls.likePost, // Make sure to add this endpoint in your Urls class
        data,
      );
      print(res);

      // Handle the response
      Utils.displayMessages(res, context);

      // If the response indicates success, you might want to update the local post model
      // This will depend on your backend response structure
      if (res['success'] == true) {
        // Optionally update the local post model to reflect the like
        // You might want to handle this based on your backend response
        await getPosts(
            context); // Refresh the posts to show updated like status
      }
    } catch (e) {
      print('Error in likePost: $e');

      rethrow; // Rethrow the error so it can be handled by the calling widget
    }
  }
}
