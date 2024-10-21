// models/product.dart
import 'package:openzo_frontend/models/store.dart';

class Product {
  String id;
  String name;
  String description;
  int mrp;
  String quantityUnit;
  int discountPrice;
  List<ProductImage> images;
  List<SizeVariant> sizeVariants;
  List<ColorVariant> colorVariants;
  String brand;
  String category;
  String storeID;
  String barcode;
  String? type;
  String? vegType;
  int? servers;
  bool outOfStock;
  String? storeName;
  int displayOrder;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.quantityUnit,
    required this.mrp,
    this.discountPrice = 0,
    this.brand = '',
    required this.sizeVariants,
    required this.colorVariants,
    required this.images,
    required this.category,
    required this.storeID,
    required this.barcode,
    this.outOfStock = false,
    this.type,
    this.vegType,
    this.servers,
    this.storeName,
    this.displayOrder = 0,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      quantityUnit: json['quantity_unit'] ?? '',
      mrp: json['mrp'],
      discountPrice: json['discount_price'] ?? json['mrp'],
      barcode: json['barcode'],
      images: (json['images'] as List)
          .map((image) => ProductImage.fromJson(image))
          .toList(),
      category: json['category'],
      storeID: json['store_id'],
      brand: json['brand'],
      sizeVariants: (json['size_variants'] as List)
          .map((variant) => SizeVariant.fromJson(variant))
          .toList(),
      colorVariants: (json['color_variants'] as List)
          .map((variant) => ColorVariant.fromJson(variant))
          .toList(),
      type: json['type'],
      vegType: json['veg_type'],
      servers: json['servers'],
      storeName: json['store_name'],
      outOfStock: json['out_of_stock'] ?? false,
      displayOrder: json['display_order'] ?? 0,
    );
  }
}

// models/size_variant.dart
class SizeVariant {
  int id;
  String productID;
  String size;
  int price;
  int quantity;

  SizeVariant({
    required this.id,
    required this.productID,
    required this.size,
    required this.price,
    required this.quantity,
  });

  factory SizeVariant.fromJson(Map<String, dynamic> json) {
    return SizeVariant(
      id: json['id'],
      productID: json['product_id'],
      size: json['size'],
      price: json['price'],
      quantity: json['quantity'],
    );
  }
}

// models/color_variant.dart
class ColorVariant {
  final int id;
  final String productID;
  final String color;
  final int price;
  final int quantity;

  ColorVariant({
    required this.id,
    required this.productID,
    required this.color,
    required this.price,
    required this.quantity,
  });

  factory ColorVariant.fromJson(Map<String, dynamic> json) {
    return ColorVariant(
      id: json['id'],
      productID: json['product_id'],
      color: json['color'],
      price: json['price'],
      quantity: json['quantity'],
    );
  }
}

class ProductImage {
  final int id;
  final String productID;
  final String image;

  ProductImage({
    required this.id,
    required this.productID,
    required this.image,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json['id'],
      productID: json['product_id'],
      image: json['image'],
    );
  }
}

class Post {
  Product post;
  StoreBasicDetails store;

  Post({
    required this.post,
    required this.store,
  });
}
