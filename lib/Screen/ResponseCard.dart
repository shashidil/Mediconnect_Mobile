import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Model/ResponseData.dart';
import '../Widget/WidgetHelpers.dart';

class ResponseCard extends StatelessWidget {
  final ResponseData data;
  final VoidCallback onOrderSuccess;

  const ResponseCard({super.key, required this.data, required this.onOrderSuccess});

  void _openGoogleMaps() async {
    final Uri url = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&origin=${data.customerLatitude},${data.customerLongitude}&destination=${data.pharmacistLatitude},${data.pharmacistLongitude}&travelmode=driving');

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not open the map.';
    }
  }

  void _orderMedications(BuildContext context) {
    // Logic to order medications, upon success:
    onOrderSuccess();  // Call the success callback to remove the card
  }

  void _showDetailsModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pharmacist: ${data.pharmacistName ?? 'Unknown'}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.blueGrey,),
                ),
                const SizedBox(height: 8),
                Text('Total Price: \$${data.total?.toStringAsFixed(2) ?? 'N/A'}'),
                const SizedBox(height: 8),
                Text('Distance: ${data.distance} km'),
                const SizedBox(height: 8),
                const Text('Medications:', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blueGrey)),
                ...data.medications.map((med) => Text(
                    '${med.medicationName} - ${med.medicationDosage} - ${med.medicationQuantity} units - \$${med.amount}')),
                const SizedBox(height: 16),
                IconButton(
                  icon: const Icon(Icons.directions),
                  tooltip: 'Get Directions',
                  onPressed: _openGoogleMaps,
                  color: Colors.blue,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pharmacist: ${data.pharmacistName ?? 'Unknown'}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text('Total: \$${data.total?.toStringAsFixed(2) ?? 'N/A'}'),
            Text('Distance: ${data.distance} km'),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.info_outline),
                  tooltip: 'See More',
                  onPressed: () => _showDetailsModal(context),
                ),
                IconButton(
                  icon: const Icon(Icons.directions),
                  tooltip: 'Get Directions',
                  onPressed: _openGoogleMaps,
                ),
                WidgetHelpers.buildCommonButton(
                  text: 'Order',
                  onPressed: () => _orderMedications(context),
                  backgroundColor: Colors.blue,
                  textColor: Colors.white,
                  borderRadius: 8.0,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
