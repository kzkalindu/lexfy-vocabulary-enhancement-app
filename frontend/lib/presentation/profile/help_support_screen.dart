// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../models/support_model.dart';
// import '../services/api_service.dart';

// class HelpSupportScreen extends StatefulWidget {
//   const HelpSupportScreen({Key? key}) : super(key: key);

//   @override
//   _HelpSupportScreenState createState() => _HelpSupportScreenState();
// }

// class _HelpSupportScreenState extends State<HelpSupportScreen> {
//   bool isLoading = true;
//   SupportModel supportInfo = SupportModel(
//     email: 'lexfy@gmail.com',
//     website: 'lexfy.app',
//     description: 'Need help with Lexfy? Visit lexfy.app for updates and FAQs. For further assistance, email us at lexfy@gmail.com. Whether it\'s account issues, feature guidance, or troubleshooting, we\'re here to help. Keep learning and mastering English with Lexfy! 🚀 Your feedback matters—let us know how we can improve!'
//   );

//   @override
//   void initState() {
//     super.initState();
//     _fetchSupportDetails();
//   }

//   Future<void> _fetchSupportDetails() async {
//     setState(() {
//       isLoading = true;
//     });

//     try {
//       final data = await ApiService().getSupportDetails();
//       setState(() {
//         supportInfo = data;
//         isLoading = false;
//       });
//     } catch (e) {
//       print('Error fetching support details: $e');
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   Future<void> _launchEmail() async {
//     final Uri emailUri = Uri(
//       scheme: 'mailto',
//       path: supportInfo.email,
//       query: 'subject=Support Request&body=Hello Lexfy Support Team,',
//     );
    
//     if (await canLaunch(emailUri.toString())) {
//       await launch(emailUri.toString());
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Could not launch email client")),
//       );
//     }
//   }

//   Future<void> _launchWebsite() async {
//     final url = 'https://${supportInfo.website}';
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Could not launch website")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color.fromARGB(255, 152, 79, 247),
//         elevation: 0,
//         title: Text(
//           'Help & Support',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               padding: EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Header image
//                   Center(
//                     child: Image.asset(
//                       'assets/images/support.png',
//                       height: 150,
//                       errorBuilder: (context, error, stackTrace) => Icon(
//                         Icons.support_agent,
//                         size: 150,
//                         color: Colors.deepPurple.withOpacity(0.7),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 30),
                  
//                   // Header text
//                   Center(
//                     child: Text(
//                       'Help & Support – Lexfy',
//                       style: TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.deepPurple,
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 20),
                  
//                   // Description
//                   Text(
//                     supportInfo.description,
//                     style: TextStyle(
//                       fontSize: 16,
//                       height: 1.5,
//                     ),
//                   ),
//                   SizedBox(height: 40),
                  
//                   // Contact card
//                   Container(
//                     padding: EdgeInsets.all(20),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(12),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.1),
//                           blurRadius: 5,
//                           offset: Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       children: [
//                         Text(
//                           'Contact Us',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.deepPurple,
//                           ),
//                         ),
//                         SizedBox(height: 20),
                        
//                         // Email row
//                         InkWell(
//                           onTap: _launchEmail,
//                           child: Row(
//                             children: [
//                               Container(
//                                 padding: EdgeInsets.all(10),
//                                 decoration: BoxDecoration(
//                                   color: Colors.deepPurple.withOpacity(0.1),
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 child: Icon(
//                                   Icons.email,
//                                   color: Colors.deepPurple,
//                                 ),
//                               ),
//                               SizedBox(width: 15),
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       'Email',
//                                       style: TextStyle(
//                                         fontSize: 14,
//                                         color: Colors.grey,
//                                       ),
//                                     ),
//                                     Text(
//                                       supportInfo.email,
//                                       style: TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Divider(height: 30),
                        
//                         // Website row
//                         InkWell(
//                           onTap: _launchWebsite,
//                           child: Row(
//                             children: [
//                               Container(
//                                 padding: EdgeInsets.all(10),
//                                 decoration: BoxDecoration(
//                                   color: Colors.deepPurple.withOpacity(0.1),
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 child: Icon(
//                                   Icons.language,
//                                   color: Colors.deepPurple,
//                                 ),
//                               ),
//                               SizedBox(width: 15),
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       'Website',
//                                       style: TextStyle(
//                                         fontSize: 14,
//                                         color: Colors.grey,
//                                       ),
//                                     ),
//                                     Text(
//                                       supportInfo.website,
//                                       style: TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 30),
                  
//                   // FAQ header
//                   Text(
//                     'Frequently Asked Questions',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.deepPurple,
//                     ),
//                   ),
//                   SizedBox(height: 15),
                  
//                   // FAQ items
//                   _buildFaqItem(
//                     'How do I reset my password?',
//                     'Go to the login screen and tap on "Forgot Password". Follow the instructions sent to your email.',
//                   ),
//                   _buildFaqItem(
//                     'How do I update my profile?',
//                     'Go to your profile screen and tap on "Edit Profile". From there you can update your information.',
//                   ),
//                   _buildFaqItem(
//                     'How do I earn more XP?',
//                     'Complete lessons, practice exercises, and participate in daily challenges to earn XP.',
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }

//   Widget _buildFaqItem(String question, String answer) {
//     return Container(
//       margin: EdgeInsets.only(bottom: 15),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 3,
//             offset: Offset(0, 1),
//           ),
//         ],
//       ),
//       child: ExpansionTile(
//         tilePadding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
//         title: Text(
//           question,
//           style: TextStyle(
//             fontSize: 15,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         children: [
//           Padding(
//             padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
//             child: Text(
//               answer,
//               style: TextStyle(
//                 fontSize: 14,
//                 height: 1.5,
//                 color: Colors.black87,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }