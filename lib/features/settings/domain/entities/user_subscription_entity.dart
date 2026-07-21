import 'package:equatable/equatable.dart';

class UserSubscriptionEntity extends Equatable {
  final String? id;
  final String? name;
  final num? price;
  final String? status;
  final String? startDate;
  final String? endDate;

  const UserSubscriptionEntity({
    this.id,
    this.name,
    this.price,
    this.status,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        price,
        status,
        startDate,
        endDate,
      ];
}
