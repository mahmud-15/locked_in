import 'package:locked_in/features/settings/domain/entities/user_subscription_entity.dart';

class UserSubscriptionModel extends UserSubscriptionEntity {
  const UserSubscriptionModel({
    super.id,
    super.name,
    super.price,
    super.status,
    super.startDate,
    super.endDate,
  });

  factory UserSubscriptionModel.fromJson(Map<String, dynamic> json) {
    return UserSubscriptionModel(
      id: json['_id'] as String? ?? json['id'] as String?,
      name: json['name'] as String?,
      price: json['price'] as num?,
      status: json['status'] as String?,
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price': price,
        'status': status,
        'startDate': startDate,
        'endDate': endDate,
      };
}
