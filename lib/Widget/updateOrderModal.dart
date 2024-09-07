import 'package:flutter/material.dart';
import 'package:medi_connect/Model/updateOrderRequest.dart';
import '../Model/OrderDto.dart';
import '../Sevices/API/OrderAPI.dart';
import '../Widget/WidgetHelpers.dart';

class UpdateOrderModal extends StatefulWidget {
  final Order order;
  final VoidCallback onUpdate;

  const UpdateOrderModal({super.key, required this.order, required this.onUpdate});

  @override
  _UpdateOrderModalState createState() => _UpdateOrderModalState();
}

class _UpdateOrderModalState extends State<UpdateOrderModal> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _trackingNumberController = TextEditingController();
  String? _status;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _status = widget.order.orderStatus;
    _trackingNumberController.text = widget.order.trackingNumber ?? '';
  }

  Future<void> _updateOrder() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      bool statusUpdated = false;
      bool trackingNumberUpdated = false;

      try {
        // Create an instance of UpdateOrderRequest with the current status and tracking number
        final updateRequest = UpdateOrderRequest(
          status: _status!,
          trackingNumber: _trackingNumberController.text,
        );

        await OrderAPI.updateOrder(widget.order.id, updateRequest);
        print(updateRequest.trackingNumber);
        // Check if the status was updated
        if (_status != widget.order.orderStatus) {
          statusUpdated = true;
        }

        // Check if the tracking number was updated
        if (_trackingNumberController.text != widget.order.trackingNumber) {
          trackingNumberUpdated = true;
        }

        // Display appropriate messages
        if (statusUpdated && trackingNumberUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Order status and tracking number updated successfully!')),
          );
        } else if (statusUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Order status updated successfully!')),
          );
        } else if (trackingNumberUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tracking number updated successfully!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No changes were made.')),
          );
        }

        // Call the callback to refresh the orders
        widget.onUpdate();
        Navigator.of(context).pop(true); // Return true to indicate the order was updated
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update order: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }


  bool _validateStatusChange(String newStatus) {
    if (_status == 'Shipped' && newStatus == 'Awaiting Shipment') {
      return false; // Can't go back to "Awaiting Shipment"
    } else if (_status == 'Complete' && newStatus == 'Shipped') {
      return false; // Can't go back to "Shipped" after "Complete"
    } else if (_status == 'Cancelled' &&
        (newStatus == 'Shipped' || newStatus == 'Complete' || newStatus == 'Awaiting Shipment')) {
      return false; // Can't go back to any status after "Cancelled"
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Update Order'),
      content: _isLoading
          ? const Center(child: CircularProgressIndicator())
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Cannot revert status.')),
                    );
                  }
                },
                decoration: const InputDecoration(labelText: 'Order Status'),
                validator: (value) => value == null ? 'Please select a status' : null,
              ),
              const SizedBox(height: 10),
              WidgetHelpers.buildTextField(
                controller: _trackingNumberController,
                label: 'Tracking Number',
                icon: Icons.local_shipping,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _updateOrder,
          child: const Text('Update'),
        ),
      ],
    );
  }
}
