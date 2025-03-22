import 'package:flutter/material.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFF636AE8);
    
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 243, 255),
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: const Text(
          'Privacy',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header image
              Center(
                child: Container(
                  height: 160,
                  width: 160,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.security,
                      size: 80,
                      color: primaryColor,
                    ),
                  ),
                ),
              ),
              
              // Title
              Center(
                child: Text(
                  'Privacy Policy',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Privacy content cards
              _buildPrivacySection(
                title: 'Data Collection',
                content: 'We collect minimal personal information necessary to provide our services. This includes your email address and basic profile information.',
                icon: Icons.data_usage,
                primaryColor: primaryColor,
              ),
              
              _buildPrivacySection(
                title: 'How We Use Your Data',
                content: 'Your data is used to personalize your experience, track progress, and provide insights to help your learning journey.',
                icon: Icons.analytics_outlined,
                primaryColor: primaryColor,
              ),
              
              _buildPrivacySection(
                title: 'Information Security',
                content: 'We implement industry-standard security measures to protect your personal information from unauthorized access or disclosure.',
                icon: Icons.enhanced_encryption,
                primaryColor: primaryColor,
              ),
              
              _buildPrivacySection(
                title: 'Third-Party Services',
                content: 'We use Firebase for authentication and data storage. Please refer to Firebase\'s privacy policy for more information.',
                icon: Icons.outbound,
                primaryColor: primaryColor,
              ),
              
              _buildPrivacySection(
                title: 'User Rights',
                content: 'You can access, update, or request deletion of your personal information at any time through your profile settings.',
                icon: Icons.account_circle_outlined,
                primaryColor: primaryColor,
              ),
              
              const SizedBox(height: 20),
              
              // Contact for questions
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Questions?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'If you have any questions about our privacy practices, please contact us at lexfy@gmail.com',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Last updated
              Center(
                child: Text(
                  'Last Updated: March 2025',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildPrivacySection({
    required String title,
    required String content,
    required IconData icon,
    required Color primaryColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: primaryColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}