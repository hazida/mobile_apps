import 'package:flutter/material.dart';
import 'cart_service.dart'; // Import to use the CartItem model

class CartItemCard extends StatelessWidget {
  final CartItem item;
  final VoidCallback onAdd;
  final VoidCallback onSubtract;
  final VoidCallback onRemove;

  const CartItemCard({
    super.key,
    required this.item,
    required this.onAdd,
    required this.onSubtract,
    required this.onRemove,
  });

  Widget _buildQuantityButton(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.black, size: 18),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible( 
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // --- UPDATED: IMAGE CONTAINER FOR FIRESTORE ---
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: item.imagePath.startsWith('http')
                        ? Image.network(
                      item.imagePath,
                      fit: BoxFit.cover,
                      // Shows a loading spinner while the image downloads from Firebase
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                                : null,
                            strokeWidth: 2,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(child: Icon(Icons.broken_image, color: Colors.grey));
                      },
                    )
                        : Image.asset(
                      item.imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(child: Icon(Icons.fastfood, color: Colors.grey));
                      },
                    ),
                  ),
                ),
                // --------------------------------
                const SizedBox(width: 15),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        overflow: TextOverflow.ellipsis, 
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "RM ${item.price.toStringAsFixed(2)}",
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Row(
            children: [
              _buildQuantityButton(Icons.remove, Colors.grey.shade200, onSubtract),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0), 
                child: Text(
                  item.quantity.toString(),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              
              _buildQuantityButton(Icons.add, const Color(0xFFFFCC33), onAdd),
              
              const SizedBox(width: 10), 
              
              GestureDetector(
                onTap: onRemove,
                child: const Icon(Icons.close, color: Colors.grey, size: 28),
              ),
            ],
          ),
        ],
      ),
    );
  }
}