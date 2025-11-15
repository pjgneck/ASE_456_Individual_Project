import '../core/pocketbase.dart';
import '../core/models/item.dart';

class ItemService {
  final pb = PBClient.client;

  Future<List<Item>> getItems() async {
    try {
      final result = await pb.collection('items').getFullList();
      return result.map((r) => Item.fromRecord(r)).toList();
    } catch (e) {
      print("Item fetch error: $e");
      return [];
    }
  }
}
