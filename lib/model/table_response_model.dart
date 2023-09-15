import 'dart:convert';

import 'package:meta/meta.dart';

@immutable
class TableModel {
  final int? id;
  final String? name;

  const TableModel({this.id, this.name});

  factory TableModel.fromMap(Map<String, dynamic> data) {
    return TableModel(
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
  /// Parses the string and returns the resulting Json object as [TableModel].
  factory TableModel.fromJson(String data) {
    return TableModel.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [TableModel] to a JSON string.
  String toJson() => json.encode(toMap());
}

class TableModelList {
  final List<TableModel> tables;

  const TableModelList({required this.tables});

  factory TableModelList.fromJson(String data) {
    final list = json.decode(data) as List;
    final parsedList = list.map((e) => TableModel.fromMap(e)).toList();
    return TableModelList(tables: parsedList);
  }

  factory TableModelList.empty() => TableModelList(tables: List.empty());
}

