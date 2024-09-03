import 'package:flutter/material.dart';
import 'package:medi_connect/Model/updateOrderRequest.dart';
import '../Model/OrderDto.dart';
import '../Sevices/API/OrderAPI.dart';
import '../Sevices/Auth/UserSession.dart';

class UpdateOrderModal extends StatefulWidget {
  final Order order;
  final VoidCallback onUpdate;

  const UpdateOrderModal({Key? key, required this.order, required this.onUpdate}) : super(key: key);

  @override
  _UpdateOrderModalState createState() => _UpdateOrderModalState();
}

class _UpdateOrderModalState extends State<UpdateOrderModal> {
  final _formKey = GlobalKey<FormState>();
  String? _status;
  String? _trackingNumber;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _status = widget.order.orderStatus;
    _trackingNumber = widget.order.trackingNumber;
  }

  Future<void> _updateOrder() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    try {
      // Create an instance of UpdateOrderRequest
      final updateRequest = UpdateOrderRequest(
        status: _status!,
        trackingNumber: _trackingNumber,
      );
      final userId = int.parse(await UserSession.getUserId() ?? '0');
      // Call the updateOrder API with the constructed request
      await OrderAPI.updateOrder(widget.order.id, updateRequest); // Fix here: Use order.id instead of userId

      // Call the callback to refresh the orders and close the modal
      widget.onUpdate();
      Navigator.of(context).pop(true); // Return true to indicate the order was updated
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update order: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Ensure that the status change is valid
  bool _validateStatusChange(String newStatus) {
    if (_status == 'Shipped' && newStatus == 'Awaiting Shipment') {
      return false; // Can't go back to "Awaiting Shipment"
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Update Order'),
      content: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: _status,
                items: ['Awaiting Shipment', 'Shipped', 'Complete', 'Cancelled']
                    .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                    .toList(),
                onChanged: (value) {
                  if (_validateStatusChange(value!)) {
                    setState(() {
                      _status = value;
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Cannot revert status to "Awaiting Shipment" after it has been shipped.'),
                    ));
                  }
                },
                decoration: InputDecoration(labelText: 'Order Status'),
                validator: (value) => value == null ? 'Please select a status' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                initialValue: _trackingNumber,
                onSaved: (value) => _trackingNumber = value,
                decoration: InputDecoration(labelText: 'Tracking Number'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _updateOrder,
          child: Text('Update'),
        ),
      ],
    );
  }
}
