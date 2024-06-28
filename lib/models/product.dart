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

  int discountPrice = 0;
  List<ProductImage> images;
  List<SizeVariant> sizeVariants = [];
  List<ColorVariant> colorVariants = [];
  String brand;

  String category;
  String storeID;
  String barcode;

//
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

  static Future<Product> fetchOne(String productID) async {
// fetch products from the server
    http.Request req = http.Request(
        'GET', Uri.parse('${GlobalConsts.backend_url}/products/$productID'));
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
          '${GlobalConsts.backend_url}/search/products/$pincode?term=$nameContains'),
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
      quantityUnit: json['quantity_unit'] ?? '',
      mrp: json['mrp'],
      discountPrice: json['discount_price'] ?? json['mrp'],
      barcode: json['barcode'],
      images: json['images'] != null
          ? (json['images'] as List)
              .map((image) => ProductImage.fromJson(image))
              .toList()
          : [],
      category: json['category'],
      storeID: json['store_id'],
      brand: json['brand'],
      sizeVariants: json['size_variants'] == null
          ? []
          : (json['size_variants'] as List)
              .map((sizeVariant) => SizeVariant.fromJson(sizeVariant))
              .toList(),
      colorVariants: json['color_variants'] == null
          ? []
          : (json['color_variants'] as List)
              .map((colorVariant) => ColorVariant.fromJson(colorVariant))
              .toList(),
      type: json['type'],
      vegType: json['veg_type'],
      servers: json['servers'],
      storeName: json['store_name'],
      outOfStock: json['out_of_stock'],
      displayOrder: json['display_order'] ?? 0,
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
