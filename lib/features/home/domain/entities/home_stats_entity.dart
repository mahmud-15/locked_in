import 'package:equatable/equatable.dart';

class HomeStatsEntity extends Equatable {
  final String lockedDuration;
  final String progressMessage;
  final String comparisonText;

  const HomeStatsEntity({
    required this.lockedDuration,
    required this.progressMessage,
    required this.comparisonText,
  });

  @override
  List<Object?> get props => [lockedDuration, progressMessage, comparisonText];
}
