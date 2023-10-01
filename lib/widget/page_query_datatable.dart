import 'package:flutter/material.dart';
import 'package:metabank_front/page/query_page.dart';
import 'package:metabank_front/repository/metadata_repository.dart';
import 'package:metabank_front/view_model/column_ids_updater.dart';
import 'package:metabank_front/view_model/database_id_updater.dart';
import 'package:metabank_front/view_model/table_id_updater.dart';

class PageQueryDataTable extends StatelessWidget {
  const PageQueryDataTable(this._metadataRepository, {super.key});

  final MetadataRepository _metadataRepository;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (layoutContext, constraints) {
      final double allowedWidth = (constraints.maxWidth - 130);
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: FutureBuilder(
          future: _rows(context),
          builder: (futureContext, futureSnapshot) {
            if (futureSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return DataTable(
                showCheckboxColumn: false,
                columns: <DataColumn>[
                  _column('Database Id', allowedWidth * 0.2),
                  _column('Table Id', allowedWidth * 0.2),
                  _column('Column Ids', allowedWidth * 0.6),
                  // _column('Page Size', allowedWidth * 0.1),
                  // _column('Page Number', allowedWidth * 0.1),
                ],
                rows: futureSnapshot.data ?? List.empty());
          },
        ),
      );
    });
  }

  DataCell _cell(String text) => DataCell(
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 8, 8, 8),
          child: Text(text),
        ),
      );

  DataColumn _column(String label, double width) => DataColumn(
        label: SizedBox(
            width: width,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 8, 8, 8),
              child: Text(
                label,
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
            )),
      );

  Future<List<DataRow>> _rows(BuildContext context) async {
    final model = await _metadataRepository.findAllPageQueries();
    return model.pages
        .map((page) => DataRow(
                onSelectChanged: (value) async {
                  final columnListModel = await _metadataRepository
                      .findColumnsByColumnIds(columnIds: page.columnIds!);
                  CurrentDatabaseId.instance.update(page.databaseId!);
                  CurrentTableId.instance.update(page.tableId!);
                  CurrentColumnList.instance.update(columnListModel.columns);
                  // ignore: use_build_context_synchronously
                  if (!context.mounted) return;
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const QueryPage()));
                },
                cells: <DataCell>[
                  _cell(page.databaseId!.toString()),
                  _cell(page.tableId!.toString()),
                  _cell(page.columnIds!.join(', ')),
                  // _cell(page.numberOfElements!.toString()),
                  // _cell(page.offset!.toString())
                ]))
        .toList();
  }
}
