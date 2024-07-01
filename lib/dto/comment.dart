class Comment {
  final String commentId;
  final String customerId;
  final String customerUsername;
  final String customerEmail;
  final String tourguideId;
  final int rating;
  final String comment;
  final String? commentImage;
  final String? customerImage;

  Comment({
    required this.commentId,
    required this.customerId,
    required this.customerUsername,
    required this.customerEmail,
    required this.tourguideId,
    required this.rating,
    required this.comment,
    this.commentImage,
    this.customerImage,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      commentId: json['comment_id'],
      customerId: json['customer_id'],
      customerUsername: json['customer_username'],
      customerEmail: json['customer_email'],
      tourguideId: json['tourguide_id'],
      rating: json['rating'],
      comment: json['comment'],
      commentImage: json['comment_image'],
      customerImage: json['customer_image'],
    );
  }
}
