class ReviewModel {
  final String id;
  final String author;
  final double rating;
  final String comment;
  final String date;

  const ReviewModel({
    required this.id,
    required this.author,
    required this.rating,
    required this.comment,
    required this.date,
  });

  ReviewModel copyWith({
    String? id,
    String? author,
    double? rating,
    String? comment,
    String? date,
  }) {
    return ReviewModel(
      id: id ?? this.id,
      author: author ?? this.author,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'author': author,
      'rating': rating,
      'comment': comment,
      'date': date,
    };
  }

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      id: map['id'] ?? '',
      author: map['author'] ?? '',
      rating: (map['rating'] as num?)?.toDouble() ?? 5.0,
      comment: map['comment'] ?? '',
      date: map['date'] ?? '',
    );
  }
}
