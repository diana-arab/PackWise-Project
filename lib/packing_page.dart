import 'package:flutter/material.dart';

import 'packing_item.dart';

class PackingPage extends StatefulWidget {
  const PackingPage({super.key});

  @override
  State<PackingPage> createState() => _PackingPageState();
}

class _PackingPageState extends State<PackingPage> {
  final TextEditingController itemController = TextEditingController();

  String tripType = 'Vacation';
  int numberOfDays = 5;

  List<PackingItem> items = [
    PackingItem(name: 'Clothes'),
    PackingItem(name: 'Shoes'),
    PackingItem(name: 'Toothbrush'),
    PackingItem(name: 'Phone Charger'),
    PackingItem(name: 'Passport'),
    PackingItem(name: 'Skincare'),
    PackingItem(name: 'Headphones'),
    PackingItem(name: 'Travel Documents'),
  ];

  int get packedCount {
    return items.where((item) => item.isPacked).length;
  }

  double get progress {
    if (items.isEmpty) return 0;
    return packedCount / items.length;
  }

  void addItem() {
    String newItem = itemController.text.trim();

    if (newItem.isEmpty) return;

    bool exists = items.any(
      (item) => item.name.toLowerCase() == newItem.toLowerCase(),
    );

    if (exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This item is already in your list!')),
      );
      return;
    }

    setState(() {
      items.add(PackingItem(name: newItem));
      itemController.clear();
    });
  }

  void deleteItem(int index) {
    setState(() {
      items.removeAt(index);
    });
  }

  void resetItems() {
    setState(() {
      for (var item in items) {
        item.isPacked = false;
      }
    });
  }

  @override
  void dispose() {
    itemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PackWise',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF009688),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ready for your trip?',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF263238),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Organize your luggage and never forget an important item.',
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 28),

            const Text(
              'Trip Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Trip Type',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 8),

                  DropdownButtonFormField<String>(
                    value: tripType,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: ['Vacation', 'Business', 'Weekend Trip', 'Adventure']
                        .map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          );
                        })
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        tripType = value!;
                      });
                    },
                  ),

                  const SizedBox(height: 18),

                  const Text(
                    'Number of Days',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 8),

                  TextFormField(
                    key: ValueKey(numberOfDays),
                    initialValue: numberOfDays.toString(),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      suffixText: 'Days',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (value) {
                      int? days = int.tryParse(value);
                      if (days != null && days > 0) {
                        setState(() {
                          numberOfDays = days;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            const Text(
              'Your Packing Progress',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$packedCount out of ${items.length} items packed',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 16),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 12,
                      backgroundColor: Colors.grey.shade200,
                      color: const Color(0xFF009688),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    '${(progress * 100).round()}% completed',
                    style: const TextStyle(
                      color: Color(0xFF009688),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'My Packing List',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                TextButton(
                  onPressed: resetItems,
                  child: const Text(
                    'Reset',
                    style: TextStyle(color: Color(0xFF009688)),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            ...List.generate(items.length, (index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),

                child: ListTile(
                  leading: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.grey),
                    onPressed: () => deleteItem(index),
                  ),

                  title: Text(
                    items[index].name,
                    style: TextStyle(
                      fontSize: 16,
                      decoration: items[index].isPacked
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      color: items[index].isPacked
                          ? Colors.grey
                          : Colors.black87,
                    ),
                  ),

                  trailing: Checkbox(
                    activeColor: const Color(0xFF009688),
                    value: items[index].isPacked,
                    onChanged: (value) {
                      setState(() {
                        items[index].isPacked = value!;
                      });
                    },
                  ),
                ),
              );
            }),

            const SizedBox(height: 18),

            const Text(
              'Add New Item',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: itemController,
                    decoration: InputDecoration(
                      hintText: 'Enter an item...',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onSubmitted: (_) => addItem(),
                  ),
                ),

                const SizedBox(width: 10),

                SizedBox(
                  height: 52,
                  width: 55,
                  child: ElevatedButton(
                    onPressed: addItem,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF009688),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: const Icon(Icons.add),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            const Center(
              child: Text(
                'Pack smart. Travel happy!',
                style: TextStyle(
                  color: Color(0xFF009688),
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
