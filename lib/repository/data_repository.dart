import 'dart:async';

import 'package:go_chat/data_source/data_source.dart';
import 'package:go_chat/entity/user.dart';

class DataRepository {
  DataSource _dataSource;

  DataRepository(this._dataSource);

  Future getUser() async {
    var usr = await _dataSource.getMap('user');
    if (usr.isNotEmpty) {
      return User.fromMap(usr);
    } else {
      return null;
    }
  }

  Future<void> setUser(User user) async {
    return await _dataSource.setMap('user', user.toMap());
  }

  Future<String> getString(String key) async {
    return await _dataSource.getString(key);
  }

  Future<void> setString(String key, String value) async {
    return await _dataSource.setString(key, value);
  }

  FutureOr<Map<String, dynamic>> getMap(String key) {
    return _dataSource.getMap(key);
  }

  Future<void> setMap(String key, Map<String, dynamic> value) async {
    return await _dataSource.setMap(key, value);
  }

  FutureOr<List> getList(String key) {
    return _dataSource.getList(key);
  }

  FutureOr<void> setList(String key, List value) {
    return _dataSource.setList(key, value);
  }

  FutureOr<void> appendToList(String key, value) {
    return _dataSource.appendToList(key, value);
  }
}
