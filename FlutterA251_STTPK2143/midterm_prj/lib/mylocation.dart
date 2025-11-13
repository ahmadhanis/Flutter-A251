class MyLocation {
  int? id;
  String? name;
  String? state;
  String? category;
  String? description;
  String? imageUrl;
  double? latitude;
  double? longitude;
  String? contact;
  double? rating;

  MyLocation({
    this.id,
    this.name,
    this.state,
    this.category,
    this.description,
    this.imageUrl,
    this.latitude,
    this.longitude,
    this.contact,
    this.rating,
  });

  MyLocation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    state = json['state'];
    category = json['category'];
    description = json['description'];
    imageUrl = json['image_url'];
    latitude = json['latitude'];
    longitude = double.parse(json['longitude'].toString());
    contact = json['contact'];
    rating = double.parse(json['rating'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['state'] = state;
    data['category'] = category;
    data['description'] = description;
    data['image_url'] = imageUrl;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['contact'] = contact;
    data['rating'] = rating;
    return data;
  }
}
