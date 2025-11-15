class Inventory {
  final String id;
  final String storeId;
  final String itemId;
  final int quantity;
  final Map<String, dynamic> raw;

  Inventory({
    required this.id,
    required this.storeId,
    required this.itemId,
    required this.quantity,
    required this.raw,
  });

  factory Inventory.fromRecord(dynamic record) {
    return Inventory(
      id: record.id,
      storeId: record.data['store'],
      itemId: record.data['item'],
      quantity: record.data['quantity'] ?? 0,
      raw: record.data,
    );
  }
}
