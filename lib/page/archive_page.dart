import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:metabank_front/widget/page_query_datatable.dart';

class ArchivePage extends StatelessWidget {
  const ArchivePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Query Archive'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [GetIt.I.get<PageQueryDataTable>()],
        ),
      ),
    );
  }
}
