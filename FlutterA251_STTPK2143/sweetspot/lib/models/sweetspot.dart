class SweetSpot {
  final int? id;
  final String title;
  final String imagePath;
  final double lat;
  final double lng;
  final String createdAt; // store as ISO string for simplicity
  final String description;

  SweetSpot({
    this.id,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.lat,
    required this.lng,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imagePath': imagePath,
      'lat': lat,
      'lng': lng,
      'createdAt': createdAt,
    };
  }

  factory SweetSpot.fromMap(Map<String, dynamic> map) {
    return SweetSpot(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      imagePath: map['imagePath'],
      lat: map['lat'],
      lng: map['lng'],
      createdAt: map['createdAt'],
    );
  }
}
