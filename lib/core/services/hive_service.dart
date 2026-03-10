import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class HiveService {
  Future<void> init() async {
    await Hive.initFlutter();
  }

  Future<Box<T>> openBox<T>(String name) async {
    return await Hive.openBox<T>(name);
  }

  Future<void> put<T>(String boxName, String key, T value) async {
    final box = await openBox<T>(boxName);
    await box.put(key, value);
  }

  Future<T?> get<T>(String boxName, String key) async {
    final box = await openBox<T>(boxName);
    return box.get(key);
  }
}
