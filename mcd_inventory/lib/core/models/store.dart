class Store {
  final String id;
  final String name;
  final String location;
  final Map<String, dynamic> raw;

  Store({
    required this.id,
    required this.name,
    required this.location,
    required this.raw,
  });

  factory Store.fromRecord(dynamic record) {
    return Store(
      id: record.id,
      name: record.data['name'] ?? '',
      location: record.data['location'] ?? '',
      raw: record.data,
    );
  }
}
