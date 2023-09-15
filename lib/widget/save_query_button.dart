import 'package:flutter/material.dart';
import 'package:metabank_front/repository/metadata_repository.dart';
import 'package:metabank_front/view_model/current_page.dart';

class SaveQueryButton extends StatelessWidget {
  const SaveQueryButton(this._metadataRepository, {super.key});

  final MetadataRepository _metadataRepository;
  
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        onPressed: () async {
          await _metadataRepository.saveQuery(queryModel: CurrentPage.instance.lastUpdate!);
          // ignore: use_build_context_synchronously
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Query saved')));
        },
        tooltip: 'Save current query',
        child: const Icon(Icons.save),
      );
  }
  
}