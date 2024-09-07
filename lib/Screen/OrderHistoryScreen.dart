import 'package:flutter/material.dart';
import '../Model/OrderDto.dart';
import '../Sevices/API/OrderAPI.dart';
import '../Sevices/Auth/UserSession.dart';
import '../Widget/WidgetHelpers.dart';
import 'OrderDetails.dart';

class OrderHistoryScreen extends StatefulWidget {
  final bool isPharmacist;

  const OrderHistoryScreen({super.key, required this.isPharmacist});

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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              order.orderNumber,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              order.orderDate,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              '\$${order.totalAmount.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
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
              WidgetHelpers.buildCommonButton(
                text: 'Edit Order',
                onPressed: () => _navigateToOrderDetails(order),
                backgroundColor: Colors.blue,
                textColor: Colors.white,
                borderRadius: 8.0,
                paddingVertical: 12.0,
                paddingHorizontal: 16.0,
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  WidgetHelpers.buildCommonButton(
                    text: 'View Details',
                    onPressed: () => _navigateToOrderDetails(order),
                    backgroundColor: Colors.blue,
                    textColor: Colors.white,
                    borderRadius: 8.0,
                    paddingVertical: 12.0,
                    paddingHorizontal: 16.0,
                  ),
                  if (order.orderStatus == 'Shipped')
                    WidgetHelpers.buildCommonButton(
                      text: 'Track',
                      onPressed: () {
                        // Implement tracking logic here
                      },
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      borderRadius: 8.0,
                      paddingVertical: 12.0,
                      paddingHorizontal: 16.0,
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
