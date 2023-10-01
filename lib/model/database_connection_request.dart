import 'dart:convert';

import 'package:meta/meta.dart';

@immutable
class DatabaseConnectionRequest {
  final String? url;

  const DatabaseConnectionRequest({this.url});

  @override
  String toString() => 'DatabaseConnectionRequest(url: $url)';

  factory DatabaseConnectionRequest.fromMap(Map<String, dynamic> data) {
    return DatabaseConnectionRequest(
      url: data['url'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'url': url,
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
