class TripModel {
  final String id;
  final String title;
  final String location;
  final String status;
  final String notes;
  final String guide;
  final double price;
  final String startDate;
  final String endDate;

  TripModel({
    required this.id,
    required this.title,
    required this.location,
    required this.status,
    required this.notes,
    required this.guide,
    required this.price,
    required this.startDate,
    required this.endDate,
  });

  factory TripModel.fromJson(Map<String, dynamic> json) => TripModel(
        id: json['_id'] ?? '',
        title: json['title'] ?? '',
        location: json['location'] ?? '',
        status: json['status'] ?? 'upcoming',
        notes: json['notes'] ?? '',
        guide: json['guide'] ?? '',
        price: (json['price'] ?? 0).toDouble(),
        startDate: json['startDate'] ?? '',
        endDate: json['endDate'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'location': location,
        'status': status,
        'notes': notes,
        'guide': guide,
        'price': price,
        'startDate': startDate,
        'endDate': endDate,
      };
}