

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Model/ResponseData.dart';
import 'PaymentScreen.dart';

class ResponseCard extends StatelessWidget {
  final ResponseData data;

  const ResponseCard({super.key, required this.data});

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
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PaymentScreen(data: data), // Pass the ResponseData to PaymentScreen
      ),
    );
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
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text('Total Price: \$${data.total?.toStringAsFixed(2) ?? 'N/A'}'),
                const SizedBox(height: 8),
                Text('Distance: ${data.distance} km'),
                const SizedBox(height: 8),
                const Text('Medications:', style: TextStyle(fontWeight: FontWeight.bold)),
                ...data.medications.map((med) => Text(
                    '${med.medicationName} - ${med.medicationDosage} - ${med.medicationQuantity} units - \$${med.amount}')).toList(),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _openGoogleMaps,
                  child: const Text('Get Directions'),
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pharmacist: ${data.pharmacistName ?? 'Unknown'}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text('Total: \$${data.total?.toStringAsFixed(2) ?? 'N/A'}'),
                Text('Distance: ${data.distance} km'),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => _showDetailsModal(context),
                      child: const Text('See More'),
                    ),
                    ElevatedButton(
                      onPressed: () => _orderMedications(context),
                      child: const Text('Order'),
                    ),
                    ElevatedButton(
                      onPressed: _openGoogleMaps,
                      child: const Text('Get Directions'),
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: const Icon(Icons.message, color: Colors.blue),
                onPressed: () {
                  // Implement the logic to contact or message the pharmacist
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
