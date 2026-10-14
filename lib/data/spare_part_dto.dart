class SparePartDto {
  final int id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;

  const SparePartDto({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
  });

  factory SparePartDto.fromJson(Map<String, dynamic> json) {
    return SparePartDto(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? 'Без названия',
      description: json['description'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      imageUrl: json['thumbnail'] as String? ?? '',
    );
  }
}
