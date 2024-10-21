import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:openzo_frontend/models/product.dart';
import 'package:openzo_frontend/repositories/product_repository.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ProductPageViewModel extends ChangeNotifier {
  late Product product;
  SizeVariant? selectedSize;
  ColorVariant? selectedColor;
  bool isLoading = true;

  Future<void> fetchProduct(String productId) async {
    product = await ProductRepository.fetchProduct(productId);
    selectedSize =
        product.sizeVariants.isNotEmpty ? product.sizeVariants.first : null;
    selectedColor =
        product.colorVariants.isNotEmpty ? product.colorVariants.first : null;
    isLoading = false;
    notifyListeners();
  }

  Future<void> shareProduct() async {
    try {
      final uri =
          Uri.parse(product.images.isNotEmpty ? product.images[0].image : '');
      final response = await http.get(uri);
      final imageBytes = response.bodyBytes;
      final tempDir = await getTemporaryDirectory();
      final path = '${tempDir.path}/${product.id}.png';
      await File(path).writeAsBytes(imageBytes);

      await Share.shareXFiles([XFile(path)], text: _generateProductShareText());
    } catch (e) {
      print('Error sharing product: $e');
    }
  }

  String _generateProductShareText() {
    return '''*${product.name}*
${product.description}
Price: ~₹${product.mrp}~ ₹${product.discountPrice}
https://openzo.in/store/${product.storeID}/product/${product.id}
''';
  }

  void selectSize(SizeVariant size) {
    selectedSize = size;
    notifyListeners();
  }

  void selectColor(ColorVariant color) {
    selectedColor = color;
    notifyListeners();
  }
}
