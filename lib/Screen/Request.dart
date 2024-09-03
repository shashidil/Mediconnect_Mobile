import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

import '../Model/PrescriptionDTO.dart';
import 'AddMedication.dart';
import 'ChatScreen.dart';

class RequestCard extends StatelessWidget {
  final PrescriptionDTO data;
  final VoidCallback onRemove; // Callback to remove the card

  RequestCard({required this.data, required this.onRemove});

  void _showImageModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(data.fileName),
          content: Image.memory(
            base64Decode(data.imageData),
            fit: BoxFit.cover,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _downloadImage() async {
    final Uri uri = Uri.parse('data:image/png;base64,${data.imageData}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $uri';
    }
  }

  void _addMedication(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => AddMedicationScreen(
        prescription: data,
        onSuccess: onRemove, // Pass the remove callback
      ),
    ));
  }

  void _contactUser(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChatScreen(receiverId: data.user.id, receiverName: data.user.name), // Pass the receiverId
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('User: ${data.user.name}', style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('Email: ${data.user.email}'),
            const SizedBox(height: 8),
            Stack(
              children: [
                Image.memory(
                  base64Decode(data.imageData),
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: ElevatedButton(
                    onPressed: () => _showImageModal(context),
                    child: const Text('View More'),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: ElevatedButton(
                    onPressed: _downloadImage,
                    child: const Text('Download Image'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => _contactUser(context),
                  child: const Text('Contact'),
                ),
                ElevatedButton(
                  onPressed: () => _addMedication(context),
                  child: const Text('Add Medication'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
