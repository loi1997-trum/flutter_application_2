class TourModel {
  final String id;
  final String title;
  final String location;
  final double price;
  final String duration;
  final String image;
  final double rating;
  final String category;
  final String description;

  TourModel({
    required this.id,
    required this.title,
    required this.location,
    required this.price,
    required this.duration,
    required this.image,
    required this.rating,
    required this.category,
    required this.description,
  });

  factory TourModel.fromJson(Map<String, dynamic> json) => TourModel(
        id: json['_id'] ?? '',
        title: json['title'] ?? '',
        location: json['location'] ?? '',
        price: (json['price'] ?? 0).toDouble(),
        duration: json['duration'] ?? '',
        image: json['image'] ?? '',
        rating: (json['rating'] ?? 0).toDouble(),
        category: json['category'] ?? '',
        description: json['description'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'location': location,
        'price': price,
        'duration': duration,
        'category': category,
        'description': description,
      };
}