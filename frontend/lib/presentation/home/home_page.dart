// import 'package:flutter/material.dart';
//
// // Home Screen
// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         const SizedBox(height: 24),
//         TextField(
//           decoration: InputDecoration(
//             hintText: "Search for Words…",
//             hintStyle: TextStyle(color: Colors.grey[400]),
//             prefixIcon: const Icon(Icons.search, color: Color(0xFF636AE8)),
//             filled: true,
//             fillColor: Colors.grey[50],
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(30),
//               borderSide: BorderSide.none,
//             ),
//             contentPadding:
//             const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(30),
//               borderSide: BorderSide(color: Colors.grey[200]!),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(30),
//               borderSide: const BorderSide(color: Color(0xFF636AE8)),
//             ),
//           ),
//         ),
//         const SizedBox(height: 24),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             ElevatedButton(
//               onPressed: () {},
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF636AE8),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 padding:
//                 const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//               ),
//               child: const Text(
//                 "Button 1",
//                 style: TextStyle(fontSize: 16),
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () {},
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF636AE8),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 padding:
//                 const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//               ),
//               child: const Text(
//                 "Button 2",
//                 style: TextStyle(fontSize: 16),
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () {},
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF636AE8),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 padding:
//                 const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//               ),
//               child: const Text(
//                 "Button 3",
//                 style: TextStyle(fontSize: 16),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 24),
//         Container(
//           padding: const EdgeInsets.all(16.0),
//           decoration: BoxDecoration(
//             color: const Color.fromARGB(255, 220, 220, 220),
//             borderRadius: BorderRadius.circular(12),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.1),
//                 spreadRadius: 2,
//                 blurRadius: 5,
//                 offset: const Offset(0, 3),
//               ),
//             ],
//           ),
//           child: Column(
//             children: [
//               const Text(
//                 'Empathy',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               const Text(
//                 '(n.) The ability to understand and share the feelings of another',
//                 style: TextStyle(fontStyle: FontStyle.italic),
//               ),
//               const SizedBox(height: 12),
//               Text(
//                 'Example: She showed empathy by listening carefully and offering support to her friend who was going through a tough time.',
//                 style: TextStyle(
//                   color: Colors.grey[600],
//                   fontSize: 14,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';

import '../navigation/app_navbar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learn English'),
        backgroundColor: const Color(0xFF636AE8),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            _buildSearchField(),
            const SizedBox(height: 24),
            _buildButtonsRow(),
            const SizedBox(height: 24),
            _buildExampleCard(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search for Words…",
        hintStyle: TextStyle(color: Colors.grey[400]),
        prefixIcon: const Icon(Icons.search, color: Color(0xFF636AE8)),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Color(0xFF636AE8)),
        ),
      ),
      onSubmitted: (String value) {
        // Handle search query
      },
    );
  }

  Widget _buildButtonsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            // Navigate to AI Coach
            //Navigator.pushNamed(context, '/ai-coach');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF636AE8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: const Text(
            "AI Coach",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            // Navigate to Learning
            //Navigator.pushNamed(context, '/learning');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF636AE8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: const Text(
            "Learning",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            // Navigate to Quizzes
            //Navigator.pushNamed(context, '/quizzes');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF636AE8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: const Text(
            "Quizzes",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExampleCard() {
    return Card(
      color: const Color.fromARGB(255, 220, 220, 20),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Empathy',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '(n.) The ability to understand and share the feelings of another',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Example: She showed empathy by listening carefully and offering support to her friend who was going through a tough time.',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
