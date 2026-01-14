import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../order/order_service.dart';

// --- MODELS ---
// These are defined at the top for easy access throughout the file

class FoodOrder {
  final String id;
  final String queueNumber;
  final String userId;
  final List<CartItem> items;
  final double totalAmount;
  final DateTime timestamp;
  final String type;
  final OrderStatus status;

  FoodOrder({
    required this.id,
    required this.queueNumber,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.timestamp,
    required this.type,
    required this.status,
  });

  static OrderStatus statusFromString(String status) {
    switch (status) {
      case 'Preparing': return OrderStatus.preparing;
      case 'Ready': return OrderStatus.ready;
      case 'Completed': return OrderStatus.completed;
      case 'Declined': return OrderStatus.declined;
      default: return OrderStatus.preparing;
    }
  }
}

class CartItem {
  final String name;
  final double price;
  final int quantity;
  final String imagePath;

  CartItem({
    required this.name,
    required this.price,
    required this.quantity,
    required this.imagePath,
  });
}

// --- MAIN SCREEN ---

class NewOrdersScreen extends StatefulWidget {
  final Function(int)? onSwitchTab;
  const NewOrdersScreen({super.key, this.onSwitchTab});

  @override
  State<NewOrdersScreen> createState() => _NewOrdersScreenState();
}

class _NewOrdersScreenState extends State<NewOrdersScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // --- AUTOMATION LOGIC ---

  Future<void> _sendAutoNotification(FoodOrder order, OrderStatus status) async {
    String title = "";
    String message = "";

    switch (status) {
      case OrderStatus.preparing:
        title = "Order Confirmed ✅";
        message = "Order #${order.queueNumber} (ID: ${order.id}) is confirmed.";
        break;
      case OrderStatus.declined:
        title = "Order Declined ❌";
        message = "Please come to counter for refund (ID: ${order.id}).";
        break;
      case OrderStatus.ready:
        title = "Order Being Prepared 👨‍🍳";
        message = "Your order #${order.queueNumber} is currently being prepared.";
        break;
      case OrderStatus.completed:
        title = "Order Ready! 🍳";
        message = "Order #${order.queueNumber} is ready for pickup!";
        break;
      default:
        title = "Order Update";
        message = "Your order status has changed.";
    }

    // Send notification to the notifications collection
    // The user's notification screen will pick this up automatically via userId
    await FirebaseFirestore.instance.collection('notifications').add({
      'userId': order.userId,
      'title': title,
      'message': message,
      'queueNumber': order.queueNumber,
      'orderId': order.id,
      'timestamp': FieldValue.serverTimestamp(),
      'isRead': false,
    });
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return "$hour:$minute $period";
  }

  // --- UI BUILDERS ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9EBDD),
      body: Column(
        children: [
          _buildInnerHeader(),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildStreamList(OrderService.instance.newOrdersStream, OrderStatus.preparing, "Accept", Colors.green),
                _buildStreamList(OrderService.instance.preparingOrdersStream, OrderStatus.ready, "Mark Ready", Colors.orange),
                _buildStreamList(OrderService.instance.readyOrdersStream, OrderStatus.completed, "Complete", Colors.blue),
                _buildStreamList(OrderService.instance.historyOrdersStream, null, "Done", Colors.grey, isHistory: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreamList(Stream<QuerySnapshot> stream, OrderStatus? nextStatus, String btnText, Color btnColor, {bool isHistory = false}) {
    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) return const Center(child: Text("Error loading data"));
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Colors.orange));
        }

        final docs = snapshot.data?.docs ?? [];
        if (docs.isEmpty) {
          return const Center(child: Text("No orders found.", style: TextStyle(color: Colors.grey)));
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            var data = docs[index].data() as Map<String, dynamic>;

            final order = FoodOrder(
              id: data['orderId'] ?? 'N/A',
              userId: data['userId'] ?? '',
              queueNumber: data['queueNumber']?.toString() ?? '000',
              items: (data['items'] as List).map((item) => CartItem(
                name: item['name'],
                price: (item['price'] as num).toDouble(),
                quantity: item['quantity'],
                imagePath: '',
              )).toList(),
              totalAmount: (data['totalAmount'] as num).toDouble(),
              timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
              type: data['orderType'] ?? 'Dine In',
              status: FoodOrder.statusFromString(data['status'] ?? 'Preparing'),
            );

            return _buildOrderCard(order, btnText, nextStatus, btnColor, isHistory);
          },
        );
      },
    );
  }

  Widget _buildOrderCard(FoodOrder order, String btnText, OrderStatus? nextStatus, Color btnColor, bool isHistory) {
    final String timeString = _formatTime(order.timestamp);

    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(color: const Color(0xFFE67E22), borderRadius: BorderRadius.circular(12)),
                child: Text(order.queueNumber, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
              ),
              Text(order.type.toUpperCase(), style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(order.id, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
                  const SizedBox(height: 5),
                  Row(children: [
                    const Icon(Icons.access_time, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(timeString, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ]),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: Text(order.status.name.toUpperCase(), style: const TextStyle(color: Colors.orange, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const Divider(height: 30),
          ...order.items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text("${item.quantity}x ${item.name}", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          )),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total: RM ${order.totalAmount.toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ElevatedButton(
                onPressed: () => _showOrderDetails(context, order),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[100], foregroundColor: Colors.black87),
                child: const Text("View"),
              ),
            ],
          ),
          if (!isHistory && nextStatus != null) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await OrderService.instance.updateOrderStatus(order.id, nextStatus);
                      await _sendAutoNotification(order, nextStatus);
                      if (_tabController.index < 3) _tabController.animateTo(_tabController.index + 1);
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: btnColor, foregroundColor: Colors.white),
                    child: Text(btnText),
                  ),
                ),
                if (nextStatus == OrderStatus.preparing) ...[
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        await OrderService.instance.updateOrderStatus(order.id, OrderStatus.declined);
                        await _sendAutoNotification(order, OrderStatus.declined);
                        _tabController.animateTo(3);
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                      child: const Text("Decline"),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _showOrderDetails(BuildContext context, FoodOrder order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)))),
            const SizedBox(height: 20),
            Text("Order Details", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.grey[800])),
            const SizedBox(height: 4),
            Text("Queue: ${order.queueNumber}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFE67E22))),
            const Divider(height: 40),
            ...order.items.map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Text("${item.quantity}x", style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 15),
                  Expanded(child: Text(item.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
                  Text("RM ${(item.price * item.quantity).toStringAsFixed(2)}"),
                ],
              ),
            )),
            const Divider(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Total Amount", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text("RM ${order.totalAmount.toStringAsFixed(2)}", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFE67E22))),
              ],
            ),
            const SizedBox(height: 30),
            SizedBox(width: double.infinity, height: 50, child: ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text("Close"))),
          ],
        ),
      ),
    );
  }

  Widget _buildInnerHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 40, bottom: 20, left: 20, right: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Color(0xFFF1C40F), Color(0xFFE67E22)]),
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
      ),
      child: const Center(
        child: Text("Admin Dashboard", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      labelColor: Colors.orange,
      unselectedLabelColor: Colors.grey,
      indicatorColor: Colors.orange,
      tabs: const [
        Tab(text: "New"),
        Tab(text: "Preparing"),
        Tab(text: "Ready"),
        Tab(text: "History"),
      ],
    );
  }
}