import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_state.dart';
import '../../services/inventory_service.dart';
import '../../core/models/inventory.dart';
import 'add_items.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final invService = InventoryService();
  List<Inventory> inventory = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadInventory();
  }

  void loadInventory() async {
    final storeId = context.read<AppState>().store?.id;
    if (storeId == null) return;

    setState(() => loading = true);
    inventory = await invService.getInventoryForStore(storeId);
    setState(() => loading = false);
  }

  void updateQty(Inventory item, int newQty) async {
    if (newQty < 0) return;
    await invService.updateQuantity(item.id, newQty);
    loadInventory();
  }

  @override
  Widget build(BuildContext context) {
    final storeName = context.watch<AppState>().store?.name ?? "Store";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2575FC),
        title: Text("$storeName Inventory"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: "Mass Add Inventory",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AddInventoryPage(),
                ),
              ).then((_) => loadInventory());
            },
          )
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : inventory.isEmpty
              ? const Center(
                  child: Text(
                    "No items in inventory",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: inventory.length,
                  itemBuilder: (context, index) {
                    final item = inventory[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: const Color(0xFF6A11CB),
                              child: Text(
                                item.itemId.substring(0, 1).toUpperCase(),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Item ${item.itemId}",
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Qty: ${item.quantity}",
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  color: const Color(0xFF2575FC),
                                  onPressed: () =>
                                      updateQty(item, item.quantity - 1),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  color: const Color(0xFF2575FC),
                                  onPressed: () =>
                                      updateQty(item, item.quantity + 1),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
