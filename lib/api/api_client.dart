import 'dart:convert';

import 'package:http/http.dart';

import '../constants/enum_constants.dart';

String token = "";

class ApiClient {
  final Client _client;
  final String _token;
  ApiClient(this._client, this._token);
  Future<Response> request({
    required RequestType requestType,
    required String url,
    dynamic body,
    dynamic headers,
  }) async {
    Map<String, String> header = {
      "Content-Type": "application/json",
    };

    Map<String, String> headerWithToken = {
      'Content-Type': 'application/json',
      'Authorization': _token,
    };
    Map<String, String> headerWithRefreshToken = {
      "Content-Type": "application/json",
      'RefreshAuthorization': _token
    };
    switch (requestType) {
      case RequestType.postWithRefreshToken:
        return _client
            .post(
              stringToUrl(url),
              headers: headerWithRefreshToken,
            )
            .timeout(const Duration(seconds: 30));
      case RequestType.get:
        return _client
            .get(
              stringToUrl(url),
              headers: header,
            )
            .timeout(const Duration(seconds: 30));
      case RequestType.getWithToken:
        return _client
            .get(
              stringToUrl(url),
              headers: headerWithToken,
            )
            .timeout(const Duration(seconds: 30));
      case RequestType.post:
        return _client
            .post(
              stringToUrl(url),
              headers: header,
              body: json.encode(body),
            )
            .timeout(const Duration(seconds: 30));
      case RequestType.put:
        return _client
            .put(
              stringToUrl(url),
              headers: header,
              body: json.encode(body),
            )
            .timeout(const Duration(seconds: 30));
      case RequestType.postWithToken:
        return _client
            .post(
              stringToUrl(url),
              headers: headerWithToken,
              body: json.encode(body),
            )
            .timeout(const Duration(seconds: 30));
      case RequestType.postWithHeaders:
        return _client
            .post(
              stringToUrl(url),
              headers: {...header, ...headers},
              body: json.encode(body),
            )
            .timeout(const Duration(seconds: 30));
      case RequestType.delete:
        return _client
            .delete(
              stringToUrl(url),
              headers: headerWithToken,
              body: json.encode(body),
            )
            .timeout(const Duration(seconds: 30));
      default:
        return throw Exception(
          "The HTTP request method is not found",
        );
    }
  }

  Uri stringToUrl(String url) {
    return Uri.parse(url);
  }
}

class QueryParam {
  String name;
  String value;

  QueryParam(this.name, this.value);
}

Iterable<QueryParam> convertParametersForCollectionFormat(
    String collectionFormat, String name, dynamic value) {
  var params = <QueryParam>[];

  // preconditions
  if (name == null || name.isEmpty || value == null) return params;

  if (value is! List) {
    params.add(QueryParam(name, parameterToString(value)));
    return params;
  }

  List values = value as List;

  // get the collection format
  collectionFormat = (collectionFormat == null || collectionFormat.isEmpty)
      ? "csv"
      : collectionFormat; // default: csv

  if (collectionFormat == "multi") {
    return values.map((v) => QueryParam(name, parameterToString(v)));
  }

  String delimiter = _delimiters[collectionFormat] ?? ",";

  params.add(QueryParam(
      name, values.map((v) => parameterToString(v)).join(delimiter)));
  return params;
}

String parameterToString(dynamic value) {
  if (value == null) {
    return '';
  } else if (value is DateTime) {
    return value.toUtc().toIso8601String();
  } else {
    return value.toString();
  }
}

final _delimiters = const {'csv': ',', 'ssv': ' ', 'tsv': '\t', 'pipes': '|'};
