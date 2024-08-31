import 'package:flutter/material.dart';
import 'package:medi_connect/Sevices/API/InvoiceAPI.dart';
import '../Model/ResponseData.dart';
import '../Sevices/Auth/UserSession.dart';
import 'ResponseCard.dart';

class ResponseScreen extends StatefulWidget {
  const ResponseScreen({Key? key}) : super(key: key);

  @override
  _ResponseScreenState createState() => _ResponseScreenState();
}

class _ResponseScreenState extends State<ResponseScreen> {
  late Future<List<ResponseData>> _futureResponses;

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
      return await InvoiceAPI.fetchResponses(int.parse(userId));
    } catch (e) {
      print('Error fetching responses: $e'); // Log the error
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Responses')),
      body: FutureBuilder<List<ResponseData>>(
        future: _futureResponses,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print('Snapshot error: ${snapshot.error}'); // Log the snapshot error
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No responses found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ResponseCard(data: snapshot.data![index]);
              },
            );
          }
        },
      ),
    );
  }
}
