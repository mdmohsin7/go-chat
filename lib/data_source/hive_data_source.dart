import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'data_source.dart';

class HiveDataSource extends DataSource {
  late Box _localBox;

  HiveDataSource() {
    initialize();
  }

  Future<void> initialize() async {
    Hive.initFlutter();
    if (!kIsWeb) {
      var dir = await getApplicationDocumentsDirectory();
      Hive.init(dir.path);
    }
    _localBox = await Hive.openBox('local_data');
  }

  Future<bool> hasData() async {
    return _localBox.isNotEmpty;
  }

  void close() {
    _localBox.close();
  }

  @override
  Map<String, dynamic> getMap(String key) {
    var data = _localBox.get(key);
    if (data == null) return {};
    return data.cast<String, dynamic>() ?? {};
  }

  @override
  String getString(String key) {
    return _localBox.get(key) as String? ?? '';
  }

  @override
  void setMap(String key, Map value) {
    _localBox.put(key, value);
  }

  @override
  void setString(String key, String value) {
    _localBox.put(key, value);
  }

  @override
  FutureOr<List> getList(String key) {
    return _localBox.get(key) as List? ?? [];
  }

  @override
  FutureOr<void> setList(String key, List value) {
    _localBox.put(key, value);
  }

  @override
  FutureOr<void> appendToList(String key, value) async {
    var list = await getList(key);
    list.add(value);
    setList(key, list);
  }
}
