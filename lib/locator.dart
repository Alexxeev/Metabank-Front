import 'package:get_it/get_it.dart';
import 'package:metabank_front/repository/metadata_repository.dart';
import 'package:metabank_front/util/http_request_service.dart';
import 'package:metabank_front/view_model/query_result_data_source.dart';
import 'package:metabank_front/widget/column_datatable.dart';
import 'package:metabank_front/widget/connect_to_database_button.dart';
import 'package:metabank_front/widget/database_drop_down_menu.dart';
import 'package:metabank_front/widget/page_query_datatable.dart';
import 'package:metabank_front/widget/query_result_data_table.dart';
import 'package:metabank_front/widget/save_query_button.dart';
import 'package:metabank_front/widget/table_drop_down_menu.dart';

void setupLocator() {
  GetIt.I.registerSingleton<HttpRequestService>(HttpRequestService());
  GetIt.I.registerSingleton<MetadataRepository>(
      MetadataRepositoryImpl(GetIt.I.get<HttpRequestService>()));
  GetIt.I.registerSingleton<QueryResultDataSource>(
    QueryResultDataSource(GetIt.I.get<MetadataRepository>())
  );
  
  GetIt.I.registerFactory<ColumnDataTable>(
      () => ColumnDataTable(GetIt.I.get<MetadataRepository>()));
  GetIt.I.registerFactory<PageQueryDataTable>(
      () => PageQueryDataTable(GetIt.I.get<MetadataRepository>()));
  GetIt.I.registerFactory<QueryResultDataTable>(
    () => QueryResultDataTable(GetIt.I.get<QueryResultDataSource>()));

  GetIt.I.registerFactory<DatabaseDropDownButton>(
      () => DatabaseDropDownButton(GetIt.I.get<MetadataRepository>()));
  GetIt.I.registerFactory<TableDropDownButton>(
      () => TableDropDownButton(GetIt.I.get<MetadataRepository>()));
  GetIt.I.registerFactory<ConnectToDatabaseButton>(
    () => ConnectToDatabaseButton(GetIt.I.get<MetadataRepository>()));
  GetIt.I.registerFactory<SaveQueryButton>(
    () => SaveQueryButton(GetIt.I.get<MetadataRepository>()));
}
