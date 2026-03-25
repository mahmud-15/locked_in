import 'package:locked_in/features/home/domain/entities/home_stats_entity.dart';

class HomeStatsModel extends HomeStatsEntity {
  const HomeStatsModel({
    required super.lockedDuration,
    required super.progressMessage,
    required super.comparisonText,
  });

  factory HomeStatsModel.fromJson(Map<String, dynamic> json) => HomeStatsModel(
    lockedDuration: json['locked_duration'] as String,
    progressMessage: json['progress_message'] as String,
    comparisonText: json['comparison_text'] as String,
  );
}
