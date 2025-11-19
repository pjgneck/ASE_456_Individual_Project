import 'item.dart';
import '../../services/item_service.dart';

class Inventory {
  final String id;
  final String storeId;
  final Item item;
  final int quantity;
  final Map<String, dynamic> raw;

  Inventory({
    required this.id,
    required this.storeId,
    required this.item,
    required this.quantity,
    required this.raw,
  });

  // Make fromRecord async to fetch full Item details
  static Future<Inventory> fromRecord(dynamic record) async {
    final itemId = record.data['item'];

    // Fetch the full item using ItemService
    final items = await ItemService().getItems();
    final matchedItem =
        items.firstWhere((i) => i.id == itemId, orElse: () => Item(
          id: itemId,
          name: '',
          perishable: '',
          unit: '',
          category: ''
        ));


    return Inventory(
      id: record.id,
      storeId: record.data['store'],
      item: matchedItem,
      quantity: record.data['quantity'] ?? 0,
      raw: record.data,
    );
  }
}
