import 'package:locked_in/features/settings/domain/entities/subscription_plan_entity.dart';

class SubscriptionPlanModel extends SubscriptionPlanEntity {
  const SubscriptionPlanModel({
    required super.id,
    required super.name,
    required super.price,
    required super.billingCycle,
    required super.tagline,
    required super.features,
    super.isPopular,
  });

  factory SubscriptionPlanModel.fromJson(Map<String, dynamic> json) =>
      SubscriptionPlanModel(
        id: json['id'] as String,
        name: json['name'] as String,
        price: json['price'] as String,
        billingCycle: json['billing_cycle'] as String,
        tagline: json['tagline'] as String,
        features: List<String>.from(json['features'] as List),
        isPopular: json['is_popular'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'price': price,
    'billing_cycle': billingCycle,
    'tagline': tagline,
    'features': features,
    'is_popular': isPopular,
  };
}
