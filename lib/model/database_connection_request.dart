import 'dart:convert';

import 'package:meta/meta.dart';

@immutable
class DatabaseConnectionRequest {
  final String? url;
  final String? username;
  final String? password;

  const DatabaseConnectionRequest({this.url, this.username, this.password});

  @override
  String toString() {
    return 'DatabaseConnectionRequest(url: $url, username: $username, password: $password)';
  }

  factory DatabaseConnectionRequest.fromMap(Map<String, dynamic> data) {
    return DatabaseConnectionRequest(
      url: data['url'] as String?,
      username: data['username'] as String?,
      password: data['password'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'url': url,
        'username': username,
        'password': password,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [DatabaseConnectionRequest].
  factory DatabaseConnectionRequest.fromJson(String data) {
    return DatabaseConnectionRequest.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [DatabaseConnectionRequest] to a JSON string.
  String toJson() => json.encode(toMap());
}
