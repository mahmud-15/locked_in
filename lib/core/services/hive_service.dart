import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class HiveService {
  Future<void> init() async {
    await Hive.initFlutter();
  }

  Future<Box> openBox(String name) async {
    return await Hive.openBox(name);
  }

  Future<void> put<T>(String boxName, String key, T value) async {
    final box = await openBox(boxName);
    await box.put(key, value);
  }

  Future<T?> get<T>(String boxName, String key) async {
    final box = await openBox(boxName);
    final value = box.get(key);
    if (value is T) {
      return value;
    }
    return value as T?;
  }
}
