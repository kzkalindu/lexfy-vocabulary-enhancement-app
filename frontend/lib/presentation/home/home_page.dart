// import 'package:flutter/material.dart';
// import '/presentation/navigation/app_navbar.dart';
//
// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color(0xFF636AE8),
//         title: Text('Lexfy'),
//       ),
//       bottomNavigationBar: BottomNavBar(),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Search for words...", style: TextStyle(fontSize: 18)),
//             SizedBox(height: 12),
//             TextField(
//               decoration: InputDecoration(
//                 hintText: "Search...",
//                 border: OutlineInputBorder(),
//                 contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 14),
//               ),
//             ),
//             SizedBox(height: 20),
//             Card(
//               elevation: 3,
//               child: Padding(
//                 padding: EdgeInsets.all(12.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text("Empathy", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFF636AE8))),
//                     SizedBox(height: 8),
//                     Text("(n.) The ability to understand and share the feelings of another."),
//                     SizedBox(height: 8),
//                     Text("(She showed empathy by listening carefully...)"),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

// Home Screen
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  CircleAvatar(
                    backgroundColor: Color(0xFF636AE8),
                    radius: 28,
                    child: Icon(Icons.person, color: Colors.white, size: 32),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "Hello, User!",
                style: TextStyle(
                  color: Color.fromARGB(255, 62, 62, 62),
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Let's begin your journey to amplify English.",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 18,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        TextField(
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
            contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: Color(0xFF636AE8)),
            ),
          ),
        ),
        const SizedBox(height: 24),
        _buildContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Text(
                    "Word Of The Day!",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 30, 30, 32),
                      letterSpacing: 0.5,
                    ),
                  ),
                  Spacer(),
                  Icon(Icons.favorite_border,
                      color: Color(0xFF636AE8), size: 30),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                "Eloquent",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF636AE8),
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Expressing oneself fluently and clearly.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          "Play and Progress",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Color(0xFF636AE8),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildInteractiveTile(Icons.quiz, "Quizz"),
            _buildInteractiveTile(Icons.flag, "Daily Challenge"),
          ],
        ),
      ],
    );
  }

  Widget _buildContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF636AE8).withOpacity(0.04),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF636AE8).withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildInteractiveTile(IconData icon, String title) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          // ignore: avoid_print
          print("$title tile tapped!");
        },
        child: Container(
          height: 130,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF636AE8), Color(0xFF8B92F0)],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF636AE8).withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 38),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
