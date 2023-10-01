import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:metabank_front/widget/query_result_data_table.dart';
import 'package:metabank_front/widget/save_query_button.dart';

class QueryPage extends StatelessWidget {
  const QueryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Query a database"),
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        child: Column(children: [GetIt.I.get<QueryResultDataTable>()]),
      ),
      floatingActionButton: GetIt.I.get<SaveQueryButton>(),
    );
  }
}
