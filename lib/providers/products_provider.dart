import 'package:flutter/material.dart';
import 'package:openzo_frontend/models/product.dart';

class ProductsProvider extends ChangeNotifier {
  ProductsProvider();

  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  int _sortIndex = 0;
  int get sortIndex => _sortIndex;

  List<String> _selectedCategories = [];
  List<String> get selectedCategories => _selectedCategories;

  List<String> _stockStatuses = [];
  List<String> get stockStatuses => _stockStatuses;

  List<String> _selectedVegTypes = [
    'Veg',
    'Egg',
    'Non-Veg',
  ];
  List<String> get selectedVegTypes => _selectedVegTypes;

  String _searchQuery = '';

  List<Product> get products => _products;
  List<Product> get filteredProducts => _filteredProducts;

  List<String> get categories {
    return _products.map((product) => product.category).toSet().toList();
  }

  Future<List<Product>> fetch(String storeId) async {
    _products = await Product.fetchMany(storeId);
    _products.sort((a, b) => b.displayOrder.compareTo(a.displayOrder));
    _filteredProducts = List.from(_products);
    notifyListeners();
    return _products;
  }

  Future<void> setProducts(List<Product> products) async {
    _products = products;
    _products.sort((a, b) => b.displayOrder.compareTo(a.displayOrder));

    _filteredProducts = List.from(_products);
    // notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    _products.add(product);
    _applyFilters();
  }

  Future<void> updateProduct(Product product) async {
    _products = _products
        .map((element) => element.id == product.id ? product : element)
        .toList();
    _applyFilters();
  }

  Future<void> removeProduct(Product product) async {
    _products = _products.where((element) => element.id != product.id).toList();
    _applyFilters();
  }

  void updateSortIndex(int index) {
    _sortIndex = index;
    _applyFilters();
  }

  void updateSelectedCategories(List<String> categories) {
    _selectedCategories = categories;
    _applyFilters();
  }

  void updateSelectedStockStatuses(List<String> statuses) {
    _stockStatuses = statuses;
    _applyFilters();
  }

  void updateSelectedVegTypes(List<String> vegTypes) {
    _selectedVegTypes = vegTypes;
    _applyFilters();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void resetFilters() {
    _sortIndex = 0;
    _selectedCategories = [];
    _stockStatuses = [];
    _searchQuery = '';
    _filteredProducts = List.from(_products);
    _selectedVegTypes = [
      'Veg',
      'Egg',
      'Non-Veg',
    ];
    notifyListeners();
  }

  void _applyFilters() {
    List<Product> tempProducts = List.from(_products);

    if (_selectedCategories.isNotEmpty) {
      tempProducts = tempProducts
          .where((product) => _selectedCategories.contains(product.category))
          .toList();
    }

    if (_searchQuery.isNotEmpty) {
      tempProducts = tempProducts
          .where((product) =>
              product.name.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    if (_stockStatuses.isNotEmpty) {
      tempProducts = tempProducts
          .where((product) => _stockStatuses
              .contains(product.outOfStock ? 'Out of Stock' : 'In Stock'))
          .toList();
    }

    if (_selectedVegTypes.isNotEmpty) {
      tempProducts = tempProducts
          .where((product) => _selectedVegTypes.contains(product.vegType))
          .toList();
    }

    switch (_sortIndex) {
      case 0:
        tempProducts.sort((a, b) => b.id.compareTo(a.id));
        break;
      case 1:
        tempProducts.sort((a, b) => a.discountPrice.compareTo(b.discountPrice));
        break;
      case 2:
        tempProducts.sort((a, b) => b.discountPrice.compareTo(a.discountPrice));
        break;
    }

    _filteredProducts = tempProducts;
    notifyListeners();
  }
}
