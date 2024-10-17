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

  static String endpoint = '${GlobalConsts.backend_url}/products';

  // Static in-memory cache
  static final Map<String, Product> _productCache = {};

  // Static map to keep track of ongoing fetch requests
  static final Map<String, Future<Product>> _productFutures = {};

  // Static in-memory cache for list of products with storeID as key
  static final Map<String, List<Product>> _productCacheByStore = {};

  // Cache timestamps for invalidation
  static final Map<String, DateTime> _productCacheTimestamps = {};

  // Define cache duration
  static const Duration cacheDuration = Duration(hours: 1);

  /// Fetch a single product by its ID with caching
  static Future<Product> fetchOne(String productID) async {
    
    // Check if the product is already in the cache and not expired
    if (_productCache.containsKey(productID)) {
      final cachedTime = _productCacheTimestamps[productID];
      if (cachedTime != null &&
          DateTime.now().difference(cachedTime) < cacheDuration) {
        return _productCache[productID]!;
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
          'Authorization': '$token',
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

  /// Method to clear the cache (useful for testing or refreshing data)
  static void clearCache() {
    _productCache.clear();
    _productCacheTimestamps.clear();
    _productFutures.clear();
  }

  /// Fetch multiple products by storeID with caching
  static Future<List<Product>> fetchMany(String storeID) async {
    // Check if the products for this store are already in the cache and not expired
    if (_productCacheByStore.containsKey(storeID)) {
      final cachedTime = _productCacheTimestamps[storeID];
      if (cachedTime != null &&
          DateTime.now().difference(cachedTime) < cacheDuration) {
        return _productCacheByStore[storeID]!;
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

      final response = await http.get(
        Uri.parse('$endpoint/store/$storeID'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': '$token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> productsJson = json.decode(response.body);
        List<Product> products = productsJson
            .map((productJson) => Product.fromJson(productJson))
            .toList();

        // Cache individual products
        for (var product in products) {
          _productCache[product.id] = product;
          _productCacheTimestamps[product.id] = DateTime.now();
        }

        log('Fetched ${products.length} products for storeID "$storeID"');

        // Cache the list of products for this store
        _productCacheByStore[storeID] = products;
        _productCacheTimestamps[storeID] = DateTime.now();

        return products;
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Invalid token');
      } else {
        log('Failed to fetch products for storeID "$storeID": ${response.statusCode} ${response.reasonPhrase}');
        throw Exception('Failed to load products');
      }
    } catch (e) {
      log('Error in fetchMany: $e');
      rethrow;
    }
  }

  /// Search products with caching
  static Future<List<Product>> searchProducts(
      String pincode, String nameContains) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final response = await http.get(
        Uri.parse(
            '${GlobalConsts.backend_url}/search/products/$pincode?term=$nameContains'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': '$token',
        },
      );
      log('Search Products Response: ${response.body}');
      if (response.statusCode == 200) {
        List<dynamic> productsJson = jsonDecode(response.body);
        List<Product> products = productsJson
            .map((productJson) => Product.fromJson(productJson))
            .toList();

        // Optionally cache individual products
        for (var product in products) {
          _productCache[product.id] = product;
          _productCacheTimestamps[product.id] = DateTime.now();
        }

        log('Found ${products.length} products matching "$nameContains" in pincode "$pincode"');
        return products;
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Invalid token');
      } else {
        log('Failed to search products: ${response.statusCode} ${response.reasonPhrase}');
        return [];
      }
    } catch (e) {
      log('Error in searchProducts: $e');
      return [];
    }
  }

  /// Fetch posts by pincode with proper parsing
  static Future<List<Post>> fetchPostByPincode(String pincode) async {
    try {
      final response = await http.get(
        Uri.parse('$endpoint/post/pincode/$pincode'),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<Post> posts = data.map((item) {
          Product product = Product.fromJson(item['product']);
          StoreBasicDetails store = StoreBasicDetails.fromJson(item['store']);
          return Post(post: product, store: store);
        }).toList();

        return posts;
      } else {
        log('Failed to fetch posts by pincode: ${response.statusCode} ${response.reasonPhrase}');
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      log('Error in fetchPostByPincode: $e');
      rethrow;
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
      sizeVariants: json['size_variants'] != null
          ? (json['size_variants'] as List)
              .map((sizeVariant) => SizeVariant.fromJson(sizeVariant))
              .toList()
          : [],
      colorVariants: json['color_variants'] != null
          ? (json['color_variants'] as List)
              .map((colorVariant) => ColorVariant.fromJson(colorVariant))
              .toList()
          : [],
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
