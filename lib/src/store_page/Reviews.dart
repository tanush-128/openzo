import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:openzo_frontend/models/Review.dart';
import 'package:intl/intl.dart';
import 'package:openzo_frontend/providers/user_provider.dart';
import 'package:openzo_frontend/utils/capitalize.dart';
import 'package:provider/provider.dart';

class ReviewsList extends StatefulWidget {
  final String storeId;
  const ReviewsList({
    super.key,
    required this.storeId,
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

          return Column(
            children: reviews
                .map((review) =>
                    ReviewTile(review: review, byUser: review.userId == userId))
                .toList(),
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
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 0.1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
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
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        for (int i = 0; i < review.rating; i++)
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 20,
                          ),
                        for (int i = 0; i < 5 - review.rating; i++)
                          Icon(
                            Icons.star,
                            color: Colors.grey.shade400,
                            size: 20,
                          ),
                      ],
                    ),
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
              // const SizedBox(height: 8),
              const SizedBox(height: 8),
              Text(
                capitalize(review.review),
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
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

class AddReview extends StatefulWidget {
  final String storeId;
  const AddReview({
    super.key,
    required this.storeId,
  });

  @override
  State<AddReview> createState() => _AddReviewState();
}

class _AddReviewState extends State<AddReview> {
  final TextEditingController _reviewController = TextEditingController();
  int _rating = 0;
  String userId = "";

  @override
  void initState() {
    userId = Provider.of<UserProvider>(context, listen: false).user.id;
    super.initState();
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

      // Clear the form
      _reviewController.clear();
      setState(() {
        _rating = 0;
      });
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
          height: 120,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.amber.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (int i = 0; i < _rating; i++)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _rating = i + 1;
                          });
                        },
                        child: const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 24,
                        ),
                      ),
                    for (int i = 0; i < 5 - _rating; i++)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _rating = _rating + i + 1;
                          });
                        },
                        child: Icon(
                          Icons.star,
                          color: Colors.grey.shade400,
                          size: 24,
                        ),
                      ),
                  ],
                ),
              ),
              Row(
                children: [
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _reviewController,
                      decoration: const InputDecoration(
                        hintText: 'Write a review',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: submitReview,
                    child: const Text('Submit'),
                  ),
                ],
                // print(value);
              ),
            ],
          )),
    );
  }
}
