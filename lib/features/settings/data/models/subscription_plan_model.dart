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
    super.duration,
    super.priceId,
    super.paymentLink,
    super.productId,
    super.appAmount,
  });

  factory SubscriptionPlanModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlanModel(
      id: json['_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      price: '\$${json['price']}',
      billingCycle: '/${json['category'] ?? ''}',
      tagline: json['subtitle'] as String? ?? '',
      features:
          (json['features'] as List?)?.map((e) => e as String).toList() ?? [],
      isPopular: json['name'] == 'Pro Plan', // Example logic
      duration: json['duration'] as int?,
      priceId: json['priceId'] as String?,
      paymentLink: json['paymentLink'] as String?,
      productId: json['productId'] as String?,
      appAmount: json['app_amount'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
    'price': price.replaceAll('\$', ''),
    'category': billingCycle.replaceAll('/', ''),
    'subtitle': tagline,
    'features': features,
    'duration': duration,
    'priceId': priceId,
    'paymentLink': paymentLink,
    'productId': productId,
    'app_amount': appAmount,
  };
}
