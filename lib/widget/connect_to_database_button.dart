import 'package:flutter/material.dart';
import 'package:metabank_front/model/database_connection_request.dart';
import 'package:metabank_front/repository/metadata_repository.dart';
import 'package:metabank_front/view_model/database_id_updater.dart';
import 'package:metabank_front/view_model/table_id_updater.dart';

class ConnectToDatabaseButton extends StatelessWidget {
  ConnectToDatabaseButton(this._metadataRepository, {super.key});

  final MetadataRepository _metadataRepository;
  final TextEditingController _controller = TextEditingController();

  Future<void> _connectToDatabase(BuildContext context) async {
    final String url = _controller.text;
    if (url.isEmpty) return;
    final response = await _metadataRepository.createDatabase(connectionRequest: DatabaseConnectionRequest(
      url: url
    ));
    // ignore: use_build_context_synchronously
    if (!context.mounted) return;
    CurrentDatabaseId.instance.update(-1);
    CurrentTableId.instance.update(-1);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response))
    );
    Navigator.pop(context);
  }

  String? _validateText() {
    return _controller.text.isEmpty ? 'URL cannot be empty' : null;
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context, 
            builder: (context) {
              _controller.clear();
              return AlertDialog(
                title: const Text('Connect to a database'),
                content: ValueListenableBuilder(
                  valueListenable: _controller, 
                  builder: (textContext, textValue, _) {
                    return TextFormField(
                  controller: _controller,
                  decoration: InputDecoration(
                    errorText: _validateText(),
                    hintText: "Database connection URL"),
                );
                  }),
                actions: [
                  TextButton(
                    onPressed: () async {
                      _connectToDatabase(context);
                    }, 
                    child: const Text('OK')),
                  TextButton(
                    onPressed: () => Navigator.pop(context), 
                    child: const Text('Cancel'))
                ],
              );
            });
        },
        tooltip: 'Connect to the database',
        child: const Icon(Icons.add),
      );
  }

}