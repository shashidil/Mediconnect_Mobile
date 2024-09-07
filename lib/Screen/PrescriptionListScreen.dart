import 'package:flutter/material.dart';

import '../Model/PrescriptionDTO.dart';
import 'Request.dart';

class PrescriptionListScreen extends StatefulWidget {
  final List<PrescriptionDTO> prescriptions;

  const PrescriptionListScreen({super.key, required this.prescriptions});

  @override
  _PrescriptionListScreenState createState() => _PrescriptionListScreenState();
}

class _PrescriptionListScreenState extends State<PrescriptionListScreen> {
  late List<PrescriptionDTO> _prescriptions;

  @override
  void initState() {
    super.initState();
    _prescriptions = widget.prescriptions;
  }

  void _removePrescription(PrescriptionDTO prescription) {
    setState(() {
      _prescriptions.remove(prescription);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prescriptions')),
      body: ListView.builder(
        itemCount: _prescriptions.length,
        itemBuilder: (context, index) {
          final prescription = _prescriptions[index];
          return RequestCard(
            data: prescription,
            onRemove: () => _removePrescription(prescription),
          );
        },
      ),
    );
  }
}
