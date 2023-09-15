import 'package:advanced_datatable/datatable.dart';
import 'package:flutter/material.dart';
import 'package:metabank_front/view_model/page_size_updater.dart';
import 'package:metabank_front/view_model/query_result_data_source.dart';

@immutable
class QueryResultDataTable extends StatelessWidget {
  const QueryResultDataTable(this._dataSource, {super.key});

  final QueryResultDataSource _dataSource;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: CurrentPageSize.instance.onChange,
        builder: (pageContext, pageSnapshot) {
          return AdvancedPaginatedDataTable(
            addEmptyRows: false,
            columns: _dataSource.columns,
            source: _dataSource,
            showFirstLastButtons: true,
            showHorizontalScrollbarAlways: true,
            loadingWidget: () => const CircularProgressIndicator(),
            errorWidget: () => const Text('Error loading data'),
            rowsPerPage: pageSnapshot.data ?? AdvancedPaginatedDataTable.defaultRowsPerPage,
            onRowsPerPageChanged: (value) =>
                CurrentPageSize.instance.update(value ?? AdvancedPaginatedDataTable.defaultRowsPerPage),
          );
        });
  }
}
