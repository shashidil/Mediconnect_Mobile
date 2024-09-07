import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

import '../Model/PrescriptionDTO.dart';
import 'AddMedication.dart';
import 'ChatScreen.dart';

class RequestCard extends StatelessWidget {
  final PrescriptionDTO data;
  final VoidCallback onRemove;

  const RequestCard({super.key, required this.data, required this.onRemove});

  void _showImageModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(data.fileName ?? 'No Image Available'),
          content: Image.memory(
            base64Decode(data.imageData!),
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

  Future<void> _downloadImage(BuildContext context) async {
    try {
      // Get the base64 encoded string and decode it
      final decodedBytes = base64Decode(data.imageData!);

      // Get the path to the documents directory
      final directory = await getApplicationDocumentsDirectory();

      // Create a file to save the image
      final file = File('${directory.path}/${data.fileName ?? 'downloaded_image'}.png');

      // Write the image data to the file
      await file.writeAsBytes(decodedBytes);

      // Notify the user of successful download
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image downloaded successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to download image: $e')),
      );
    }
  }

  void _addMedication(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => AddMedicationScreen(
        prescription: data,
        onSuccess: onRemove,
      ),
    ));
  }

  void _contactUser(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChatScreen(receiverId: data.user.id, receiverName: data.user.name),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 4.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with blue background and white text
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'User: ${data.user.name}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Email: ${data.user.email}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                if (data.imageData != null && data.imageData!.isNotEmpty) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Stack(
                      children: [
                        Image.memory(
                          base64Decode(data.imageData!),
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          bottom: 8,
                          left: 8,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: IconButton(
                              icon: const Icon(Icons.zoom_out_map, color: Colors.blue),
                              onPressed: () => _showImageModal(context),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: IconButton(
                              icon: const Icon(Icons.download, color: Colors.green),
                              onPressed: () => _downloadImage(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else if (data.medicationName != null && data.medicationName!.isNotEmpty) ...[
                  Text(
                    'Medication Name: ${data.medicationName}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Quantity: ${data.medicationQuantity}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ] else ...[
                  const Text('No image or medication data available', style: TextStyle(color: Colors.red)),
                ],
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chat, color: Colors.blue),
                      onPressed: () => _contactUser(context),
                      tooltip: 'Contact User',
                    ),
                    ElevatedButton(
                      onPressed: () => _addMedication(context),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      child: const Text('Add Medication', style: TextStyle(fontSize: 16,color:Colors.blue)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
