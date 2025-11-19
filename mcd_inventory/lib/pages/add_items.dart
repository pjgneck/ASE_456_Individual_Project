import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_state.dart';
import '../services/inventory_service.dart';
import '../services/item_service.dart';
import '../core/models/item.dart';
import '../core/models/store.dart';

class AddInventoryPage extends StatefulWidget {
  const AddInventoryPage({super.key});

  @override
  State<AddInventoryPage> createState() => _AddInventoryPageState();
}

class _AddInventoryPageState extends State<AddInventoryPage> {
  final InventoryService invService = InventoryService();
  final ItemService itemService = ItemService();

  List<Item> items = [];
  Map<String, TextEditingController> qtyControllers = {};
  Map<String, int> currentQty = {};
  Map<String, String> inventoryRecordIds = {};
  Store? selectedStore;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    final appState = context.read<AppState>();
    selectedStore = appState.store;
    loadItems();
  }

  Future<void> loadItems() async {
    if (selectedStore == null) {
      setState(() => loading = false);
      return;
    }

    setState(() => loading = true);

    items = await itemService.getItems();

    final inventories = await invService.getInventoryForStore(selectedStore!.id);
    currentQty = {};
    inventoryRecordIds = {};
    for (var inv in inventories) {
      currentQty[inv.item.id] = inv.quantity;
      inventoryRecordIds[inv.item.id] = inv.id;
    }

    for (var item in items) {
      qtyControllers[item.id] = TextEditingController();
    }

    setState(() => loading = false);
  }

  void saveAll() async {
    if (selectedStore == null) return;

    for (var item in items) {
      final qtyText = qtyControllers[item.id]?.text ?? '';
      final qtyToAdd = int.tryParse(qtyText);

      if (qtyToAdd != null && qtyToAdd > 0) {
        final existing = currentQty[item.id] ?? 0;
        final newQty = existing + qtyToAdd;

        if (inventoryRecordIds.containsKey(item.id)) {
          await invService.updateQuantity(inventoryRecordIds[item.id]!, newQty);
        } else {
          final success = await invService.createInventory(
            selectedStore!.id,
            item.id,
            newQty,
          );

          if (success) {
            final inventories =
                await invService.getInventoryForStore(selectedStore!.id);
            inventoryRecordIds.clear();
            currentQty.clear();
            for (var inv in inventories) {
              inventoryRecordIds[inv.item.id] = inv.id;
              currentQty[inv.item.id] = inv.quantity;
            }
          }
        }
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Inventory updated successfully!")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    // Group items by category
    final grouped = {
      "Frozen":
          items.where((i) => i.category.toLowerCase() == "frozen").toList(),
      "Refrigerated":
          items.where((i) => i.category.toLowerCase() == "refrigerated").toList(),
      "Dry": items.where((i) => i.category.toLowerCase() == "dry").toList(),
    };

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text(
          "Mass Add Inventory",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        backgroundColor: const Color(0xFF2575FC),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.save, size: 28),
            onPressed: saveAll,
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                if (appState.isFranchise)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: DropdownButtonFormField<Store>(
                      value: selectedStore,
                      decoration: InputDecoration(
                        labelText: "Select Store",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      items: appState.stores
                          .map(
                            (store) => DropdownMenuItem(
                              value: store,
                              child: Text("${store.name} (${store.location})"),
                            ),
                          )
                          .toList(),
                      onChanged: (store) {
                        setState(() {
                          selectedStore = store;
                          loading = true;
                        });
                        loadItems();
                      },
                    ),
                  ),

                // MAIN ITEM CONTENT
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (var category
                            in ["Frozen", "Refrigerated", "Dry"]) ...[
                          if (grouped[category]!.isNotEmpty) ...[
                            const SizedBox(height: 20),

                            // CATEGORY HEADER (Centered + Line)
                            Center(
                              child: Column(
                                children: [
                                  Text(
                                    category,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    height: 2,
                                    width: 160,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 16),

                            // TWO ITEMS PER ROW (same card layout as before)
                            Column(
                              children: [
                                for (int i = 0;
                                    i < grouped[category]!.length;
                                    i += 2)
                                  Row(
                                    children: [
                                      Expanded(
                                        child: buildItemCard(
                                            grouped[category]![i]),
                                      ),
                                      const SizedBox(width: 12),
                                      if (i + 1 <
                                          grouped[category]!.length)
                                        Expanded(
                                          child: buildItemCard(
                                              grouped[category]![i + 1]),
                                        )
                                      else
                                        const Expanded(child: SizedBox()),
                                    ],
                                  ),
                              ],
                            ),
                          ],
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: saveAll,
        label: const Text(
          "Save All",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        icon: const Icon(Icons.save),
        backgroundColor: const Color(0xFF2575FC),
      ),
    );
  }

  // ---------------------------------------------------------
  // ITEM CARD (unchanged styling, matches old UI, fits mgmt needs)
  // ---------------------------------------------------------
  Widget buildItemCard(Item item) {
    final existing = currentQty[item.id] ?? 0;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),

            Text(
              item.unit,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 4),

            Text(
              "Current Qty: $existing",
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: qtyControllers[item.id],
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Add",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
