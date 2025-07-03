import 'dart:io';

import 'package:djqs/common/module/search/entity/search_history_data.dart';
import 'package:djqs/common/module/search/util/search_db_util.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class BaseDBUtil {
  BaseDBUtil._internal();

  factory BaseDBUtil() => _instance;

  static late final _instance = BaseDBUtil._internal();

  Future<void> init() async {
    await _initHive();
    await _initBox();
  }

  Future<void> _initHive() async {
    Directory document = await getApplicationDocumentsDirectory();
    await Hive
      ..init(document.path)
      ..registerAdapter(SearchHistoryAdapter());
  }

  Future<void> _initBox() async {
    await SearchDBUtil();
  }

  void close() async => await Hive.close();

  Future<Box> getBox(String name) async => await Hive.openBox(name);

  Future<void>? closeBox(Box? box) async => await box?.close();
}

class BaseBox<T> {
  Box<T>? box;
  String? boxName;

  Future<void> open() async {
    box = await Hive.openBox(boxName ?? '');
  }

  List<T>? getAll() => box?.values.toList().reversed.toList();

  void addListener(Function() callback) =>
      box!.watch().listen((event) => callback.call());

  void delete(int index) async {
    int key = box!.keyAt(box!.length - index - 1);
    await box!.delete(key);
  }

  Future<void> clear() async {
    if (box?.isOpen ?? false)
      await box?.clear();
    else {
      await open();
      await box?.clear();
      await close();
    }
  }

  Future<void>? close() async => await BaseDBUtil().closeBox(box);
}
