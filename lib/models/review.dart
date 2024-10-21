// models/review.dart
class Review {
  String id;
  String storeId;
  String userId;
  String userName;
  int rating;
  DateTime createdAt;
  String review;

  Review({
    this.id = "",
    required this.storeId,
    this.userId = "",
    this.userName = "",
    required this.rating,
    required this.createdAt,
    required this.review,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      storeId: json['store_id'],
      userId: json['user_id'],
      userName: json['user_name'],
      rating: json['rating'],
      createdAt: DateTime.parse(json['created_at']),
      review: json['review'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'user_id': userId,
      'user_name': userName,
      'rating': rating,
      'created_at': createdAt.toIso8601String(),
      'review': review,
    };
  }
}
