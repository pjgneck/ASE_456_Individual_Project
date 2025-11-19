import '../core/pocketbase.dart';
import '../core/models/truckItem.dart';

class TruckOrderItemService {
  final pb = PBClient.client;

  Future<List<TruckOrderItem>> getOrderItems(String truckId) async {
    try {
      final records = await pb.collection('truck_item_order').getFullList(
        filter: 'truck = "$truckId"',
      );

      return await Future.wait(records.map((r) => TruckOrderItem.fromRecord(r)));
    } catch (e) {
      print("Truck order item fetch error: $e");
      return [];
    }
  }

  Future<bool> createOrderItem(
      String truckId, String itemId, int quantity) async {
    try {
      await pb.collection('truck_item_order').create(body: {
        "truck": truckId,
        "item": itemId,
        "quantity": quantity,
        "delivered": false,
      });
      return true;
    } catch (e) {
      print("Truck order item create error: $e");
      return false;
    }
  }

  Future<bool> updateDelivered(String id, bool delivered) async {
    try {
      await pb.collection('truck_item_order').update(id, body: {
        "delivered": delivered,
      });
      return true;
    } catch (e) {
      print("Update delivered error: $e");
      return false;
    }
  }
}
