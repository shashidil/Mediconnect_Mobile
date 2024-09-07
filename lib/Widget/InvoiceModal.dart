import 'package:flutter/material.dart';
import '../Model/ResponseData.dart'; // Adjust import as needed

class InvoiceDetailsModal extends StatelessWidget {
  final ResponseData invoiceData;

  const InvoiceDetailsModal({super.key, required this.invoiceData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Pharmacist: ${invoiceData.pharmacistName}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Total Amount: \$${invoiceData.total?.toStringAsFixed(2)}'),
          const Divider(),
          const Text('Medications:', style: TextStyle(fontWeight: FontWeight.bold)),
          ...invoiceData.medications.map((medication) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text('${medication.medicationName} - ${medication.medicationDosage} - ${medication.medicationQuantity} units - \$${medication.amount}'),
          )),
        ],
      ),
    );
  }
}
