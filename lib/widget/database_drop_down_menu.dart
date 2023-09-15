import 'package:flutter/material.dart';
import 'package:metabank_front/repository/metadata_repository.dart';
import 'package:metabank_front/view_model/column_ids_updater.dart';
import 'package:metabank_front/view_model/database_id_updater.dart';
import 'package:metabank_front/view_model/table_id_updater.dart';

class DatabaseDropDownButton extends StatelessWidget {
  const DatabaseDropDownButton(this._metadataRepository, {super.key});

  final MetadataRepository _metadataRepository;

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: const InputDecoration(
          border: OutlineInputBorder(), label: Text('Database')),
      child: DropdownButtonHideUnderline(
          child: StreamBuilder(
              stream: CurrentDatabaseId.instance.onChange,
              builder: (dbContext, dbSnapshot) {
                return FutureBuilder(
                    future: _items,
                    builder: (futureContext, futureSnapshot) {
                      switch (futureSnapshot.connectionState) {
                        case ConnectionState.waiting:
                          return const Center(
                              child: CircularProgressIndicator());
                        default:
                          return DropdownButton<int>(
                              isDense: true,
                              isExpanded: true,
                              value: dbSnapshot.data == -1
                                  ? null
                                  : dbSnapshot.data,
                              disabledHint: const Text(
                                'No databases available',
                              ),
                              hint: const Text('Select a database'),
                              items: futureSnapshot.data,
                              onChanged: (value) {
                                if (value == dbSnapshot.data) return;
                                CurrentDatabaseId.instance.update(value ?? -1);
                                CurrentTableId.instance.update(-1);
                                CurrentColumnList.instance.removeAll();
                              });
                      }
                    });
              })),
    );
  }

  Future<List<DropdownMenuItem<int>>> get _items async {
    final model = await _metadataRepository.findAllDatabases();
    return model.databases
        .map((database) => DropdownMenuItem(
              value: database.id,
              child: Text(
                database.name!,
                overflow: TextOverflow.visible,
              ),
            ))
        .toList();
  }
}
