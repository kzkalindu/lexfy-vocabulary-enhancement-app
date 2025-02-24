// import 'package:flutter/material.dart';

// class BottomNavBar extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BottomNavigationBar(
//       key: Key('bottomNavBar'),
//       items: [
//         BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//         BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Talk with Lexfy"),
//         BottomNavigationBarItem(icon: Icon(Icons.school), label: "Learnings"),
//         BottomNavigationBarItem(icon: Icon(Icons.quiz), label: "Quizzes"),
//         BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';

// Bottom navigation bar widget
class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

// State class for BottomNavBar
class _BottomNavBarState extends State<BottomNavBar> {
  // Currently selected index
  int _selectedIndex = 0;

  // Method to handle item tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10), // Margin around the container
      padding: const EdgeInsets.symmetric(
          horizontal: 10, vertical: 2), // Padding inside the container
      decoration: _buildBoxDecoration(), // Decoration for the container
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50), // Rounded corners
        child: _buildBottomNavigationBar(), // Build the bottom navigation bar
      ),
    );
  }

  // Method to build the box decoration
  BoxDecoration _buildBoxDecoration() {
    return BoxDecoration(
      color: const Color.fromARGB(255, 255, 255, 255), // Background color
      borderRadius: BorderRadius.circular(50), // Rounded corners
      border:
          Border.all(color: Colors.deepPurple, width: 2), // Border properties
      boxShadow: [
        BoxShadow(
          color: const Color.fromARGB(255, 255, 255, 255)
              .withOpacity(0.3), // Shadow color
          blurRadius: 5, // Blur radius for the shadow
          offset: const Offset(0, -4), // Offset for the shadow
        ),
      ],
    );
  }

  // Method to build the bottom navigation bar
  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      elevation: 0, // No elevation
      backgroundColor: const Color.fromARGB(0, 43, 43, 43), // Background color
      type: BottomNavigationBarType.fixed, // Fixed type
      items: _buildBottomNavigationBarItems(), // Navigation bar items
      currentIndex: _selectedIndex, // Current selected index
      selectedItemColor: Colors.deepPurple, // Color for selected item
      unselectedItemColor: Colors.grey, // Color for unselected items
      onTap: _onItemTapped, // Tap handler
    );
  }

  // Method to build the items for the bottom navigation bar
  List<BottomNavigationBarItem> _buildBottomNavigationBarItems() {
    return const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.home, size: 20), // Home icon
        label: 'Home', // Home label
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.chat_bubble_outline, size: 20), // Chat icon
        label: 'Talk with Lexfy', // Chat label
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.book, size: 20), // Book icon
        label: 'Learnings', // Learnings label
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.quiz, size: 20), // Quiz icon
        label: 'Quizzes', // Quizzes label
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person_outline, size: 20), // Profile icon
        label: 'Profile', // Profile label
      ),
    ];
  }
}
