import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:flutter/material.dart';
import 'package:metabank_front/model/page_query_model.dart';
import 'package:metabank_front/model/page_response_model.dart';
import 'package:metabank_front/repository/metadata_repository.dart';
import 'package:metabank_front/view_model/column_ids_updater.dart';
import 'package:metabank_front/view_model/current_page.dart';
import 'package:metabank_front/view_model/database_id_updater.dart';
import 'package:metabank_front/view_model/table_id_updater.dart';

class QueryResultDataSource extends AdvancedDataTableSource<QueryResultRow> {
  QueryResultDataSource(
    this._metadataRepository,
  );

  final MetadataRepository _metadataRepository;

  @override
  Future<RemoteDataSourceDetails<QueryResultRow>> getNextPage(
      NextPageRequest pageRequest) async {
    final queryModel = PageQueryModel(
        databaseId: CurrentDatabaseId.instance.lastUpdate,
        tableId: CurrentTableId.instance.lastUpdate,
        columnIds: CurrentColumnList.instance.lastUpdate
            ?.map((column) => column.id!)
            .toList(),
        numberOfElements: pageRequest.pageSize,
        offset: pageRequest.offset);
    final page = await _metadataRepository.queryPage(queryModel: queryModel);
    CurrentPage.instance.update(queryModel);
    return RemoteDataSourceDetails(page.totalRows, page.rows);
  }

  List<DataColumn> get columns {
    return CurrentColumnList.instance.lastUpdate
            ?.map((column) => DataColumn(label: Text(column.name!)))
            .toList() ??
        List.empty();
  }

  @override
  DataRow? getRow(int index) {
    final currentRowData = lastDetails!.rows[index];
    return DataRow(cells: _getDataCells(currentRowData));
  }

  List<DataCell> _getDataCells(QueryResultRow row) {
    return row.values.map((cellData) => DataCell(Text(cellData))).toList();
  }

  @override
  int get selectedRowCount => 0;
}
