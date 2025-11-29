import 'package:flutter/material.dart';

class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // أمثلة للعروض مع صور صالحة للاستخدام في Flutter
    final offers = [
      {
        "id": "1",
        "name": "Summer Sale",
        "desc": "Up to 50% off on summer collection!",
        "img": "https://cdn-icons-png.flaticon.com/512/3081/3081967.png"
      },
      {
        "id": "2",
        "name": "Buy 1 Get 1",
        "desc": "Buy 1 shirt and get another free!",
        "img": "https://cdn-icons-png.flaticon.com/512/3081/3081967.png"
      },
      {
        "id": "3",
        "name": "Free Shipping",
        "desc": "Free shipping on orders over ₪100",
        "img": "https://cdn-icons-png.flaticon.com/512/3081/3081967.png"
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Offers'),
        backgroundColor: const Color(0xFF0B3B8C),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: offers.length,
        itemBuilder: (context, index) {
          final offer = offers[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    offer['img']!,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        offer['name']!,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        offer['desc']!,
                        style: const TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0B3B8C)),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Offer '${offer['name']}' selected!")),
                          );
                        },
                        child: const Text("Grab Offer"),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
