// type Product struct {
// 	ID          int            `json:"id"`
// 	Name        string         `json:"name"`
// 	Description string         `json:"description"`
// 	Price       int            `json:"price"`
// 	Quantity    int            `json:"quantity"`
// 	Images      []ProductImage `json:"images"`
// 	Category    string         `json:"category"`
// Barcode     string         `json:"barcode"`

// 	StoreID     int            `json:"store_id"`
// }

// type ProductImage struct {
// 	ID        int    `json:"id"`
// 	ProductID int    `json:"product_id"`
// 	Image     string `json:"image" gorm:"type:text"`
// }

// type Category struct {
// 	ID      int    `json:"id"`
// 	Name    string `json:"name"`
// 	StoreID int    `json:"store_id"`
// }

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:openzo_frontend/constants/constants.dart';

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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productID,
      'size': size,
      'price': price,
      'quantity': quantity,
    };
  }

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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productID,
      'color': color,
      'price': price,
      'quantity': quantity,
    };
  }
}

class Product {
  String id;
  String name;
  String description;
  int mrp;
  String quantityUnit;
  int msrp;
  int discountPrice = 0;
  int quantity;
  List<ProductImage> images;
  List<SizeVariant> sizeVariants = [];
  List<ColorVariant> colorVariants = [];
  String brand;
  int criticalQuantity;
  String customCode;
  String category;
  String storeID;
  String barcode;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.quantityUnit,
    required this.mrp,
    required this.msrp,
    this.discountPrice = 0,
    this.brand = '',
    this.criticalQuantity = 0,
    this.customCode = '',
    required this.sizeVariants,
    required this.colorVariants,
    required this.quantity,
    required this.images,
    required this.category,
    required this.storeID,
    required this.barcode,
  });

  static Future<List<Product>> fetchMany(String storeID) async {
    List<Product> products = [];
    // fetch products from the server
    http.Request req = http.Request('GET',
        Uri.parse('${GlobalConsts.backend_url}/products/store/$storeID'));
    http.StreamedResponse res = await req.send();

    String body = await res.stream.bytesToString();

    var products0 = json.decode(body);
    // print(_products);
    products0.forEach((product) {
      products = [...products, Product.fromJson(product)];
    });

    return products;
  }


  static Future<Product> fetchOne(int productID) async {
    // fetch products from the server
    http.Request req = http.Request(
        'GET', Uri.parse('${GlobalConsts.backend_url}/product/$productID'));
    http.StreamedResponse res = await req.send();

    String body = await res.stream.bytesToString();

    var product = json.decode(body);

    return Product.fromJson(product);
  }

  static getItemsByOrderId(int orderId) async {
    List<Product> products = [];
    http.Response res = await http.get(
      Uri.parse('${GlobalConsts.backend_url}/product/?order_id=$orderId'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': GlobalConsts.token,
      },
    );
    print(res.body);
    if (res.statusCode == 200) {
      for (var product in jsonDecode(res.body)) {
        products.add(Product.fromJson(product));
      }
      return products;
    } else {
      return null;
    }
  }

  static Future<List<Product>> searchProducts(
      String pincode, String nameContains) async {
    List<Product> products = [];
    http.Response res = await http.get(
      Uri.parse(
          '${GlobalConsts.backend_url}/product/?pincode=$pincode&name_contains=$nameContains'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': GlobalConsts.token,
      },
    );
    print(res.body);
    if (res.statusCode == 200) {
      for (var product in jsonDecode(res.body)) {
        products.add(Product.fromJson(product));
      }
      return products;
    } else {
      return [];
    }
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      quantityUnit: json['quantity_unit'],
      mrp: json['mrp'],
      msrp: json['msrp'],
      discountPrice: json['discount_price'],
      quantity: json['quantity'],
      barcode: json['barcode'],
      images: (json['images'] as List)
          .map((image) => ProductImage.fromJson(image))
          .toList(),
      category: json['category'],
      storeID: json['store_id'],
      brand: json['brand'],
      criticalQuantity: json['critical_quantity'],
      customCode: json['custom_code'],
      sizeVariants: (json['size_variants'] as List)
          .map((sizeVariant) => SizeVariant.fromJson(sizeVariant))
          .toList(),
      colorVariants: (json['color_variants'] as List)
          .map((colorVariant) => ColorVariant.fromJson(colorVariant))
          .toList(),
    );
  }

  Map<String, dynamic>  toJson() {
    Product product = this;
    return {
      'id': product.id,
      'name': product.name,
      'description': product.description,
      'mrp': product.mrp,
      'msrp': product.msrp,
      'discount_price': product.discountPrice,
      'quantity': product.quantity,
      'barcode': product.barcode,
      'images':
          product.images.map((e) => {'id': e.id, 'image': e.image}).toList(),
      'category': product.category,
      'store_id': product.storeID,
    };
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
