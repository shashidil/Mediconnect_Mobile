


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medi_connect/Sevices/API/UploadPriscriptionAPI.dart';
import '../Sevices/API/PharmacistAPI.dart';
import '../Sevices/Auth/UserSession.dart';
import '../Utills/Data/StatesAndCities.dart';

class UploadPrescription extends StatefulWidget {
  const UploadPrescription({super.key});

  @override
  _UploadPrescriptionState createState() => _UploadPrescriptionState();
}

class _UploadPrescriptionState extends State<UploadPrescription> {
  String? _selectedState; // Store the selected state
  String? _selectedCity;  // Store the selected city
  XFile? _prescriptionImage; // Store the uploaded prescription image
  final ImagePicker _imagePicker = ImagePicker(); // Image picker instance
  final PharmacistAPI _pharmacistAPI = PharmacistAPI();
  final UploadPrescriptionAPI _uploadPrescriptionAPI = UploadPrescriptionAPI();
  String? _uploadedImageName; // To store the image name
  bool _isUploading = false; // To show a loading indicator during upload

  List<Map<String, dynamic>> _pharmacists = [];

  // List of Sri Lankan states and their corresponding cities

// Method to get pharmacists based on selected state and city
  Future<void> _getPharmacists() async {
    if (_selectedCity != null) {
      try {
        final pharmacists = await _pharmacistAPI.getPharmacistsByCity(_selectedCity!);
        setState(() {
          _pharmacists = pharmacists; // Store the pharmacists in the state
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch pharmacists: $e')),
        );
      }
    } else if (_selectedState != null) {
      print(_selectedState);
      try {
        final pharmacists = await _pharmacistAPI.getPharmacistsByState(_selectedState!);
        setState(() {
          _pharmacists = pharmacists; // Store the pharmacists in the state
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch pharmacists: $e')),
        );
      }
    }
   _showPharmacistsModal();
  }

  Future<void> _uploadPrescription() async {
    final pickedImage = await _imagePicker.pickImage(
      source: ImageSource.gallery, // Or ImageSource.camera for mobile
    );

    if (pickedImage != null) {
      setState(() {
        _prescriptionImage = pickedImage;
        _uploadedImageName = pickedImage.name; // Set the image name
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image to upload.')),
      );
    }
  }

  Future<void> _checkAvailability() async {
    if (_prescriptionImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No image uploaded to check availability.')),
      );
      return;
    }

    setState(() {
      _isUploading = true; // Show loading indicator
    });

    try {
      final userId = await UserSession.getUserId();
      if (userId == null || userId.isEmpty) {
        throw Exception('User ID not found');
      }

      if (_pharmacists.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No pharmacists found for the selected location.')),
        );
        return;
      }

      List<int> pharmacistIds = _pharmacists.map((pharmacist) => pharmacist['id'] as int).toList();
      if (pharmacistIds.isEmpty) {
        throw Exception('Pharmacist IDs not found');
      }

      File file = File(_prescriptionImage!.path);

      String result = await _uploadPrescriptionAPI.uploadPrescription(file, int.parse(userId), pharmacistIds);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result)),
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to check availability: $e')),
      );
    } finally {
      setState(() {
        _isUploading = false; // Hide loading indicator
      });
    }
  }


  void _showInquireMedicineModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController medicationNameController = TextEditingController();
        final TextEditingController medicationQuantityController = TextEditingController();

        return AlertDialog(
          title: const Text("Inquire Medicine"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: medicationNameController,
                decoration: const InputDecoration(
                  labelText: "Medication Name",
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: medicationQuantityController,
                decoration: const InputDecoration(
                  labelText: "Medication Quantity",
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog without action
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                final medicationName = medicationNameController.text;
                final medicationQuantity = medicationQuantityController.text;

                // Handle the inquire logic here with medicationName and medicationQuantity
                print("Inquire about: $medicationName, Quantity: $medicationQuantity");

                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Inquire"),
            ),
          ],
        );
      },
    );
  }
  void _showPharmacistsModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Pharmacists in the Selected Area"),
          content: SingleChildScrollView(
            child: ListBody(
              children: _pharmacists.map((pharmacist) => Text('Name: ${pharmacist['name']}')).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  void _removeUploadedImage() {
    setState(() {
      _prescriptionImage = null;
      _uploadedImageName = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Select Location",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              hint: const Text("Select State"),
                              value: _selectedState,
                              items: StatesAndCities.getStates().map(
                                      (String key) {
                                    return DropdownMenuItem<String>(
                                      value: key,
                                      child: Text(key),
                                    );
                                  }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedState = value;
                                  _selectedCity = null;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: _getPharmacists,
                            child: const Text("Confirm Area"),
                          ),
                        ],
                      ),
                      if (_selectedState != "All of Sri Lanka" && _selectedState != null)
                        DropdownButton<String>(
                          isExpanded: true,
                          hint: const Text("Select City"),
                          value: _selectedCity,
                          items: StatesAndCities.getCities(_selectedState!).map((String city) {
                            return DropdownMenuItem<String>(
                              value: city,
                              child: Text(city),
                            );
                          })
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCity = value;
                            });
                          },
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (_uploadedImageName != null) ...[
                Text("Selected Image: $_uploadedImageName"),
                ElevatedButton(
                  onPressed: _removeUploadedImage,
                  child: const Text("Remove Image"),
                ),
              ],
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _uploadPrescription,
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(const Color(0xFF2E384D)),
                  fixedSize: WidgetStateProperty.all(const Size(300, 50)),
                ),
                child: const Text("Upload Prescription",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _showInquireMedicineModal,
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(const Color(0xFF2E384D)),
                  fixedSize: WidgetStateProperty.all(const Size(300, 50)),
                ),
                child: const Text("Inquire Medicine",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (_isUploading) const CircularProgressIndicator(), // Show loading indicator
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _checkAvailability, // Call the check availability method
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(const Color(0xFFE03044)),
                  fixedSize: WidgetStateProperty.all(const Size(300, 50)),
                ),
                child: const Text("Check Availability",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
