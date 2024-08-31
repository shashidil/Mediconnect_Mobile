import 'package:flutter/material.dart';
import '../Model/PrescriptionDTO.dart';
import '../Sevices/API/InvoiceAPI.dart';
import '../Sevices/Auth/UserSession.dart';

class AddMedicationScreen extends StatefulWidget {
  final PrescriptionDTO prescription;
  final Function onSuccess;

  const AddMedicationScreen({Key? key, required this.prescription, required this.onSuccess}) : super(key: key);

  @override
  _AddMedicationScreenState createState() => _AddMedicationScreenState();
}

class _AddMedicationScreenState extends State<AddMedicationScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<Map<String, dynamic>> _medications = [];
  String? _medicationName;
  String? _medicationDosage;
  String? _days;
  int? _medicationQuantity;
  double? _amount;

  void _addMedication() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      setState(() {
        _medications.add({
          'medicationName': _medicationName!,
          'medicationDosage': _medicationDosage!,
          'days': _days!,
          'medicationQuantity': _medicationQuantity!,
          'amount': _amount!,
        });
      });
      _formKey.currentState?.reset();
    }
  }

  double _calculateTotal() {
    return _medications.fold(0.0, (total, med) => total + med['amount']);
  }

  Future<void> _submitInvoice() async {
    if (_medications.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please add at least one medication before submitting the invoice.')),
      );
      return;
    }

    try {
      final String invoiceNumber = 'INV${DateTime.now().millisecondsSinceEpoch}';
      final formData = {
        'medications': _medications,
        'prescriptionId': widget.prescription.id,
        'pharmacistId': await _getPharmacistId(),
        'totalAmount': _calculateTotal(),
        'invoiceNumber': invoiceNumber,
      };

      final response = await InvoiceAPI.sendInvoice(formData);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invoice sent successfully')),
      );
      widget.onSuccess();
      Navigator.of(context).pop();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invoice sending failed')),
      );
    }
  }

  Future<int> _getPharmacistId() async {
    final userId = await UserSession.getUserId();
    return int.parse(userId!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Medication'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Medication Name'),
                  onSaved: (value) => _medicationName = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please input the medication name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Medication Dosage'),
                  onSaved: (value) => _medicationDosage = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please input the medication dosage';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Number of Days'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => _days = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please input the number of days';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Medication Quantity'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => _medicationQuantity = int.tryParse(value!),
                  validator: (value) {
                    if (value == null || value.isEmpty || int.tryParse(value) == null) {
                      return 'Please input a valid medication quantity';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Amount'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => _amount = double.tryParse(value!),
                  validator: (value) {
                    if (value == null || value.isEmpty || double.tryParse(value) == null) {
                      return 'Please input a valid amount';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _addMedication,
                  child: Text('Add Medication'),
                ),
                const SizedBox(height: 16.0),
                ListView.builder(
                  shrinkWrap: true, // Added to make the ListView work inside SingleChildScrollView
                  itemCount: _medications.length,
                  itemBuilder: (context, index) {
                    final medication = _medications[index];
                    return ListTile(
                      title: Text('${medication['medicationName']} - ${medication['medicationDosage']}'),
                      subtitle: Text('${medication['days']} days, ${medication['medicationQuantity']} units - \$${medication['amount']}'),
                    );
                  },
                ),
                const SizedBox(height: 16.0),
                Text('Total: \$${_calculateTotal().toStringAsFixed(2)}'),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _submitInvoice,
                  child: Text('Submit Invoice'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
