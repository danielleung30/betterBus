import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class Api {
  static HttpClient createHttpClient() {
    var _client = HttpClient();
    _client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    _client.connectionTimeout = Duration(seconds: 60);
    return _client;
  }

  static Future<dynamic> getData(String url, {String token = ""}) async {
    HttpClient httpClient = createHttpClient();
    try {
      HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
      request.headers.set("content-type", "application/json");

      if (token != null) {
        request.headers.set("authorization", token);
      }

      return responseHandling(httpClient, await request.close());
    } catch (e) {
      ApiResponse apiResponse = ApiResponse();
      apiResponse.status = "fail";
      apiResponse.msg = e.toString();
      return apiResponse;
    }
  }

  static dynamic responseHandling(
      HttpClient httpClient, HttpClientResponse response) async {
    String content = await response.transform(utf8.decoder).join();
    httpClient.close();

    if (response.statusCode != HttpStatus.noContent &&
        (response.statusCode == null || response.statusCode == "")) {
      throw Exception("No Status Code");
    }

    ApiResponse apiResponse = ApiResponse();
    switch (response.statusCode) {
      case HttpStatus.noContent:
        apiResponse.status = "fail";
        apiResponse.msg = "HttpStatus noContent";
        return apiResponse;
      case HttpStatus.ok:
        apiResponse.status = "success";
        apiResponse.content = jsonDecode(content);
        apiResponse.msg = "HttpStatus noContent";
        return apiResponse;
      case HttpStatus.unauthorized:
        apiResponse.status = "fail";
        apiResponse.msg = "unauthorized";
        return apiResponse;
      default:
        apiResponse.status = "fail";
        apiResponse.msg = "Other status : " + response.statusCode.toString();
        return apiResponse;
    }
  }
}

class ApiResponse {
  String status = "";
  dynamic content = null;
  String msg = "";
}
