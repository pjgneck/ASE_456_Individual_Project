import 'item.dart';
import '../../services/item_service.dart';

class TruckOrderItem {
  final String id;
  final String truckId;
  final Item item;
  final int quantity;
  final bool delivered;
  final Map<String, dynamic> raw;

  TruckOrderItem({
    required this.id,
    required this.truckId,
    required this.item,
    required this.quantity,
    required this.delivered,
    required this.raw,
  });

  static Future<TruckOrderItem> fromRecord(dynamic record) async {
    final itemId = record.data['item'];

    // Pull full item details
    final items = await ItemService().getItems();
    final matchedItem = items.firstWhere(
      (i) => i.id == itemId,
      orElse: () => Item(id: itemId, name: "", unit: "", perishable: "", category: ""),
    );

    return TruckOrderItem(
      id: record.id,
      truckId: record.data['truck'],
      item: matchedItem,
      quantity: record.data['quantity'] ?? 0,
      delivered: record.data['delivered'] ?? false,
      raw: record.data,
    );
  }
}
