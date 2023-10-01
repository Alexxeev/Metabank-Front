import 'dart:convert';

import 'package:meta/meta.dart';

@immutable
class ColumnModel {
  final int? id;
  final String? name;

  const ColumnModel({this.id, this.name});

  factory ColumnModel.fromMap(Map<String, dynamic> data) {
    return ColumnModel(
      id: data['id'] as int?,
      name: data['name'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ColumnModel].
  factory ColumnModel.fromJson(String data) {
    return ColumnModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ColumnModel] to a JSON string.
  String toJson() => json.encode(toMap());

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ColumnModel &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          id == other.id;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;

  @override
  String toString() => "Column[$id, $name]";
}

class ColumnModelList {
  final List<ColumnModel> columns;

  const ColumnModelList({required this.columns});

  factory ColumnModelList.fromJson(String data) {
    final list = json.decode(data) as List;
    final parsedList = list.map((e) => ColumnModel.fromMap(e)).toList();
    return ColumnModelList(columns: parsedList);
  }

  factory ColumnModelList.empty() => ColumnModelList(columns: List.empty());
}
