import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:openzo_frontend/models/product.dart';

class PostCard extends StatelessWidget {
  final Product product;

  const PostCard({
    super.key,
    required this.product,
  });

  // Future<void> shareProduct() async {
  //   try {
  //     final uri = Uri.parse(product.images.isNotEmpty
  //         ? product.images[0].image
  //         : ''); // Default placeholder if no image
  //     final response = await http.get(uri);
  //     final imageBytes = response.bodyBytes;
  //     final tempDir = await getTemporaryDirectory();
  //     final path = '${tempDir.path}/${product.id}.png';
  //     await File(path).writeAsBytes(imageBytes);

  //     await Share.shareXFiles([XFile(path)], text: _generateProductShareText());
  //   } catch (e) {
  //     print('Error sharing product: $e');
  //   }
  // }

  String _generateProductShareText() {
    return '''*${product.name}*
${product.description}
MRP: ₹${product.mrp}
Discounted Price: ₹${product.discountPrice}''';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10, top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProductImage(),
          // const SizedBox(width: 12),
          _buildProductDetails(context)

          // if (isEditable) _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildProductImage() {
    return Container(
        // height: 10
        // height: 300,

        child: product.images.isEmpty
            ? Center(
                child: Icon(
                  Icons.image,
                  color: Colors.grey.shade300,
                  size: 40,
                ),
              )
            : Image(
                image: NetworkImage(product.images[0].image),
                fit: BoxFit.cover,
                width: double.infinity,
              ));
  }

  Widget _buildProductDetails(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.name,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
          Text(
            product.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
