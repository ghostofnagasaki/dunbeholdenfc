class Club {
  final String id;
  final String name;
  final String shortName;
  final String logoUrl;
  final bool isActive;

  Club({
    required this.id,
    required this.name,
    required this.shortName,
    required this.logoUrl,
    required this.isActive,
  });

  factory Club.fromMap(String id, Map<String, dynamic> map) {
    return Club(
      id: id,
      name: map['name'] ?? '',
      shortName: map['shortName'] ?? '',
      logoUrl: map['logoUrl'] ?? '',
      isActive: map['isActive'] ?? false,
    );
  }
} 