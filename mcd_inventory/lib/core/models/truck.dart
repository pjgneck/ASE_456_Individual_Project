class Truck {
  final String id;
  final String storeId;
  final DateTime deliveryDate;
  final Map<String, dynamic> raw;

  Truck({
    required this.id,
    required this.storeId,
    required this.deliveryDate,
    required this.raw,
  });

  factory Truck.fromRecord(dynamic record) {
    return Truck(
      id: record.id,
      storeId: record.data['store'],
      deliveryDate: DateTime.parse(record.data['delivery_date']),
      raw: record.data,
    );
  }
}
