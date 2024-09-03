import 'package:flutter/material.dart';
import '../Model/OrderDto.dart';
import '../Sevices/API/OrderAPI.dart';
import '../Sevices/Auth/UserSession.dart';
import 'OrderDetails.dart';

class OrderHistoryScreen extends StatefulWidget {
  final bool isPharmacist;

  const OrderHistoryScreen({Key? key, required this.isPharmacist}) : super(key: key);

  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  late Future<List<Order>> _orderHistoryFuture;

  @override
  void initState() {
    super.initState();
    _orderHistoryFuture = _fetchOrderHistory();
  }

  Future<List<Order>> _fetchOrderHistory() async {
    final userId = int.parse(await UserSession.getUserId() ?? '0');
    return await OrderAPI.fetchOrderHistory(userId, widget.isPharmacist);
  }

  void _navigateToOrderDetails(Order order) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => OrderDetailsScreen(order: order, isPharmacist: widget.isPharmacist),
      ),
    );

    // Check if the order was updated and refresh the list
    if (result == true) {
      setState(() {
        _orderHistoryFuture = _fetchOrderHistory();
      });
    }
  }

  Widget _buildOrderCard(Order order) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order.orderDate,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${order.totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(order.orderNumber, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              'Status: ${order.orderStatus}',
              style: TextStyle(
                color: order.orderStatus == 'Complete' ? Colors.green : Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            if (widget.isPharmacist)
              ElevatedButton(
                onPressed: () => _navigateToOrderDetails(order),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Edit Order'),
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () => _navigateToOrderDetails(order),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('View Details'),
                  ),
                  if (order.orderStatus == 'Shipped')
                    ElevatedButton(
                      onPressed: () {
                        // Implement tracking logic here
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Track'),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order History')),
      body: FutureBuilder<List<Order>>(
        future: _orderHistoryFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No orders found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return _buildOrderCard(snapshot.data![index]);
              },
            );
          }
        },
      ),
    );
  }
}
