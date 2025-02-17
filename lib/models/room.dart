class Room {
  final String id;
  final String name;
  final String description;
  final double price;
  final String image;
  final List<String> services;

  Room({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.services,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'No Name',
      description: json['description'] ?? 'No Description',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      image: json['image'] ?? 'assets/images/default_room.jpg',
      services: (json['services'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}
