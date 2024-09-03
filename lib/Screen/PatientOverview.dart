import 'package:flutter/material.dart';

class PatientOverviewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hero Section
            Stack(
              children: [
                // Background Image or Video
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/hero_image.jpg'), // Replace with your image or video
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Text Overlay
                Positioned.fill(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Welcome to MediConnect",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                blurRadius: 10.0,
                                color: Colors.black45,
                                offset: Offset(3.0, 3.0),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Your Trusted Partner in Medication Accessibility",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            shadows: [
                              Shadow(
                                blurRadius: 5.0,
                                color: Colors.black45,
                                offset: Offset(2.0, 2.0),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // How It Works Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "How It Works",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildHowItWorksStep(
                    stepNumber: "1",
                    title: "Upload Your Prescription",
                    description:
                    "Start by uploading your prescription to find the medicine you need.",
                    icon: Icons.upload_file,
                  ),
                  _buildHowItWorksStep(
                    stepNumber: "2",
                    title: "Locate Pharmacies",
                    description:
                    "Find pharmacies near you that have the medicine in stock.",
                    icon: Icons.location_on,
                  ),
                  _buildHowItWorksStep(
                    stepNumber: "3",
                    title: "Track Your Order",
                    description:
                    "Place your order and track it until it arrives at your doorstep.",
                    icon: Icons.track_changes,
                  ),
                  _buildHowItWorksStep(
                    stepNumber: "4",
                    title: "Receive Your Medication",
                    description:
                    "Pick up your medicine at the pharmacy or get it delivered to you.",
                    icon: Icons.medical_services,
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),

            // Call to Action
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to the relevant page
                  },
                  child: Text("Get Started"),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),

            // Support Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      "Need Help?",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Navigate to support page or dial support number
                      },
                      icon: Icon(Icons.phone),
                      label: Text("Contact Support"),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Helper method to build How It Works steps
  Widget _buildHowItWorksStep({
    required String stepNumber,
    required String title,
    required String description,
    required IconData icon,
  }) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(
          stepNumber,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(description),
      trailing: Icon(icon, size: 30, color: Colors.blue),
    );
  }
}