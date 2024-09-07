import 'package:flutter/material.dart';
import '../Model/PrescriptionDTO.dart';
import '../Sevices/API/InvoiceAPI.dart';
import '../Sevices/Auth/UserSession.dart';
import '../Widget/WidgetHelpers.dart';

class AddMedicationScreen extends StatefulWidget {
  final PrescriptionDTO prescription;
  final Function onSuccess;

  const AddMedicationScreen({super.key, required this.prescription, required this.onSuccess});

  @override
  _AddMedicationScreenState createState() => _AddMedicationScreenState();
}

class _AddMedicationScreenState extends State<AddMedicationScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<Map<String, dynamic>> _medications = [];
  String? _medicationName;
  String? _medicationDosage;
  int _days = 1;
  int? _medicationQuantity;
  double? _amount;

  void _addMedication() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      setState(() {
        _medications.add({
          'medicationName': _medicationName!,
          'medicationDosage': _medicationDosage!,
          'days': _days.toString(),
          'medicationQuantity': _medicationQuantity!,
          'amount': _amount!,
        });
      });
      _formKey.currentState?.reset();
      _days = 1;
    }
  }

  double _calculateTotal() {
    return _medications.fold(0.0, (total, med) => total + med['amount']);
  }

  Future<void> _submitInvoice() async {
    if (_medications.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one medication before submitting the invoice.')),
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
        const SnackBar(content: Text('Invoice sent successfully')),
      );
      widget.onSuccess();
      Navigator.of(context).pop();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invoice sending failed')),
      );
    }
  }

  Future<int> _getPharmacistId() async {
    final userId = await UserSession.getUserId();
    return int.parse(userId!);
  }

  Widget _buildCustomTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required FormFieldSetter<String> onSaved,
    required FormFieldValidator<String> validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        keyboardType: keyboardType,
        onSaved: onSaved,
        validator: validator,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Add Medication'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildCustomTextField(
                  controller: TextEditingController(),
                  label: 'Medication Name',
                  icon: Icons.medical_services,
                  onSaved: (value) => _medicationName = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please input the medication name';
                    }
                    return null;
                  },
                ),
                _buildCustomTextField(
                  controller: TextEditingController(),
                  label: 'Medication Dosage',
                  icon: Icons.science,
                  onSaved: (value) => _medicationDosage = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please input the medication dosage';
                    }
                    return null;
                  },
                ),
                Row(
                  children: [
                    const Text('Number of Days'),
                    const SizedBox(width: 10),
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: _days > 1
                          ? () {
                        setState(() {
                          _days--;
                        });
                      }
                          : null,
                    ),
                    Text(_days.toString()),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () {
                        setState(() {
                          _days++;
                        });
                      },
                    ),
                  ],
                ),
                _buildCustomTextField(
                  controller: TextEditingController(),
                  label: 'Medication Quantity',
                  icon: Icons.production_quantity_limits,
                  keyboardType: TextInputType.number,
                  onSaved: (value) => _medicationQuantity = int.tryParse(value!),
                  validator: (value) {
                    if (value == null || value.isEmpty || int.tryParse(value) == null) {
                      return 'Please input a valid medication quantity';
                    }
                    return null;
                  },
                ),
                _buildCustomTextField(
                  controller: TextEditingController(),
                  label: 'Amount',
                  icon: Icons.attach_money,
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
                WidgetHelpers.buildCommonButton(
                  text: 'Add Medication',
                  onPressed: _addMedication,
                  backgroundColor: Colors.blue,
                  textColor: Colors.white,
                  borderRadius: 10.0,
                  paddingVertical: 12.0,
                  paddingHorizontal: 24.0,
                ),
                const SizedBox(height: 16.0),
                ListView.builder(
                  shrinkWrap: true,
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
                WidgetHelpers.buildCommonButton(
                  text: 'Submit Invoice',
                  onPressed: _submitInvoice,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  borderRadius: 10.0,
                  paddingVertical: 12.0,
                  paddingHorizontal: 24.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
