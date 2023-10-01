import 'package:metabank_front/model/page_query_model.dart';
import 'package:stream_mixin/stream_mixin.dart';

class CurrentPageQuery with StreamMixin<PageQueryModel> {
  CurrentPageQuery._();

  static CurrentPageQuery instance = CurrentPageQuery._();
}
