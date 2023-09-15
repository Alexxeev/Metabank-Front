import 'package:metabank_front/model/page_query_model.dart';
import 'package:stream_mixin/stream_mixin.dart';

class CurrentPage with StreamMixin<PageQueryModel> {
  CurrentPage._();

  static CurrentPage instance = CurrentPage._();
}