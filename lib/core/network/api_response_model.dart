import 'package:locked_in/core/constants/app_strings.dart';

class ApiResponseModel {
  final int? _statusCode;
  final Map? _data;

  ApiResponseModel(this._statusCode, this._data);

  bool get isSuccess => _statusCode == 200 || _statusCode == 201;

  int get statusCode => _statusCode ?? 500;

  String get message {
    if (_statusCode == 502) {
      return AppStrings.startServer;
    }
    return _data?['message']?.toString() ?? AppStrings.someThingWrong;
  }

  Map get data => _data ?? {};
}
