import 'package:flutter/material.dart';
import 'package:metabank_front/model/database_connection_request.dart';
import 'package:metabank_front/repository/metadata_repository.dart';
import 'package:metabank_front/view_model/database_id_updater.dart';
import 'package:metabank_front/view_model/table_id_updater.dart';

class ConnectToDatabaseButton extends StatelessWidget {
  ConnectToDatabaseButton(this._metadataRepository, {super.key});

  final MetadataRepository _metadataRepository;
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _connectToDatabase(BuildContext context) async {
    final String url = _urlController.text;
    if (url.isEmpty) return;
    final String username = _usernameController.text;
    final String password = _passwordController.text;
    final response = await _metadataRepository.createDatabase(
        connectionRequest: DatabaseConnectionRequest(
            url: url, username: username, password: password));
    // ignore: use_build_context_synchronously
    if (!context.mounted) return;
    CurrentDatabaseId.instance.update(-1);
    CurrentTableId.instance.update(-1);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(response)));
    Navigator.pop(context);
  }

  void _clearFieldsAndPop(BuildContext context) {
    _urlController.clear();
    _usernameController.clear();
    _passwordController.clear();
    Navigator.pop(context);
  }

  String? _validateText() {
    return _urlController.text.isEmpty ? 'URL cannot be empty' : null;
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              _urlController.clear();
              return AlertDialog(
                title: const Text('Connect to a database'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ValueListenableBuilder(
                        valueListenable: _urlController,
                        builder: (textContext, textValue, _) {
                          return TextFormField(
                            controller: _urlController,
                            decoration: InputDecoration(
                                errorText: _validateText(),
                                hintText: "Database connection URL"),
                          );
                        }),
                    ValueListenableBuilder(
                        valueListenable: _usernameController,
                        builder: (textContext, textValue, _) {
                          return TextFormField(
                            controller: _usernameController,
                            decoration:
                                const InputDecoration(hintText: "Username"),
                          );
                        }),
                    ValueListenableBuilder(
                        valueListenable: _passwordController,
                        builder: (textContext, textValue, _) {
                          return TextFormField(
                            controller: _passwordController,
                            decoration:
                                const InputDecoration(hintText: "Password"),
                            obscureText: true,
                          );
                        })
                  ],
                ),
                actions: [
                  TextButton(
                      onPressed: () async {
                        _connectToDatabase(context);
                      },
                      child: const Text('OK')),
                  TextButton(
                      onPressed: () {
                        _clearFieldsAndPop(context);
                      },
                      child: const Text('Cancel'))
                ],
              );
            });
      },
      tooltip: 'Connect to the database',
      label: const Text('Add database'),
      icon: const Icon(Icons.add),
    );
  }
}
