import 'package:stream_mixin/stream_mixin.dart';

class CurrentDatabaseId with StreamMixin<int> {
  CurrentDatabaseId._();

  static CurrentDatabaseId instance = CurrentDatabaseId._();
}
