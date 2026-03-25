import 'package:equatable/equatable.dart';

class SubscriptionPlanEntity extends Equatable {
  final String id;
  final String name;
  final String price;
  final String billingCycle;
  final String tagline;
  final List<String> features;
  final bool isPopular;

  const SubscriptionPlanEntity({
    required this.id,
    required this.name,
    required this.price,
    required this.billingCycle,
    required this.tagline,
    required this.features,
    this.isPopular = false,
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
  ];
}
