class Item {
  final String id;
  final String name;
  final String sku;
  final Map<String, dynamic> raw;

  Item({
    required this.id,
    required this.name,
    required this.sku,
    required this.raw,
  });

  factory Item.fromRecord(dynamic record) {
    return Item(
      id: record.id,
      name: record.data['name'] ?? '',
      sku: record.data['sku'] ?? '',
      raw: record.data,
    );
  }
}
