import 'package:stream_mixin/stream_mixin.dart';

class CurrentPageSize with StreamMixin<int> {
  CurrentPageSize._();

  static CurrentPageSize instance = CurrentPageSize._();
}
