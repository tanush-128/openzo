import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:openzo_frontend/models/product.dart';
import 'package:openzo_frontend/models/store.dart';

class PostCard extends StatefulWidget {
  final Product product;
  final StoreBasicDetails? store;
  const PostCard({
    super.key,
    required this.product,
    this.store,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 10, top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.store != null
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6.0, vertical: 4.0),
                  child: InkWell(
                    onTap: () {
                      context.go('/store/${widget.product.storeID}');
                    },
                    child: Row(
                      children: [
                        widget.store!.image != ""
                            ? CircleAvatar(
                                backgroundImage:
                                    NetworkImage(widget.store!.image),
                                radius: 20,
                              )
                            : CircleAvatar(
                                backgroundColor: Colors.grey.shade300,
                                radius: 20,
                                child: Icon(
                                  Icons.store,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.store!.name,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                widget.store!.description,
                                style: GoogleFonts.poppins(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : const SizedBox(),
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

        child: widget.product.images.isEmpty
            ? Center(
                child: Icon(
                  Icons.image,
                  color: Colors.grey.shade300,
                  size: 40,
                ),
              )
            : Image(
                image: NetworkImage(widget.product.images[0].image),
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
            widget.product.name,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
          Text(
            widget.product.description,
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
