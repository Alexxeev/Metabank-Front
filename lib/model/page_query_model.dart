import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@immutable
class PageQueryModel {
  final int? databaseId;
  final int? tableId;
  final List<int>? columnIds;
  final int? numberOfElements;
  final int? offset;

  const PageQueryModel({
    this.databaseId,
    this.tableId,
    this.columnIds,
    this.numberOfElements,
    this.offset
  });

  factory PageQueryModel.fromMap(Map<String, dynamic> data) {
    final list = data['columnIds'] as List?;
    final parsedList = list?.map((e) => e as int).toList();
    return PageQueryModel(
      databaseId: data['databaseId'] as int?,
      tableId: data['tableId'] as int?,
      columnIds: parsedList,
      numberOfElements: data['numberOfElements'] as int?,
      offset: data['offset'] as int?
    );
  }

  Map<String, dynamic> toMap() => {
        'databaseId': databaseId,
        'tableId': tableId,
        'columnIds': columnIds,
        'numberOfElements': numberOfElements,
        'offset': offset
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [PageQueryModel].
  factory PageQueryModel.fromJson(String data) {
    return PageQueryModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [PageQueryModel] to a JSON string.
  String toJson() => json.encode(toMap());
}

class PageQueryModelList {
  final List<PageQueryModel> pages;

  const PageQueryModelList({required this.pages});

  factory PageQueryModelList.fromJson(String data) {
    final list = json.decode(data) as List;
    final parsedList = list.map((e) => PageQueryModel.fromMap(e)).toList();
    return PageQueryModelList(pages: parsedList);
  }

  factory PageQueryModelList.empty() => PageQueryModelList(pages: List.empty());
}