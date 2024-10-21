// models/store_basic_details.dart
import 'package:openzo_frontend/constants/constants.dart';

class StoreBasicDetails {
  final String id;
  final String name;
  final String image;
  final String address;
  final String category;
  final String subCategory;
  final String description;
  final double rating;
  final int reviewCount;

  StoreBasicDetails({
    required this.id,
    required this.name,
    required this.image,
    required this.address,
    required this.category,
    required this.subCategory,
    required this.description,
    required this.rating,
    required this.reviewCount,
  });

  factory StoreBasicDetails.fromJson(Map<String, dynamic> json) {
    return StoreBasicDetails(
      id: json['store_id'],
      name: json['store_name'],
      image: json['store_image'],
      address: json['store_address'],
      category: json['store_category'],
      subCategory: json['store_sub_category'],
      description: json['store_description'],
      rating: double.parse(json['store_rating'].toString()),
      reviewCount: int.parse(json['store_review_count'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'store_id': id,
      'store_name': name,
      'store_image': image,
      'store_address': address,
      'store_category': category,
      'store_sub_category': subCategory,
      'store_description': description,
      'store_rating': rating,
      'store_review_count': reviewCount,
    };
  }
}

// models/store.dart
class Store {
  final String id;
  final String name;
  final String image;
  final String location;
  final bool selfDeliveryService;
  final String pincode;
  final String phone;
  final String description;
  final String address;
  final DateTime openingTime;
  final DateTime closingTime;
  bool detailsComplete = false;
  String category = "";
  String subCategory = "";

  // Restaurant specific fields
  String? primaryCuisine;
  String? secondaryCuisine;
  int? avgPricePerPerson;
  bool? pureVeg;
  bool? alcohol;
  int? tableCount;
  int? seatingCapacity;
  bool? reserveTableOnline;
  int deliveryCharge;
  double rating;
  int reviewCount;
  bool busy;
  int packingCharge = 0;

  Store({
    required this.id,
    required this.name,
    required this.pincode,
    required this.address,
    required this.location,
    required this.openingTime,
    required this.description,
    required this.closingTime,
    required this.image,
    required this.phone,
    required this.selfDeliveryService,
    this.category = "",
    this.subCategory = "",
    this.detailsComplete = false,
    this.busy = false,
    this.primaryCuisine,
    this.secondaryCuisine,
    this.avgPricePerPerson,
    this.pureVeg,
    this.alcohol,
    this.tableCount,
    this.seatingCapacity,
    this.reserveTableOnline,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.deliveryCharge = 0,
    this.packingCharge = 0,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id'],
      address: json['address'],
      pincode: json['pincode'],
      name: json['name'],
      phone: json['phone'] ?? "",
      image: json['image'],
      location: json['location'],
      openingTime: DateTime.tryParse(json['opening_time']) ?? DateTime.now(),
      closingTime: DateTime.tryParse(json['closing_time']) ??
          DateTime.now().add(Duration(hours: 1)),
      selfDeliveryService: json['self_delivery_service'],
      description: json['description'],
      detailsComplete: json['details_complete'] ?? false,
      category: json['category'] ?? "",
      subCategory: json['sub_category'] ?? "",
      primaryCuisine: json['primary_cuisine'],
      secondaryCuisine: json['secondary_cuisine'],
      avgPricePerPerson: json['avg_price_per_person'],
      pureVeg: json['pure_veg'] ?? false,
      alcohol: json['alcohol'],
      tableCount: json['table_count'],
      seatingCapacity: json['seating_capacity'],
      reserveTableOnline: json['reserve_table_online'],
      rating: double.parse(json['rating'].toString()),
      reviewCount: int.parse(json['review_count'].toString()),
      deliveryCharge: json['delivery_charge'] ?? 0,
      busy: json['busy'] ?? false,
      packingCharge: json['packaging_charge'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'address': address,
      'pincode': pincode,
      'name': name,
      'phone': phone,
      'image': image,
      'location': location,
      'opening_time': openingTime.toIso8601String(),
      'closing_time': closingTime.toIso8601String(),
      'self_delivery_service': selfDeliveryService,
      'description': description,
      'details_complete': detailsComplete,
      'category': category,
      'sub_category': subCategory,
      'primary_cuisine': primaryCuisine,
      'secondary_cuisine': secondaryCuisine,
      'avg_price_per_person': avgPricePerPerson,
      'pure_veg': pureVeg,
      'alcohol': alcohol,
      'table_count': tableCount,
      'seating_capacity': seatingCapacity,
      'reserve_table_online': reserveTableOnline,
      'rating': rating,
      'review_count': reviewCount,
      'delivery_charge': deliveryCharge,
      'busy': busy,
      'packaging_charge': packingCharge,
    };
  }

  bool get closed {
    DateTime now = DateTime.now();
    DateTime opening = DateTime(
        now.year, now.month, now.day, openingTime.hour, openingTime.minute);
    DateTime closing = DateTime(
        now.year, now.month, now.day, closingTime.hour, closingTime.minute);

    if (closingTime.hour < openingTime.hour) {
      closing = closing.add(const Duration(days: 1));
    }

    return now.isBefore(opening) || now.isAfter(closing);
  }

  StoreType get storeType {
    return GlobalConsts.categories
            .where((element) => element.name == category)
            .firstOrNull
            ?.type ??
        StoreType.service;
  }

  bool get campusDeliveryService {
    return primaryCuisine == 'MIT Campus Only' ||
        secondaryCuisine == 'MIT Campus Only';
  }
}
