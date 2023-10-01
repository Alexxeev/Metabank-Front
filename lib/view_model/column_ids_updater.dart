import 'package:metabank_front/model/column_response_model.dart';
import 'package:stream_mixin/stream_mixin.dart';

class CurrentColumnList with StreamMixin<List<ColumnModel>> {
  CurrentColumnList._();

  static CurrentColumnList instance = CurrentColumnList._();

  addColumn(ColumnModel model) {
    final List<ColumnModel> updatedList = List.from(lastUpdate ?? List.empty());
    updatedList.add(model);
    return update(updatedList);
  }

  removeAll() {
    if (lastUpdate != null && lastUpdate!.isNotEmpty) update(List.empty());
  }

  removeColumn(int id) {
    if (lastUpdate == null || lastUpdate!.isEmpty) return;
    final List<ColumnModel> updatedList = List.from(lastUpdate!);
    updatedList.removeWhere((element) => element.id == id);
    return update(updatedList);
  }
}
