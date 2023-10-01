import 'package:flutter/material.dart';
import 'package:metabank_front/model/column_response_model.dart';
import 'package:metabank_front/repository/metadata_repository.dart';
import 'package:metabank_front/view_model/column_ids_updater.dart';
import 'package:metabank_front/view_model/table_id_updater.dart';

class ColumnDataTable extends StatelessWidget {
  const ColumnDataTable(this._metadataRepository, {super.key});

  final MetadataRepository _metadataRepository;

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
        decoration: const InputDecoration(
            border: OutlineInputBorder(), label: Text('Columns')),
        child: LayoutBuilder(
          builder: (layoutContext, constraints) {
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: StreamBuilder<int>(
                  stream: CurrentTableId.instance.onChange,
                  builder: (tableContext, tableSnapshot) {
                    return StreamBuilder<List<ColumnModel>>(
                        stream: CurrentColumnList.instance.onChange,
                        builder: (columnsContext, columnsSnapshot) {
                          return FutureBuilder(
                              future: _rows(tableSnapshot.data ?? -1),
                              builder: (futureContext, futureSnapshot) {
                                return DataTable(
                                  columns: <DataColumn>[
                                    DataColumn(
                                        label: SizedBox(
                                      width: (constraints.maxWidth - 130) * 0.1,
                                      child: const Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(15, 8, 8, 8),
                                        child: Text(
                                          "Id",
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                    )),
                                    DataColumn(
                                        label: SizedBox(
                                      width: (constraints.maxWidth - 130) * 0.9,
                                      child: const Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(15, 8, 8, 8),
                                        child: Text("Name",
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic)),
                                      ),
                                    ))
                                  ],
                                  rows: futureSnapshot.data ?? List.empty(),
                                  showCheckboxColumn: true,
                                );
                              });
                        });
                  }),
            );
          },
        ));
  }

  Future<List<DataRow>> _rows(int tableId) async {
    final model = tableId >= 0
        ? await _metadataRepository.findColumnsByTableId(tableId: tableId)
        : ColumnModelList.empty();
    return model.columns
        .map((column) => DataRow(
              selected:
                  CurrentColumnList.instance.lastUpdate?.contains(column) ??
                      false,
              cells: <DataCell>[
                DataCell(Padding(
                  padding: const EdgeInsets.fromLTRB(15, 8, 8, 8),
                  child: Text(column.id!.toString()),
                )),
                DataCell(Padding(
                  padding: const EdgeInsets.fromLTRB(15, 8, 8, 8),
                  child: Text(column.name!),
                ))
              ],
              onSelectChanged: (value) {
                final selected = value ?? false;
                if (selected) {
                  CurrentColumnList.instance.addColumn(column);
                } else {
                  CurrentColumnList.instance.removeColumn(column.id!);
                }
              },
            ))
        .toList();
  }
}
