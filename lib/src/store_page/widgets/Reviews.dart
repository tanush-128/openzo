import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:openzo_frontend/models/review.dart';
import 'package:openzo_frontend/models/store.dart';
import 'package:openzo_frontend/providers/user_provider.dart';
import 'package:openzo_frontend/utils/capitalize.dart';
import 'package:provider/provider.dart';

class ReviewsList extends StatefulWidget {
  final String storeId;
  final Future<Store> storeData;
  const ReviewsList({
    super.key,
    required this.storeId,
    required this.storeData,
  });

  @override
  State<ReviewsList> createState() => _ReviewsListState();
}

class _ReviewsListState extends State<ReviewsList> {
  late final reviewData =
      Future.value(Review.getReviewsByStoreID(widget.storeId));
  String userId = "";

  @override
  void initState() {
    userId = Provider.of<UserProvider>(context, listen: false).user.id;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 60),
      // padding: const EdgeInsets.only(top: 120),
      child: FutureBuilder<List<Review>>(
        future: reviewData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString(),
                  style: const TextStyle(color: Colors.red)),
            );
          }
          if (snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No reviews found'),
            );
          }
          List<Review> reviews = snapshot.data!;
          Review? userReview =
              reviews.where((element) => element.userId == userId).firstOrNull;
          if (userReview != null) {
            reviews.remove(userReview);
            reviews.insert(0, userReview);
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                FutureBuilder(
                    future: widget.storeData,
                    builder:
                        (BuildContext context, AsyncSnapshot<Store> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(snapshot.error.toString(),
                              style: const TextStyle(color: Colors.red)),
                        );
                      }
                      Store store = snapshot.data!;
                      double averageRating = store.rating;
                      int reviewCount = store.reviewCount;
                      Map<String, int> ratingDistribution = {
                        'Excellent': reviews
                            .where((review) => review.rating == 5)
                            .length,
                        'Good': reviews
                            .where((review) => review.rating == 4)
                            .length,
                        'Average': reviews
                            .where((review) => review.rating == 3)
                            .length,
                        'Below Average': reviews
                            .where((review) => review.rating == 2)
                            .length,
                        'Poor': reviews
                            .where((review) => review.rating == 1)
                            .length,
                      };
                      return ReviewSummary(
                        averageRating: averageRating,
                        reviewCount: reviewCount,
                        ratingDistribution: ratingDistribution,
                      );
                    }),
                Column(
                  children: reviews
                      .map((review) => ReviewTile(
                          review: review, byUser: review.userId == userId))
                      .toList(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ReviewTile extends StatelessWidget {
  final Review review;
  final bool byUser;
  const ReviewTile({super.key, required this.review, this.byUser = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
      ),
      child: Stack(
        children: [
          byUser
              ? const Positioned(
                  bottom: 0,
                  right: 0,
                  child: Icon(Icons.edit),
                )
              : const SizedBox(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 2),
                        child: Row(
                          children: [
                            for (int i = 0; i < review.rating; i++)
                              const Icon(
                                Icons.star_rounded,
                                color: Colors.amber,
                                size: 24,
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${review.rating}.0',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                  const Spacer(),
                  Text(
                    DateFormat.yMMMd().format(review.createdAt),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4, left: 8),
                child: Text(
                  capitalize(review.review),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

//compnent that would be in bottom app bar for adding review

class AddReviewButton extends StatelessWidget {
  final String storeId;

  const AddReviewButton({super.key, required this.storeId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ElevatedButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) {
              return AddReviewModal(storeId: storeId);
            },
          );
        },
        child: const Text('Write a Review'),
      ),
    );
  }
}

class AddReviewModal extends StatefulWidget {
  final String storeId;

  const AddReviewModal({super.key, required this.storeId});

  @override
  _AddReviewModalState createState() => _AddReviewModalState();
}

class _AddReviewModalState extends State<AddReviewModal> {
  final TextEditingController _reviewController = TextEditingController();
  int _rating = 0;
  String userId = ""; // Replace this with your user ID fetching logic

  @override
  void initState() {
    super.initState();
    // Assuming userId is set via context, provider, etc.
    userId = Provider.of<UserProvider>(context, listen: false).user.id;
  }

  Future<void> submitReview() async {
    if (_reviewController.text.isEmpty || _rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please provide a rating and a review.'),
        ),
      );
      return;
    }

    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Create review
      await Review.createReview(
        Review(
          storeId: widget.storeId,
          rating: _rating,
          createdAt: DateTime.now(),
          review: _reviewController.text,
          userId: userId,
        ),
      );

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Review added successfully')),
      );

      // Close the modal
      Navigator.of(context).pop();
    } catch (error) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${error.toString()}')),
      );
    } finally {
      // Hide loading indicator
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 0.1,
              blurRadius: 2,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'WRITE A REVIEW',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Score:'),
                const SizedBox(width: 8),
                Row(
                  children: [
                    for (int i = 1; i <= 5; i++)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _rating = i;
                          });
                        },
                        child: Icon(
                          Icons.star,
                          color: i <= _rating
                              ? Colors.amber
                              : Colors.grey.shade400,
                        ),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _reviewController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Write a review',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: submitReview,
                  child: const Text('Post'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ReviewSummary extends StatelessWidget {
  final double averageRating;
  final int reviewCount;
  final Map<String, int> ratingDistribution;

  const ReviewSummary({
    super.key,
    required this.averageRating,
    required this.reviewCount,
    required this.ratingDistribution,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Average Rating Display
        Column(
          children: [
            Text(
              averageRating.toStringAsFixed(1),
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            RatingBarIndicator(
              rating: averageRating,
              itemBuilder: (context, index) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              itemCount: 5,
              itemSize: 24.0,
              direction: Axis.horizontal,
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Review Count
        Text(
          'based on $reviewCount reviews',
          style: const TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 16),
        // Rating Distribution Bars
        // Padding(padding: const EdgeInsets.symmetric(vertical: 8.0),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Column(
            children: ratingDistribution.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Row(
                  children: [
                    SizedBox(width: 80, child: Text(entry.key)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: LinearProgressIndicator(
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(4),
                        value: entry.value / reviewCount,
                        backgroundColor: Colors.grey.shade200,
                        color: _getColorForRating(entry.key),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text('${entry.value}'),
                  ],
                ),
              );
            }).toList(),
          ),
        )
      ],
    );
  }

  Color _getColorForRating(String rating) {
    switch (rating) {
      case 'Excellent':
        return Colors.green;
      case 'Good':
        return Colors.lightGreen;
      case 'Average':
        return Colors.yellow;
      case 'Below Average':
        return Colors.orange;
      case 'Poor':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
