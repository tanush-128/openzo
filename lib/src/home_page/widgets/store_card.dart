import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:openzo_frontend/components/rating.dart';
import 'package:openzo_frontend/constants/constants.dart';
import 'package:openzo_frontend/models/store.dart';

class StoreCard extends StatefulWidget {
  final Store store;
  const StoreCard({super.key, required this.store});

  @override
  State<StoreCard> createState() => _StoreCardState();
}

class _StoreCardState extends State<StoreCard> {
  bool isFavourite = false;
  late StoreType storeType;

  @override
  void initState() {
    super.initState();
    storeType = GlobalConsts.categories
        .firstWhere((element) => element.name == widget.store.category)
        .type;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.go('/store/${widget.store.id}');
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: Colors.grey.shade200,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            _buildImage(),
            _buildDetails(context),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        image: widget.store.image != ""
            ? DecorationImage(
                image: NetworkImage(widget.store.image),
                fit: BoxFit.cover,
              )
            : null,
        color: Colors.grey.shade300,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSubCategoryLabel(),
          ],
        ),
      ),
    );
  }

  Widget _buildSubCategoryLabel() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Text(
        widget.store.subCategory,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildFavoriteIcon() {
    return InkWell(
      onTap: () {
        setState(() {
          isFavourite = !isFavourite;
        });
      },
      child: Icon(
        isFavourite ? Icons.favorite : Icons.favorite_border,
        color: isFavourite ? Colors.red : Colors.white,
        size: 30,
      ),
    );
  }

  Widget _buildDetails(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitleAndRating(),
          const SizedBox(height: 5),
          if (storeType != StoreType.food) _buildDescription(),
          if (storeType == StoreType.food) _buildCuisineAndPrice(),
          const SizedBox(height: 5),
        ],
      ),
    );
  }

  Widget _buildTitleAndRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            widget.store.name,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
        Row(
          children: [
            widget.store.reviewCount > 0
                ? Rating(rating: widget.store.rating)
                : Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade100,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Text(
                      "New",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                  ),
            const SizedBox(width: 5),
            if (storeType == StoreType.food) _buildVegIndicator(),
          ],
        ),
      ],
    );
  }

  Widget _buildVegIndicator() {
    return widget.store.pureVeg!
        ? const ImageIcon(
            AssetImage('assets/icons/veg.png'),
            color: Colors.green,
          )
        : const Row(
            children: [
              ImageIcon(
                AssetImage('assets/icons/veg.png'),
                color: Colors.green,
              ),
              ImageIcon(
                AssetImage('assets/icons/veg.png'),
                color: Colors.red,
              ),
            ],
          );
  }

  Widget _buildDescription() {
    return Text(
      widget.store.description,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildCuisineAndPrice() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "\u2022 ${widget.store.primaryCuisine} \u2022 ${widget.store.secondaryCuisine}",
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
        ),
        Text(
          "₹${widget.store.avgPricePerPerson} for one",
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
