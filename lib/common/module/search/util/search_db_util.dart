import 'package:collection/collection.dart';
import 'package:djqs/base/util/util_database.dart';
import 'package:djqs/common/module/search/entity/search_history_data.dart';

class SearchDBUtil extends BaseBox<SearchHistoryData> {
  static const String SEARCH_SEARCH_BOX_NAME = 'search_history_box';

  SearchDBUtil._internal();

  Future<void> init() async {
    boxName = SEARCH_SEARCH_BOX_NAME;
    await super.open();
  }

  factory SearchDBUtil() => _instance;

  static late final SearchDBUtil _instance = SearchDBUtil._internal();

  Future<void> addHistroy(SearchHistoryData entity) async {
    box?.values.forEachIndexed((index, element) {
      if (entity.text == element.text) box?.deleteAt(index);
    });
    await box?.add(entity);
  }
}
