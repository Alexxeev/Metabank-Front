import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:metabank_front/main.dart';

class BadRequestException extends HttpException {
  BadRequestException(super.message, {super.uri});
}

class HttpRequestService {
  static const Map<String, String> contentTypeJson = {
    HttpHeaders.contentTypeHeader: "application/json; charset=utf-8"
  };

  Future<String> get({required String url}) async {
    final uri = Uri.parse(baseUrl + url);
    final response = await http.get(uri, headers: contentTypeJson);
    return returnResponse(response);
  }

  Future<String> post({required String url, String? bodyJson}) async {
    final uri = Uri.parse(baseUrl + url);
    final response =
        await http.post(uri, headers: contentTypeJson, body: bodyJson);
    return returnResponse(response);
  }

  Future<String> delete({required String url}) async {
    final uri = Uri.parse(baseUrl + url);
    final response = await http.delete(uri, headers: contentTypeJson);
    return returnResponse(response);
  }

  dynamic returnResponse(http.Response response) {
    final decodedResponse = utf8.decode(response.body.codeUnits);
    switch (response.statusCode) {
      case 200:
      case 201:
        return decodedResponse;
      case 400:
        throw BadRequestException(decodedResponse);
      case 500:
      default:
        throw HttpException("Error occurred while performing request"
            "with status code: ${response.statusCode}. "
            "$decodedResponse");
    }
  }
}
