import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:openzo_frontend/constants/constants.dart';
import 'package:openzo_frontend/models/store.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class Post {
  Product post;
  StoreBasicDetails store;

  Post({
    required this.post,
    required this.store,
  });
}

// product.dart

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

  static String endpoint = '${GlobalConsts.backend_url}/products';
  // static String endpoint = 'https://lnn7jf70-8080.inc1.devtunnels.ms';

  // Static in-memory cache
  static final Map<String, Product> _productCache = {};

  // Static map to keep track of ongoing fetch requests
  static final Map<String, Future<Product>> _productFutures = {};

  //static in-memory cache for list of products with storeID as key

  static final Map<String, List<Product>> _productCacheByStore = {};

  // Optional: Cache timestamps for invalidation
  static final Map<String, DateTime> _productCacheTimestamps = {};

  // Define cache duration
  static final Duration cacheDuration =
      const Duration(hours: 1); // Adjust as needed

  /// Fetch a single product by its ID with caching
  static Future<Product> fetchOne(String productID) async {
    // Check if the product is already in the cache and not expired
    if (_productCache.containsKey(productID)) {
      final cachedTime = _productCacheTimestamps[productID];
      if (cachedTime != null &&
          DateTime.now().difference(cachedTime) < cacheDuration) {
        return Future.value(_productCache[productID]!);
      } else {
        // Cache expired, remove it
        _productCache.remove(productID);
        _productCacheTimestamps.remove(productID);
      }
    }

    // If a fetch is already in progress for this productID, return the existing Future
    if (_productFutures.containsKey(productID)) {
      return _productFutures[productID]!;
    }

    // Initiate a new fetch and store the Future in _productFutures
    final future = _fetchProductFromApi(productID).then((product) {
      _productCache[productID] = product; // Store in cache
      _productCacheTimestamps[productID] =
          DateTime.now(); // Update cache timestamp
      _productFutures.remove(productID); // Remove from ongoing fetches
      return product;
    }).catchError((error) {
      _productFutures.remove(productID); // Remove from ongoing fetches on error
      throw error;
    });

    _productFutures[productID] = future;

    return future;
  }

  /// Internal method to fetch product data from the API
  static Future<Product> _fetchProductFromApi(String productID) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final response = await http.get(
        Uri.parse('$endpoint/$productID'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token, // Correctly include the token
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final product = Product.fromJson(data);
        log('Fetched Product: ${product.name}');
        return product;
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Invalid token');
      } else if (response.statusCode == 404) {
        throw Exception('Product not found');
      } else {
        throw Exception(
            'Failed to load product: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      log('Error fetching product: $e');
      rethrow;
    }
  }

  /// Optional: Method to clear the cache (useful for testing or refreshing data)
  static void clearCache() {
    _productCache.clear();
    _productCacheTimestamps.clear();
    _productFutures.clear();
  }

  /// Fetch multiple products by storeID with caching
  static Future<List<Product>> fetchMany(String storeID) async {
    List<Product> products = [];

    // Implement caching for fetchMany if needed
    // For simplicity, assuming fetchMany fetches all products for a store and caching individual products

    // Check if the products for this store are already in the cache and not expired
    if (_productCacheByStore.containsKey(storeID)) {
      final cachedTime = _productCacheTimestamps[storeID];
      if (cachedTime != null &&
          DateTime.now().difference(cachedTime) < cacheDuration) {
        return Future.value(_productCacheByStore[storeID]!);
      } else {
        // Cache expired, remove it
        _productCacheByStore.remove(storeID);
        _productCacheTimestamps.remove(storeID);
      }
    }

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('Authentication token not found');
      }

      http.Request req =
          http.Request('GET', Uri.parse('$endpoint/store/$storeID'));
      req.headers['Content-Type'] = 'application/json; charset=UTF-8';
      req.headers['Authorization'] = token;

      http.StreamedResponse res = await req.send();

      String body = await res.stream.bytesToString();

      if (res.statusCode == 200) {
        var productsJson = json.decode(body);
        for (var productJson in productsJson) {
          Product product = Product.fromJson(productJson);
          products.add(product);
          // Cache individual products
          if (!_productCache.containsKey(product.id)) {
            _productCache[product.id] = product;
            _productCacheTimestamps[product.id] = DateTime.now();
          }
        }
        log('Fetched ${products.length} products for storeID "$storeID"');

        // Cache the list of products for this store
        _productCacheByStore[storeID] = products;
        _productCacheTimestamps[storeID] = DateTime.now();

        return products;
      } else if (res.statusCode == 401) {
        throw Exception('Unauthorized: Invalid token');
      } else {
        log('Failed to fetch products for storeID "$storeID": ${res.statusCode} ${res.reasonPhrase}');
        throw Exception('Failed to load products');
      }
    } catch (e) {
      log('Error in fetchMany: $e');
      throw e;
    }
  }

  /// Search products with caching
  static Future<List<Product>> searchProducts(
      String pincode, String nameContains) async {
    List<Product> products = [];
    final queryKey = '$pincode|$nameContains';

    // Implement caching for search results if desired
    // For simplicity, not caching search results as they can be highly variable

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final res = await http.get(
        Uri.parse(
            '${GlobalConsts.backend_url}/search/products/$pincode?term=$nameContains'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      log('Search Products Response: ${res.body}');
      if (res.statusCode == 200) {
        for (var productJson in jsonDecode(res.body)) {
          products.add(Product.fromJson(productJson));
          // Optionally cache individual products
          if (!_productCache.containsKey(productJson['id'])) {
            Product product = Product.fromJson(productJson);
            _productCache[product.id] = product;
            _productCacheTimestamps[product.id] = DateTime.now();
          }
        }
        log('Found ${products.length} products matching "$nameContains" in pincode "$pincode"');
        return products;
      } else if (res.statusCode == 401) {
        throw Exception('Unauthorized: Invalid token');
      } else {
        log('Failed to search products: ${res.statusCode} ${res.reasonPhrase}');
        return [];
      }
    } catch (e) {
      log('Error in searchProducts: $e');
      return [];
    }
  }

  /// Fetch posts by pincode with caching for products and stores
  static Future<List<Post>> fetchPostByPincode(String pincode) async {
    final res = await http.get(
      Uri.parse('$endpoint/post/pincode/$pincode'),
    );

    if (res.statusCode == 200) {
      List<Product> products = [];
      List<StoreBasicDetails> stores = [];
      for (var product in jsonDecode(res.body)) {
        products.add(Product.fromJson(product));
      }

      for (var store in jsonDecode(res.body)) {
        // StoreBasicDetails store = await StoreBasicDetails.getStoreBasicDetailsByID(store.storeID);
        stores.add(StoreBasicDetails.fromJson(store));
      }

      List<Post> posts = [];
      for (int i = 0; i < products.length; i++) {
        posts.add(Post(post: products[i], store: stores[i]));
      }

      return posts;

      // log(stores.toString());
      // return products;
    } else {
      print(res.body);
      throw Exception('Failed to load products');
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
      outOfStock: json['out_of_stock'] ?? false,
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
