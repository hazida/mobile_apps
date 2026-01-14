import 'package:flutter/material.dart';
import 'cart/cart_service.dart';

class PopularFoodCard extends StatelessWidget {
  final Map<String, dynamic> data; // Changed from FoodItem to Map
  final String docId; // Added to identify the item in Firestore

  const PopularFoodCard({
    super.key,
    required this.data,
    required this.docId,
  });

  @override
  Widget build(BuildContext context) {
    // Extract variables from the Firestore Map safely
    final String name = data['name'] ?? 'Unknown Item';
    final String price = data['price']?.toString() ?? '0.00';
    final String imageUrl = data['imageUrl'] ?? '';
    final bool isAvailable = data['isAvailable'] ?? true;
    final String category = data['category'] ?? 'General';
    final bool isPopular = data['isPopular'] ?? false;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              // 1. Network Image Container
              Container(
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                  image: DecorationImage(
                    // UPDATED: Use NetworkImage for Firestore URLs
                    image: (imageUrl.isNotEmpty)
                        ? NetworkImage(imageUrl)
                        : const AssetImage('assets/placeholder.png') as ImageProvider,
                    fit: BoxFit.cover,
                    colorFilter: isAvailable
                        ? null
                        : ColorFilter.mode(
                        Colors.grey.withOpacity(0.7), BlendMode.saturation),
                  ),
                ),
              ),

              // 2. Badges
              if (!isAvailable)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15)),
                    ),
                    child: const Text('Out of Stock',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10)),
                  ),
                )
              else if (isPopular)
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: const BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15)),
                    ),
                    child: const Text('Popular',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10)),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(category,
                    style: TextStyle(color: Colors.grey[600], fontSize: 11)),
                const SizedBox(height: 5),
                Text('RM $price',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFFE67E22))),
                const SizedBox(height: 8),

                // 3. Logic for Add Button
                SizedBox(
                  width: double.infinity,
                  height: 35,
                  child: ElevatedButton(
                    onPressed: isAvailable
                        ? () {
                      // This is where the magic happens
                      CartService.instance.addItemFromData(data, docId);

                      // ADD THIS LINE TO SEE IT IN THE CONSOLE:
                      print("DEBUG: Successfully added ${data['name']} to CartService!");

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("${data['name']} added to cart!"),
                          backgroundColor: Colors.green,
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFCC33),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      disabledBackgroundColor: Colors.grey[300],
                    ),
                    child: Text(
                      isAvailable ? 'Add to Cart' : 'Unavailable',
                      style: TextStyle(
                          color: isAvailable ? Colors.black : Colors.grey[600],
                          fontSize: 11,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}