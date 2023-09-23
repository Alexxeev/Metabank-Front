import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:metabank_front/repository/metadata_repository.dart';
import 'package:metabank_front/util/http_request_service.dart';
import 'package:metabank_front/view_model/database_id_updater.dart';
import 'package:metabank_front/view_model/table_id_updater.dart';

class ConnectToDatabaseButton extends StatelessWidget {
  const ConnectToDatabaseButton(this._metadataRepository, {super.key});

  final MetadataRepository _metadataRepository;

  Future<void> _pickFile(BuildContext context) async {
    final FilePickerResult? filePickerResult = await FilePicker.platform
        .pickFiles(
            type: FileType.custom,
            allowedExtensions: ['db', 'db3', 'sqlite'],
            withReadStream: true);
    if (filePickerResult == null) return;
    final file = filePickerResult.files.single;
    if (file.readStream == null) return;
    String response;
    try {
      response = await _metadataRepository.uploadDatabase(
          byteStream: file.readStream!, length: file.size, fileName: file.name);
      CurrentDatabaseId.instance.update(-1);
      CurrentTableId.instance.update(-1);
    } on BadRequestException catch (e) {
      response = e.message;
    }
    // ignore: use_build_context_synchronously
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(response)));
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () async {
        _pickFile(context);
      },
      tooltip: 'Connect to the database',
      label: const Text('Add Database'),
      icon: const Icon(Icons.add),
    );
  }
}
