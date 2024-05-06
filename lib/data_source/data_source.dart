import 'dart:async';

abstract class DataSource {
  FutureOr<String> getString(String key);
  FutureOr<void> setString(String key, String value);
  FutureOr<Map<String, dynamic>> getMap(String key);
  FutureOr<void> setMap(String key, Map value);
  FutureOr<List> getList(String key);
  FutureOr<void> setList(String key, List value);
  FutureOr<void> appendToList(String key, dynamic value);
}
