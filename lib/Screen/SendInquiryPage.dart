import 'package:flutter/material.dart';
import '../Model/InquiryRequestDTO.dart';
import '../Sevices/API/InquiryAPI.dart';
import '../Widget/WidgetHelpers.dart';
import 'package:medi_connect/Sevices/Auth/UserSession.dart';

class SendInquiryPage extends StatefulWidget {
  @override
  _SendInquiryPageState createState() => _SendInquiryPageState();
}

class _SendInquiryPageState extends State<SendInquiryPage> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _submitInquiry() async {
    if (_formKey.currentState?.validate() ?? false) {
      String? userId = await UserSession.getUserId();
      if (userId != null) {
        InquiryRequestDTO inquiryRequest = InquiryRequestDTO(
          subject: _subjectController.text,
          message: _messageController.text,
          status: 'Pending',
          senderId: int.parse(userId),
        );

        bool success = await InquiryAPI.createInquiry(inquiryRequest);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(success
              ? 'Inquiry submitted successfully'
              : 'Failed to submit inquiry. Please try again later.'),
        ));

        if (success) {
          // Clear the form after successful submission
          _subjectController.clear();
          _messageController.clear();
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User ID not found. Please log in.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Send Inquiry'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Optional icon or image at the top
              Icon(
                Icons.help_outline,
                color: Colors.blue,
                size: 60.0,
              ),
              SizedBox(height: 20),
              // Introductory text
              Text(
                'Have a question or issue?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                'Fill out the form below and we will get back to you as soon as possible.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    WidgetHelpers.buildTextField(
                      controller: _subjectController,
                      label: 'Subject',
                      icon: Icons.subject,
                    ),
                    WidgetHelpers.buildTextField(
                      controller: _messageController,
                      label: 'Message',
                      icon: Icons.message,
                      maxLines: 5, // Allowing for a multi-line message
                    ),
                    SizedBox(height: 20),
                    WidgetHelpers.buildCommonButton(
                      text: 'Submit Inquiry',
                      onPressed: _submitInquiry,
                      backgroundColor: Colors.blue, // Inverted colors for emphasis
                      textColor: Colors.white,
                      borderRadius: 10.0,
                      paddingVertical: 16.0,
                      paddingHorizontal: 10
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
