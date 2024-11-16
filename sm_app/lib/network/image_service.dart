import 'package:dio/dio.dart';
import 'package:sm_app/utils/secure_storage.dart';
import 'package:sm_app/utils/urls.dart';

class ImageService {
  static Future<Response> uploadFile(String filePath) async {
    try {
      SecureStorage _secureStorage = SecureStorage();

      Dio dio = Dio();
      String fileName = filePath.split('/').last;
      String? uid = await _secureStorage.readStorageData('uid');

      if (uid == null) {
        throw Exception("User ID (uid) is missing");
      }

      FormData formData = FormData.fromMap({
        'avatar': await MultipartFile.fromFile(filePath, filename: fileName),
        "uid": uid
      });

      print("FormData: ${formData.fields}");

      Response response = await dio.post(
        Urls.updateUserAvatar,
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );

      print("Response Status Code: ${response.statusCode}");
      print("Response Data: ${response.data}");

      return response;
    } catch (e) {
      print("Dio error: $e");
      rethrow;
    }
  }
}
