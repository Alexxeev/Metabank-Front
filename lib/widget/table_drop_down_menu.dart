import 'package:flutter/material.dart';
import 'package:metabank_front/model/table_response_model.dart';
import 'package:metabank_front/repository/metadata_repository.dart';
import 'package:metabank_front/view_model/column_ids_updater.dart';
import 'package:metabank_front/view_model/database_id_updater.dart';
import 'package:metabank_front/view_model/table_id_updater.dart';

class TableDropDownButton extends StatelessWidget {
  const TableDropDownButton(this._metadataRepository, {super.key});

  final MetadataRepository _metadataRepository;

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: const InputDecoration(
          border: OutlineInputBorder(), label: Text('Table')),
      child: DropdownButtonHideUnderline(
          child: StreamBuilder<int>(
              stream: CurrentDatabaseId.instance.onChange,
              builder: (dbContext, dbSnapshot) {
                return FutureBuilder(
                    future: _items(dbSnapshot.data ?? -1),
                    builder: ((futureContext, futureSnapshot) {
                      switch (futureSnapshot.connectionState) {
                        case ConnectionState.waiting:
                          return const Center(
                              child: CircularProgressIndicator());
                        default:
                          return StreamBuilder<int>(
                              stream: CurrentTableId.instance.onChange,
                              builder: (tableContext, tableSnapshot) {
                                return DropdownButton<int>(
                                    isExpanded: true,
                                    isDense: true,
                                    value: tableSnapshot.data == -1
                                        ? null
                                        : tableSnapshot.data,
                                    disabledHint:
                                        const Text('No tables available'),
                                    hint: const Text('Select a table'),
                                    items: futureSnapshot.data,
                                    onChanged: (value) {
                                      if (value == tableSnapshot.data) return;
                                      CurrentTableId.instance
                                          .update(value ?? -1);
                                      CurrentColumnList.instance.removeAll();
                                    });
                              });
                      }
                    }));
              })),
    );
  }

  Future<List<DropdownMenuItem<int>>> _items(int databaseId) async {
    final model = databaseId >= 0
        ? await _metadataRepository.findTablesByDatabaseId(
            databaseId: databaseId)
        : TableModelList.empty();
    return model.tables
        .map((table) => DropdownMenuItem(
            value: table.id,
            child: Text(
              table.name!,
              overflow: TextOverflow.visible,
            )))
        .toList();
  }
}
