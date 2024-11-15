import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../network/app_exceptions.dart';
import '../network/base_api_service.dart';

class NetworkApiService extends BaseApiService {
  @override
  Future getGetApiResponse(String url) async {
    dynamic responseJson;
    try {
      final response =
          await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException("No internet connection");
    }
    return responseJson;
  }

  @override
  Future getPostApiResponse(String url, dynamic data) async {
    dynamic responseJson;
    try {
      Response response = await http
          .post(Uri.parse(url), body: data)
          .timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException("No internet connection");
    }
    return responseJson;
  }

  dynamic returnResponse(http.Response response) {
    final responseBody = jsonDecode(response.body);

    if (responseBody['status'] == 'success') {
      return responseBody;
    } else if (responseBody['status'] == 'error') {
      throw BackendErrorException(responseBody['msg'] ?? 'An error occurred');
    } else {
      throw FetchDataException('Unexpected response format');
    }
  }
}
