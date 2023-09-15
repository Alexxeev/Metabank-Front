import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:metabank_front/model/column_response_model.dart';
import 'package:metabank_front/page/archive_page.dart';
import 'package:metabank_front/page/query_page.dart';
import 'package:metabank_front/repository/metadata_repository.dart';
import 'package:metabank_front/view_model/column_ids_updater.dart';
import 'package:metabank_front/view_model/database_id_updater.dart';
import 'package:metabank_front/view_model/table_id_updater.dart';
import 'package:metabank_front/widget/column_datatable.dart';
import 'package:metabank_front/widget/connect_to_database_button.dart';
import 'package:metabank_front/widget/database_drop_down_menu.dart';
import 'package:metabank_front/widget/table_drop_down_menu.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Database connection'),
        actions: [
          TextButton(
            onPressed: () => _pushArhivePage(context), 
            child: const Text('ARCHIVE')),
          StreamBuilder<int>(
              stream: CurrentTableId.instance.onChange,
              builder: (tableContext, tableSnapshot) {
                return StreamBuilder(
                    stream: CurrentColumnList.instance.onChange,
                    builder: (columnContext, columnSnapshot) {
                      return TextButton(
                        onPressed: _isQueryButtonEnabled(
                                tableSnapshot.data, columnSnapshot.data)
                            ? () => _pushQueryPage(context)
                            : null,
                        child: const Text("QUERY"),
                      );
                    });
              }),
          StreamBuilder(
              stream: CurrentDatabaseId.instance.onChange,
              builder: (dbContext, dbSnapshot) {
                return TextButton(
                    onPressed: _isDeleteDatabaseButtonEnabled(dbSnapshot.data)
                        ? () => _deleteDatabase(dbSnapshot.requireData, context)
                        : null,
                    child: const Text('DELETE'));
              })
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsetsDirectional.only(start: 200),
                        child: GetIt.I.get<DatabaseDropDownButton>(),
                      )),
                  const VerticalDivider(
                    color: Colors.transparent,
                    width: 20,
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsetsDirectional.only(end: 200),
                    child: GetIt.I.get<TableDropDownButton>(),
                  )),
                ],
              ),
              const Divider(height: 20, color: Colors.transparent),
              SizedBox(
                height: 300,
                child: Padding(
                  padding:
                      const EdgeInsetsDirectional.only(start: 200, end: 200),
                  child: GetIt.I.get<ColumnDataTable>(),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: GetIt.I.get<ConnectToDatabaseButton>(),
    );
  }

  bool _isQueryButtonEnabled(int? id, List<ColumnModel>? columns) {
    return id != null && id != -1 && columns != null && columns.isNotEmpty;
  }

  bool _isDeleteDatabaseButtonEnabled(int? id) {
    return id != null && id != -1;
  }

  Future<void> _deleteDatabase(int id, BuildContext context) async {
    GetIt.I.get<MetadataRepository>().deleteDatabase(id: id);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Deleted a database with id $id")));
    CurrentDatabaseId.instance.update(-1);
    CurrentTableId.instance.update(-1);
  }

  void _pushQueryPage(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => const QueryPage()));
  }

  void _pushArhivePage(BuildContext context) {
    Navigator.push(
      context, MaterialPageRoute(builder: (_) => const ArchivePage()));
  }
}
