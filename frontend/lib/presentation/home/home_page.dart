// import 'package:flutter/material.dart';
//
// // Home Screen widget that serves as the main interface for the application
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// // State class for HomeScreen
// class _HomeScreenState extends State<HomeScreen> {
//   // Controllers for managing input fields
//   final TextEditingController _searchController = TextEditingController();
//
//   // State variables to hold word details
//   String _word = ''; // Default word to display
//   String _definition = ''; // Default definition
//   String _example = ''; // Default example
//
//   // List to hold multiple words and their details
//   List<Map<String, String>> _wordList = List.generate(
//       25,
//       (index) => {
//             'word': 'Word ${index + 1}',
//             'definition': 'Definition of word ${index + 1}',
//             'example': 'Example sentence for word ${index + 1}.'
//           });
//
//   // Method to search for a word and update the state
//   void _searchWord(String word) {
//     setState(() {
//       _word = word; // Update the displayed word
//       _definition =
//           'Definition will be shown here'; // Placeholder for definition
//       _example =
//           'Example sentence will be shown here'; // Placeholder for example
//     });
//     _showWordDetails(); // Show the word details popup
//   }
//
//   // Method to show a dialog with the word details
//   void _showWordDetails() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(_word),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text('(n.) $_definition',
//                   style: const TextStyle(fontStyle: FontStyle.italic)),
//               const SizedBox(height: 12),
//               Text('Example: $_example',
//                   style: TextStyle(color: Colors.grey[600], fontSize: 14)),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//               child: const Text('Close'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   // UI Component for the search bar
//   Widget _buildSearchBar() {
//     return TextField(
//       controller: _searchController, // Controller for the text field
//       decoration: InputDecoration(
//         hintText: "Search for Words…", // Placeholder text
//         hintStyle: TextStyle(
//             color: const Color.fromARGB(
//                 255, 150, 150, 150)), // Style for hint text
//         prefixIcon:
//             const Icon(Icons.search, color: Color(0xFF636AE8)), // Search icon
//         filled: true, // Fill the background
//         fillColor: Colors.grey[50], // Background color
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(50), // Rounded corners
//           borderSide: BorderSide.none, // No border
//         ),
//         contentPadding: const EdgeInsets.symmetric(
//             vertical: 10, horizontal: 20), // Padding inside the text field
//         enabledBorder: OutlineInputBorder(
//           borderRadius:
//               BorderRadius.circular(50), // Rounded corners for enabled state
//           borderSide: BorderSide(color: Colors.grey[200]!),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius:
//               BorderRadius.circular(50), // Rounded corners for focused state
//           borderSide: const BorderSide(
//               color: Color(0xFF636AE8)), // Border color when focused
//         ),
//       ),
//       onSubmitted: (value) {
//         if (value.isNotEmpty) {
//           _searchWord(value); // Call search method if input is not empty
//         }
//       },
//     );
//   }
//
//   // UI Component for action buttons to navigate to different pages
//   Widget _buildActionButtons() {
//     return Row(
//       mainAxisAlignment:
//           MainAxisAlignment.spaceEvenly, // Evenly distribute buttons
//       children: [
//         _buildActionButtonContainer(
//             "Learnings", '/daily_challenge_screen'), // Button for Learnings
//         _buildActionButtonContainer(
//             "Quizzes", '/quizzes_screen'), // Button for Quizzes
//         _buildActionButtonContainer(
//             "Talk with Lexfy", '/ai_coach'), // Button for AI Coach
//       ],
//     );
//   }
//
//   // Helper method to create a button container
//   Widget _buildActionButtonContainer(String label, String route) {
//     return Container(
//       margin: const EdgeInsets.symmetric(
//           horizontal: 8.0), // Set margin for the button
//       child: _buildActionButton(label,
//           () => Navigator.pushNamed(context, route)), // Create action button
//     );
//   }
//
//   // UI Component for individual action buttons
//   Widget _buildActionButton(String label, VoidCallback onPressed) {
//     return ElevatedButton(
//       onPressed: onPressed, // Action to perform on button press
//       style: ElevatedButton.styleFrom(
//         backgroundColor: const Color(0xFF636AE8), // Button background color
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(30), // Rounded corners
//         ),
//         padding: const EdgeInsets.symmetric(
//             horizontal: 18, vertical: 12), // Padding inside the button
//       ),
//       child: Text(label,
//           style: const TextStyle(fontSize: 15)), // Label for the button
//     );
//   }
//
//   // UI Component to display the searched word and its details
//   Widget _buildWordDisplay() {
//     return Container(
//       padding: const EdgeInsets.all(16.0), // Padding around the container
//       decoration: BoxDecoration(
//         color: const Color.fromARGB(255, 220, 220, 220), // Background color
//         borderRadius: BorderRadius.circular(12), // Rounded corners
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1), // Shadow color
//             spreadRadius: 2, // Spread radius of the shadow
//             blurRadius: 5, // Blur radius of the shadow
//             offset: const Offset(0, 3), // Offset of the shadow
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Text(_word,
//               style: const TextStyle(
//                   fontSize: 25,
//                   fontWeight: FontWeight.bold)), // Display the word
//           const SizedBox(height: 8), // Space between elements
//           Text('(n.) $_definition',
//               style: const TextStyle(
//                   fontStyle: FontStyle.italic)), // Display the definition
//           const SizedBox(height: 12), // Space between elements
//           Text('Example: $_example',
//               style: TextStyle(
//                   color: Colors.grey[600],
//                   fontSize: 14)), // Display the example
//         ],
//       ),
//     );
//   }
//
//   // UI Component to display the list of 25 words and their details
//   Widget _buildWordListDisplay() {
//     return ListView.builder(
//       shrinkWrap: true,
//       physics:
//           const NeverScrollableScrollPhysics(), // Disable scrolling for this list
//       itemCount: _wordList.length, // Number of items in the list
//       itemBuilder: (context, index) {
//         return Container(
//           padding: const EdgeInsets.all(16.0), // Padding around each word item
//           margin:
//               const EdgeInsets.symmetric(vertical: 4.0), // Margin between items
//           decoration: BoxDecoration(
//             color: const Color.fromARGB(
//                 255, 220, 220, 220), // Background color for each item
//             borderRadius: BorderRadius.circular(12), // Rounded corners
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.1), // Shadow color
//                 spreadRadius: 2, // Spread radius of the shadow
//                 blurRadius: 5, // Blur radius of the shadow
//                 offset: const Offset(0, 3), // Offset of the shadow
//               ),
//             ],
//           ),
//           child: Column(
//             crossAxisAlignment:
//                 CrossAxisAlignment.start, // Align text to the start
//             children: [
//               Text(_wordList[index]['word']!,
//                   style: const TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold)), // Display the word
//               const SizedBox(height: 4), // Space between elements
//               Text('(n.) ${_wordList[index]['definition']}',
//                   style: const TextStyle(
//                       fontStyle: FontStyle.italic)), // Display the definition
//               const SizedBox(height: 4), // Space between elements
//               Text('Example: ${_wordList[index]['example']}',
//                   style: TextStyle(
//                       color: Colors.grey[600],
//                       fontSize: 12)), // Display the example
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   // Build method to construct the UI
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(
//           vertical: 24.0), // Padding for the main column
//       child: Column(
//         children: [
//           _buildSearchBar(), // Add search bar
//           const SizedBox(height: 24), // Space between elements
//           _buildActionButtons(), // Add action buttons
//           const SizedBox(height: 24), // Space between elements
//           _buildWordListDisplay(), // Add word list display
//         ],
//       ),
//     );
//   }
// }
//

// Home Screen with Integrated Bottom Navigation Bar

import 'package:flutter/material.dart';

// Home Screen widget that serves as the main interface for the application
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// State class for HomeScreen
class _HomeScreenState extends State<HomeScreen> {
  // Controllers for managing input fields
  final TextEditingController _searchController = TextEditingController();

  // State variables to hold word details
  String _word = '';
  String _definition = '';
  String _example = '';

  // List to hold multiple words and their details
  List<Map<String, String>> _wordList = List.generate(
      25,
          (index) => {
        'word': 'Word ${index + 1}',
        'definition': 'Definition of word ${index + 1}',
        'example': 'Example sentence for word ${index + 1}.'
      });

  // Method to search for a word and update the state
  void _searchWord(String word) {
    setState(() {
      _word = word;
      _definition = 'Definition will be shown here';
      _example = 'Example sentence will be shown here';
    });
    _showWordDetails();
  }

  // Method to show a dialog with the word details
  void _showWordDetails() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(_word),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('(n.) $_definition', style: const TextStyle(fontStyle: FontStyle.italic)),
              const SizedBox(height: 12),
              Text('Example: $_example', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // UI Component for the search bar
  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: "Search for Words…",
        hintStyle: TextStyle(
            color: const Color.fromARGB(255, 150, 150, 150)),
        prefixIcon:
        const Icon(Icons.search, color: Color(0xFF636AE8)),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
            vertical: 10, horizontal: 20),
        enabledBorder: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(50),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(50),
          borderSide: const BorderSide(
              color: Color(0xFF636AE8)),
        ),
      ),
      onSubmitted: (value) {
        if (value.isNotEmpty) {
          _searchWord(value);
        }
      },
    );
  }

  // UI Component for action buttons to navigate to different pages
  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment:
      MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButtonContainer(
            "Learnings", '/daily_challenge_screen'),
        _buildActionButtonContainer(
            "Quizzes", '/quizzes_screen'),
        _buildActionButtonContainer(
            "Talk with Lexfy", '/ai_coach'),
      ],
    );
  }

  // Helper method to create a button container
  Widget _buildActionButtonContainer(String label, String route) {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: 8.0),
      child: _buildActionButton(label,
              () => Navigator.pushNamed(context, route)),
    );
  }

  // UI Component for individual action buttons
  Widget _buildActionButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF636AE8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(
            horizontal: 18, vertical: 12),
      ),
      child: Text(label,
          style: const TextStyle(fontSize: 15)),
    );
  }

  // UI Component to display the searched word and its details
  Widget _buildWordDisplay() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 220, 220, 220),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(_word,
              style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('(n.) $_definition',
              style: const TextStyle(
                  fontStyle: FontStyle.italic)),
          const SizedBox(height: 12),
          Text('Example: $_example',
              style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14)),
        ],
      ),
    );
  }

  // UI Component to display the list of 25 words and their details
  Widget _buildWordListDisplay() {
    return ListView.builder(
      shrinkWrap: true,
      physics:
      const NeverScrollableScrollPhysics(),
      itemCount: _wordList.length,
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          margin:
          const EdgeInsets.symmetric(vertical: 4.0),
          decoration: BoxDecoration(
            color: const Color.fromARGB(
                255, 220, 220, 220),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(_wordList[index]['word']!,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('(n.) ${_wordList[index]['definition']}',
                  style: const TextStyle(
                      fontStyle: FontStyle.italic)),
              const SizedBox(height: 4),
              Text('Example: ${_wordList[index]['example']}',
                  style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12)),
            ],
          ),
        );
      },
    );
  }

  // Build method to construct the UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: 24.0),
        child: Column(
          children: [
            _buildSearchBar(),
            const SizedBox(height: 24),
            _buildActionButtons(),
            const SizedBox(height: 24),
            _buildWordListDisplay(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}

// Bottom navigation bar widget
class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

// State class for BottomNavBar
class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.deepPurple,
      unselectedItemColor: Colors.grey,
      onTap: _onItemTapped,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Talk with Lexfy'),
        BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Learnings'),
        BottomNavigationBarItem(icon: Icon(Icons.quiz), label: 'Quizzes'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
      ],
    );
  }
}

