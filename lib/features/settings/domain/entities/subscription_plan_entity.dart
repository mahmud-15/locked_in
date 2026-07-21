import 'package:equatable/equatable.dart';

class SubscriptionPlanEntity extends Equatable {
  final String id;
  final String name;
  final String price;
  final String billingCycle;
  final String tagline;
  final List<String> features;
  final bool isPopular;
  final int? duration;
  final String? priceId;
  final String? paymentLink;
  final String? productId;
  final int? appAmount;

  const SubscriptionPlanEntity({
    required this.id,
    required this.name,
    required this.price,
    required this.billingCycle,
    required this.tagline,
    required this.features,
    this.isPopular = false,
    this.duration,
    this.priceId,
    this.paymentLink,
    this.productId,
    this.appAmount,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    price,
    billingCycle,
    tagline,
    features,
    isPopular,
    duration,
    priceId,
    paymentLink,
    productId,
    appAmount,
  ];
}
