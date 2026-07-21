import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locked_in/features/settings/data/datasources/disclaimer_remote_data_source.dart';

final disclaimerDataSourceProvider = Provider<DisclaimerRemoteDataSource>((
  ref,
) {
  return DisclaimerRemoteDataSource();
});

final disclaimerProvider = FutureProvider.family<String, String>((
  ref,
  type,
) async {
  final dataSource = ref.watch(disclaimerDataSourceProvider);
  return await dataSource.getDisclaimer(type);
});
