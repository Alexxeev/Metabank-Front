import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

typedef QueryResultRow = Map<String, dynamic>;

@immutable
class PageResponseModel {
  final List<QueryResultRow> rows;
  final int totalRows;

  const PageResponseModel({required this.rows, required this.totalRows});

  factory PageResponseModel.empty() {
    return PageResponseModel(rows: List.empty(), totalRows: 0);
  }

  factory PageResponseModel.fromMap(Map<String, dynamic> data) {
    final rows = data['rows'] as Iterable;
    final castedRows =
        List<QueryResultRow>.from(rows.map((row) => row as QueryResultRow));
    return PageResponseModel(
        rows: castedRows, totalRows: data['totalRows'] as int);
  }

  factory PageResponseModel.fromJson(String data) {
    return PageResponseModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }
}
