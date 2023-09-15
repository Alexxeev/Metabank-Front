import 'package:stream_mixin/stream_mixin.dart';

class CurrentTableId with StreamMixin<int> {
  CurrentTableId._();

  static CurrentTableId instance = CurrentTableId._();
}
