import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class SearchHistoryData extends HiveObject {
  @HiveField(0)
  String? text;

  SearchHistoryData({
    this.text,
  });
}

class SearchHistoryAdapter extends TypeAdapter<SearchHistoryData> {
  @override
  int get typeId => 0;

  @override
  SearchHistoryData read(BinaryReader reader) {
    String text = reader.read();
    return SearchHistoryData(text: text);
  }

  @override
  void write(BinaryWriter writer, SearchHistoryData obj) {
    writer.write(obj.text);
  }
}
