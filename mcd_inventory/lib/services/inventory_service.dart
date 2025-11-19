import '../core/pocketbase.dart';
import '../core/models/inventory.dart';

class InventoryService {
  final pb = PBClient.client;

  Future<List<Inventory>> getInventoryForStore(String storeId) async {
    final records = await pb
        .collection('inventory')
        .getFullList(filter: 'store = "$storeId"');

    // Map all records to Inventory objects with full Item details
    final inventoryList = await Future.wait(
      records.map((r) => Inventory.fromRecord(r)),
    );

    return inventoryList;
  }

  Future<bool> updateQuantity(String id, int quantity) async {
    try {
      await pb.collection('inventory').update(id, body: {"quantity": quantity});
      return true;
    } catch (e) {
      print("Update quantity error: $e");
      return false;
    }
  }

  Future<bool> createInventory(
    String storeId,
    String itemId,
    int quantity,
  ) async {
    try {
      await pb
          .collection('inventory')
          .create(
            body: {"store": storeId, "item": itemId, "quantity": quantity},
          );
      return true;
    } catch (e) {
      print("Inventory create error: $e");
      return false;
    }
  }
}
