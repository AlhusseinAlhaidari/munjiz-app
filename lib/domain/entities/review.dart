import 'package:equatable/equatable.dart';

enum ReviewType { projectReview, providerReview, clientReview }

class Review extends Equatable {
  final String id;
  final String projectId;
  final String reviewerId;
  final String revieweeId;
  final ReviewType type;
  final double rating;
  final String? title;
  final String? comment;
  final List<String> tags;
  final List<String> attachments;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isVerified;
  final ReviewResponse? response;
  final Map<String, dynamic> metadata;

  const Review({
    required this.id,
    required this.projectId,
    required this.reviewerId,
    required this.revieweeId,
    required this.type,
    required this.rating,
    this.title,
    this.comment,
    this.tags = const [],
    this.attachments = const [],
    required this.createdAt,
    required this.updatedAt,
    this.isVerified = false,
    this.response,
    this.metadata = const {},
  });

  bool get hasComment => comment != null && comment!.isNotEmpty;
  bool get hasResponse => response != null;
  bool get isPositive => rating >= 4.0;
  bool get isNegative => rating <= 2.0;

  Review copyWith({
    String? id,
    String? projectId,
    String? reviewerId,
    String? revieweeId,
    ReviewType? type,
    double? rating,
    String? title,
    String? comment,
    List<String>? tags,
    List<String>? attachments,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isVerified,
    ReviewResponse? response,
    Map<String, dynamic>? metadata,
  }) {
    return Review(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      reviewerId: reviewerId ?? this.reviewerId,
      revieweeId: revieweeId ?? this.revieweeId,
      type: type ?? this.type,
      rating: rating ?? this.rating,
      title: title ?? this.title,
      comment: comment ?? this.comment,
      tags: tags ?? this.tags,
      attachments: attachments ?? this.attachments,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isVerified: isVerified ?? this.isVerified,
      response: response ?? this.response,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
        id,
        projectId,
        reviewerId,
        revieweeId,
        type,
        rating,
        title,
        comment,
        tags,
        attachments,
        createdAt,
        updatedAt,
        isVerified,
        response,
        metadata,
      ];
}

class ReviewResponse extends Equatable {
  final String id;
  final String reviewId;
  final String responderId;
  final String comment;
  final DateTime createdAt;
  final Map<String, dynamic> metadata;

  const ReviewResponse({
    required this.id,
    required this.reviewId,
    required this.responderId,
    required this.comment,
    required this.createdAt,
    this.metadata = const {},
  });

  ReviewResponse copyWith({
    String? id,
    String? reviewId,
    String? responderId,
    String? comment,
    DateTime? createdAt,
    Map<String, dynamic>? metadata,
  }) {
    return ReviewResponse(
      id: id ?? this.id,
      reviewId: reviewId ?? this.reviewId,
      responderId: responderId ?? this.responderId,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
        id,
        reviewId,
        responderId,
        comment,
        createdAt,
        metadata,
      ];
}

class ReviewSummary extends Equatable {
  final String entityId;
  final ReviewType type;
  final double averageRating;
  final int totalReviews;
  final Map<int, int> ratingDistribution; // rating -> count
  final List<String> topTags;
  final DateTime lastUpdated;

  const ReviewSummary({
    required this.entityId,
    required this.type,
    required this.averageRating,
    required this.totalReviews,
    required this.ratingDistribution,
    this.topTags = const [],
    required this.lastUpdated,
  });

  double get oneStarPercentage => _getPercentage(1);
  double get twoStarPercentage => _getPercentage(2);
  double get threeStarPercentage => _getPercentage(3);
  double get fourStarPercentage => _getPercentage(4);
  double get fiveStarPercentage => _getPercentage(5);

  double _getPercentage(int rating) {
    if (totalReviews == 0) return 0.0;
    return ((ratingDistribution[rating] ?? 0) / totalReviews) * 100;
  }

  ReviewSummary copyWith({
    String? entityId,
    ReviewType? type,
    double? averageRating,
    int? totalReviews,
    Map<int, int>? ratingDistribution,
    List<String>? topTags,
    DateTime? lastUpdated,
  }) {
    return ReviewSummary(
      entityId: entityId ?? this.entityId,
      type: type ?? this.type,
      averageRating: averageRating ?? this.averageRating,
      totalReviews: totalReviews ?? this.totalReviews,
      ratingDistribution: ratingDistribution ?? this.ratingDistribution,
      topTags: topTags ?? this.topTags,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  List<Object?> get props => [
        entityId,
        type,
        averageRating,
        totalReviews,
        ratingDistribution,
        topTags,
        lastUpdated,
      ];
}
