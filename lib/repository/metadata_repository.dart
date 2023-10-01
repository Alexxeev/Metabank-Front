import 'dart:convert';

import 'package:metabank_front/model/column_response_model.dart';
import 'package:metabank_front/model/database_connection_request.dart';
import 'package:metabank_front/model/database_response_model.dart';
import 'package:metabank_front/model/page_query_model.dart';
import 'package:metabank_front/model/page_response_model.dart';
import 'package:metabank_front/model/table_response_model.dart';
import 'package:metabank_front/util/http_request_service.dart';

abstract class MetadataRepository {
  Future<DatabaseModelList> findAllDatabases();
  Future<DatabaseModel> findDatabaseById({required int id});
  Future<TableModelList> findTablesByDatabaseId({required int databaseId});
  Future<ColumnModelList> findColumnsByTableId({required int tableId});
  Future<String> createDatabase(
      {required DatabaseConnectionRequest connectionRequest});
  Future<void> deleteDatabase({required int id});
  Future<PageResponseModel> queryPage({required PageQueryModel queryModel});
  Future<void> saveQuery({required PageQueryModel queryModel});
  Future<PageQueryModelList> findAllPageQueries();
  Future<ColumnModelList> findColumnsByColumnIds(
      {required List<int> columnIds});
}

class MetadataRepositoryImpl implements MetadataRepository {
  MetadataRepositoryImpl(this._requestService);

  final HttpRequestService _requestService;

  @override
  Future<DatabaseModelList> findAllDatabases() async {
    final responseJson = await _requestService.get(url: "/databases");
    return DatabaseModelList.fromJson(responseJson);
  }

  @override
  Future<DatabaseModel> findDatabaseById({required int id}) async {
    final responseJson = await _requestService.get(url: "/databases/$id");
    return DatabaseModel.fromJson(responseJson);
  }

  @override
  Future<TableModelList> findTablesByDatabaseId(
      {required int databaseId}) async {
    final responseJson =
        await _requestService.get(url: "/databases/$databaseId/tables");
    return TableModelList.fromJson(responseJson);
  }

  @override
  Future<ColumnModelList> findColumnsByTableId({required int tableId}) async {
    final responseJson = await _requestService.get(url: "/tables/$tableId");
    return ColumnModelList.fromJson(responseJson);
  }

  @override
  Future<String> createDatabase(
      {required DatabaseConnectionRequest connectionRequest}) async {
    String response;
    try {
      response = await _requestService.post(
          url: "/databases", bodyJson: connectionRequest.toJson());
    } on BadRequestException catch (e) {
      response = e.message;
    }
    return response;
  }

  @override
  Future<PageQueryModelList> findAllPageQueries() async {
    final responseJson = await _requestService.get(url: "/archive");
    return PageQueryModelList.fromJson(responseJson);
  }

  @override
  Future<ColumnModelList> findColumnsByColumnIds(
      {required List<int> columnIds}) async {
    final responseJson = await _requestService.post(
        url: "/columns", bodyJson: jsonEncode(columnIds));
    return ColumnModelList.fromJson(responseJson);
  }

  @override
  Future<PageResponseModel> queryPage(
      {required PageQueryModel queryModel}) async {
    final responseJson = await _requestService.post(
        url: "/query", bodyJson: queryModel.toJson());
    return PageResponseModel.fromJson(responseJson);
  }

  @override
  Future<void> saveQuery({required PageQueryModel queryModel}) async {
    await _requestService.post(url: "/archive", bodyJson: queryModel.toJson());
  }

  @override
  Future<void> deleteDatabase({required int id}) async {
    await _requestService.delete(url: "/databases/$id");
  }
}
