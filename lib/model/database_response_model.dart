import 'dart:convert';

import 'package:meta/meta.dart';

@immutable
class DatabaseModel {
  final int? id;
  final String? name;
  final String? url;

  const DatabaseModel({this.id, this.name, this.url});

  factory DatabaseModel.fromMap(Map<String, dynamic> data) {
    return DatabaseModel(
      id: data['id'] as int?,
      name: data['name'] as String?,
      url: data['url'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'url': url,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [DatabaseModel].
  factory DatabaseModel.fromJson(String data) {
    return DatabaseModel.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  

  /// `dart:convert`
  ///
  /// Converts [DatabaseModel] to a JSON string.
  String toJson() => json.encode(toMap());
}

class DatabaseModelList {
  final List<DatabaseModel> databases;

  const DatabaseModelList({required this.databases});

  factory DatabaseModelList.fromJson(String data) {
    final list = json.decode(data) as List;
    final parsedList = list.map((e) => DatabaseModel.fromMap(e)).toList();
    return DatabaseModelList(databases: parsedList);
  }
}
