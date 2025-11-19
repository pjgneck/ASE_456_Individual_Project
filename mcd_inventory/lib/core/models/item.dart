class Item {
  final String id;
  final String name;
  final String perishable;
  final String unit;
  final String category; 

  Item({
    required this.id,
    required this.name,
    required this.perishable,
    required this.unit,
    required this.category
  });

  factory Item.fromRecord(dynamic record) {
    return Item(
      id: record.id,
      name: record.data['name'] ?? '',
      perishable: record.data['perishable'] ?? '',
      unit: record.data['unit'] ?? '',
      category: record.data['category'] ?? '',
    );
  }
}
