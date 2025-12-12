// addresses_page.dart
import 'package:flutter/material.dart';
import 'package:shop/constants.dart';

class AddressesPage extends StatefulWidget {
  const AddressesPage({super.key});

  @override
  State<AddressesPage> createState() => _AddressesPageState();
}

class _AddressesPageState extends State<AddressesPage> {
  final List<Map<String, String>> _addresses = [
    {
      'label': 'Home',
      'details': 'Nablus Street, Building 12, Apartment 4',
    },
    {
      'label': 'Work',
      'details': 'Gaza City, Tech Hub Office, 3rd floor',
    },
  ];

  void _addAddress() {
    // Demo فقط، لاحقاً ممكن تعملي فورم
    setState(() {
      _addresses.add({
        'label': 'New address',
        'details': 'Tap here to edit later (demo)',
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My addresses'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addAddress,
        child: const Icon(Icons.add),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(defaultPadding),
        itemCount: _addresses.length,
        separatorBuilder: (_, __) =>
            const SizedBox(height: defaultPadding / 2),
        itemBuilder: (context, index) {
          final address = _addresses[index];
          return Dismissible(
            key: ValueKey(address['label']! + index.toString()),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              color: Colors.redAccent,
              child: const Icon(
                Icons.delete_outline,
                color: Colors.white,
              ),
            ),
            onDismissed: (_) {
              setState(() {
                _addresses.removeAt(index);
              });
            },
            child: Container(
              padding: const EdgeInsets.all(defaultPadding),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(defaultBorderRadious * 1.3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    color: primaryColor,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          address['label'] ?? 'Address',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          address['details'] ?? '',
                          style: const TextStyle(
                            fontSize: 13,
                            color: blackColor60,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
