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

class Product {
  final int id;
  final String name;
  final String description;
  final int price;
  final int quantity;
  final List<ProductImage> images;
  final String category;
  final int storeID;
  final String barcode;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.images,
    required this.category,
    required this.storeID,
    required this.barcode,
  });

  static Future<List<Product>> fetchMany(int storeID) async {
    List<Product> products = [];
    // fetch products from the server
    http.Request req = http.Request('GET',
        Uri.parse('${GlobalConsts.backend_url}/product?store_id=$storeID'));
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
      Uri.parse('${GlobalConsts.backend_url}/product?order_id=$orderId'),
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

  static addProduct(Product product) async {
    // add product to the server
    http.Response res = await http.post(
      Uri.parse('${GlobalConsts.backend_url}/product/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': GlobalConsts.token,
      },
      body: jsonEncode({
        'name': product.name,
        'description': product.description,
        'price': product.price,
        'quantity': product.quantity,
        'category': product.category,
        'store_id': product.storeID,
        'barcode': product.barcode,
        'images':
            product.images.map((e) => {'id': e.id, 'image': e.image}).toList()
      }),
    );

    print(res.body);
  }

  static GetProductByBarCode(String barcode) async {
    http.Response res = await http.get(
      Uri.parse('${GlobalConsts.backend_url}/product?barcode=$barcode'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': GlobalConsts.token,
      },
    );
    print(res.body);
    if (res.statusCode == 200) {
      return Product.fromJson(jsonDecode(res.body));
    } else {
      return null;
    }
  }

  static updateProduct(Product product) async {
    http.Response res = await http.put(
      Uri.parse('${GlobalConsts.backend_url}/product/${product.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': GlobalConsts.token,
      },
      body: jsonEncode({
        'name': product.name,
        'description': product.description,
        'price': product.price,
        'quantity': product.quantity,
        'category': product.category,
        'store_id': product.storeID,
        'barcode': product.barcode,
        'images':
            product.images.map((e) => {'id': e.id, 'image': e.image}).toList()
      }),
    );

    print(res.body);
  }

  static deleteProduct(int productID) async {
    http.Response res = await http.delete(
        Uri.parse('${GlobalConsts.backend_url}/product/$productID'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': GlobalConsts.token,
        });
    if (res.statusCode == 200) {
      print('Product deleted');
    } else {
      print('Product not deleted');
    }
  }

// else if pincode != "" && nameContains != "" {
// 		var products []models.Product
// 		router.DB.Preload("Images").Joins("JOIN stores ON stores.id = products.store_id").Find(&products, "stores.pincode = ? AND products.name LIKE ?", pincode, "%"+nameContains+"%")
// 		c.JSON(200, products)
// 		return
// 	}

  static Future<List<Product>> searchProducts(
      String pincode, String nameContains) async {
    List<Product> products = [];
    http.Response res = await http.get(
      Uri.parse(
          '${GlobalConsts.backend_url}/product?pincode=$pincode&name_contains=$nameContains'),
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
      price: json['price'],
      quantity: json['quantity'],
      barcode: json['barcode'],
      images: (json['images'] as List)
          .map((image) => ProductImage.fromJson(image))
          .toList(),
      category: json['category'],
      storeID: json['store_id'],
    );
  }
}

class ProductImage {
  final int id;
  final int productID;
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
