import 'package:flutter/material.dart';
import '../Model/ResponseData.dart';
import '../Sevices/API/InvoiceAPI.dart';
import '../Sevices/Auth/UserSession.dart';
import 'ResponseCard.dart';

class ResponseScreen extends StatefulWidget {
  const ResponseScreen({super.key});

  @override
  _ResponseScreenState createState() => _ResponseScreenState();
}

class _ResponseScreenState extends State<ResponseScreen> {
  late Future<List<ResponseData>> _futureResponses;
  List<ResponseData> _responseData = [];

  // Filter criteria
  String _selectedFilter = 'None'; // Options: 'None', 'Price', 'Distance'

  @override
  void initState() {
    super.initState();
    _futureResponses = _fetchResponses();
  }

  Future<List<ResponseData>> _fetchResponses() async {
    final userId = await UserSession.getUserId();
    if (userId == null) {
      throw Exception("User ID not found.");
    }
    try {
      final responses = await InvoiceAPI.fetchResponses(int.parse(userId));
      return responses;
    } catch (e) {
      print('Error fetching responses: $e'); // Log the error
      rethrow;
    }
  }

  void _applyFilter(List<ResponseData> responses) {
    if (_selectedFilter == 'Price') {
      responses.sort((a, b) => a.total!.compareTo(b.total!));
    } else if (_selectedFilter == 'Distance') {
      responses.sort((a, b) => a.distance.compareTo(b.distance));
    }
  }

  void _removeResponseByPrescriptionId(int prescriptionId) {
    setState(() {
      _responseData.removeWhere((response) => response.prescriptionId == prescriptionId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Responses'),
        actions: [
          DropdownButton<String>(
            value: _selectedFilter,
            items: const [
              DropdownMenuItem(value: 'None', child: Text('None')),
              DropdownMenuItem(value: 'Price', child: Text('Sort by Price')),
              DropdownMenuItem(value: 'Distance', child: Text('Sort by Distance')),
            ],
            onChanged: (value) {
              setState(() {
                _selectedFilter = value!;
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<ResponseData>>(
        future: _futureResponses,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print('Snapshot error: ${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No responses found.'));
          } else {
            _responseData = snapshot.data!;
            _applyFilter(_responseData);
            return ListView.builder(
              itemCount: _responseData.length,
              itemBuilder: (context, index) {
                return ResponseCard(
                  data: _responseData[index],

                );
              },
            );
          }
        },
      ),
    );
  }
}
