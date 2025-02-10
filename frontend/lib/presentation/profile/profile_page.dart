// import 'package:flutter/material.dart';
// import 'Leaderboard_page.dart'; // Importing LeaderboardScreen
// import 'package:fl_chart/fl_chart.dart';

// class ProfileScreen extends StatelessWidget {
//   final int selectedIndex;
//   final Function(int) onItemTapped;

//   ProfileScreen({required this.selectedIndex, required this.onItemTapped});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               SizedBox(height: 40),
//               _buildHeader(),
//               SizedBox(height: 20),
//               _buildProfileSection(),
//               SizedBox(height: 20),
//               _buildUserStatistics(),
//               SizedBox(height: 20),
//               _buildRecentActivity(),
//               SizedBox(height: 20),
//               _buildLeaderboardButton(context),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: _buildBottomNavigationBar(),
//     );
//   }

//   Widget _buildHeader() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Row(
//           children: [
//             Icon(Icons.lightbulb, color: Color(0xFF636AE8)),
//             SizedBox(width: 5),
//             Text(
//               'Lexfy',
//               style: TextStyle(
//                 fontSize: 28,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xFF636AE8),
//               ),
//             ),
//           ],
//         ),
//         Row(
//           children: [
//             Icon(Icons.notifications_none, size: 28),
//             SizedBox(width: 10),
//             Icon(Icons.settings, size: 28),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildProfileSection() {
//     return Column(
//       children: [
//         CircleAvatar(
//           radius: 50,
//           backgroundImage: AssetImage('assets/profile.jpg'),
//         ),
//         SizedBox(height: 10),
//         Text(
//           'Hello! User',
//           style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//         ),
//         SizedBox(height: 5),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.emoji_events, size: 18),
//             SizedBox(width: 5),
//             Text('World Rank 1000'),
//             SizedBox(width: 15),
//             Icon(Icons.star, size: 18),
//             SizedBox(width: 5),
//             Text('Total XP 143'),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildUserStatistics() {
//     return Container(
//       padding: EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey.shade300),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'User Statistics',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 10),
//           SizedBox(
//             height: 150,  // Adjust the size of the pie chart
//             child: PieChart(
//               PieChartData(
//                 sections: [
//                   PieChartSectionData(
//                     color: Colors.blue,
//                     value: 40,
//                     title: 'Writing\n40%',
//                     radius: 50,
//                     titleStyle: TextStyle(color: Colors.white, fontSize: 12),
//                   ),
//                   PieChartSectionData(
//                     color: Colors.green,
//                     value: 35,
//                     title: 'Listening\n35%',
//                     radius: 50,
//                     titleStyle: TextStyle(color: Colors.white, fontSize: 12),
//                   ),
//                   PieChartSectionData(
//                     color: Colors.orange,
//                     value: 25,
//                     title: 'Speaking\n25%',
//                     radius: 50,
//                     titleStyle: TextStyle(color: Colors.white, fontSize: 12),
//                   ),
//                 ],
//                 sectionsSpace: 2,
//                 centerSpaceRadius: 30,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildRecentActivity() {
//     return Container(
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         border: Border.all(color: Color(0xFF636AE8)),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Recent Activity',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Colors.black,
//             ),
//           ),
//           SizedBox(height: 10),
//           Text('Completed Quiz: Vocabulary Basics', style: TextStyle(fontSize: 16)),
//           Text('5 hours ago', style: TextStyle(color: Colors.grey[700])),
//           SizedBox(height: 10),
//           Text('Achieved Milestone: 100 Words', style: TextStyle(fontSize: 16)),
//           Text('1 day ago', style: TextStyle(color: Colors.grey[700])),
//         ],
//       ),
//     );
//   }

//   Widget _buildLeaderboardButton(BuildContext context) {
//     return ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Color(0xFF636AE8),
//         padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
//       ),
//       onPressed: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => LeaderboardScreen()),
//         );
//       },
//       child: Text('View Leaderboard', style: TextStyle(color: Colors.white)),
//     );
//   }

//   Widget _buildBottomNavigationBar() {
//     return BottomNavigationBar(
//       currentIndex: selectedIndex, // Highlight selected tab
//       selectedItemColor: Color(0xFF636AE8), // Highlighted tab color
//       unselectedItemColor: Colors.grey, // Default tab color
//       showUnselectedLabels: true,
//       onTap: (index) {
//         if (index != selectedIndex) {
//           onItemTapped(index); // Call navigation function
//         }
//       },
//       items: [
//         BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//         BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Word Category'),
//         BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Daily Challenge'),
//         BottomNavigationBarItem(icon: Icon(Icons.quiz), label: 'Quizzes'),
//         BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'), // Profile icon
//       ],
//     );
//   }
// }










import 'package:flutter/material.dart';
import 'Leaderboard_page.dart'; // Importing LeaderboardScreen
import 'package:fl_chart/fl_chart.dart';

class ProfileScreen extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  // Adding user XP data
  final int writingXP;
  final int listeningXP;
  final int speakingXP;

  ProfileScreen({
    required this.selectedIndex,
    required this.onItemTapped,
    required this.writingXP,
    required this.listeningXP,
    required this.speakingXP,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              _buildHeader(),
              SizedBox(height: 30), // Increased gap
              _buildProfileSection(),
              SizedBox(height: 30), // Increased gap
              _buildUserStatistics(),
              SizedBox(height: 30), // Increased gap
              _buildRecentActivity(),
              SizedBox(height: 30), // Increased gap
              _buildLeaderboardButton(context),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(Icons.lightbulb, color: Color(0xFF636AE8)),
            SizedBox(width: 5),
            Text(
              'Lexfy',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF636AE8),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Icon(Icons.notifications_none, size: 28),
            SizedBox(width: 10),
            Icon(Icons.settings, size: 28),
          ],
        ),
      ],
    );
  }

  Widget _buildProfileSection() {
    int totalXP = writingXP + listeningXP + speakingXP;
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.grey.shade300, blurRadius: 5, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage('assets/profile.jpg'),
          ),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello! User',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Icon(Icons.emoji_events, size: 18, color: Colors.orange),
                  SizedBox(width: 5),
                  Text('World Rank 1000'),
                  SizedBox(width: 15),
                  Icon(Icons.star, size: 18, color: Colors.yellow[700]),
                  SizedBox(width: 5),
                  Text('Total XP $totalXP'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserStatistics() {
    int totalXP = writingXP + listeningXP + speakingXP;

    double writingPercentage = totalXP == 0 ? 0 : (writingXP / totalXP) * 100;
    double listeningPercentage = totalXP == 0 ? 0 : (listeningXP / totalXP) * 100;
    double speakingPercentage = totalXP == 0 ? 0 : (speakingXP / totalXP) * 100;

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'User Statistics',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 15), // Increased gap
          SizedBox(
            height: 150,
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    color: Colors.lightBlue,
                    value: writingPercentage,
                    title: 'Writing\n${writingPercentage.toStringAsFixed(1)}%',
                    radius: 50,
                    titleStyle: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  PieChartSectionData(
                    color: Colors.purpleAccent,
                    value: listeningPercentage,
                    title: 'Listening\n${listeningPercentage.toStringAsFixed(1)}%',
                    radius: 50,
                    titleStyle: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  PieChartSectionData(
                    color: Colors.purple,
                    value: speakingPercentage,
                    title: 'Speaking\n${speakingPercentage.toStringAsFixed(1)}%',
                    radius: 50,
                    titleStyle: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
                sectionsSpace: 2,
                centerSpaceRadius: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF636AE8)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Activity',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 15), // Increased gap
          Text('Completed Quiz: Vocabulary Basics', style: TextStyle(fontSize: 16)),
          Text('5 hours ago', style: TextStyle(color: Colors.grey[700])),
          SizedBox(height: 15), // Increased gap
          Text('Achieved Milestone: 100 Words', style: TextStyle(fontSize: 16)),
          Text('1 day ago', style: TextStyle(color: Colors.grey[700])),
        ],
      ),
    );
  }

  Widget _buildLeaderboardButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF636AE8),
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LeaderboardScreen()),
        );
      },
      child: Text('View Leaderboard', style: TextStyle(color: Colors.white)),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      selectedItemColor: Color(0xFF636AE8),
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      onTap: (index) {
        if (index != selectedIndex) {
          onItemTapped(index);
        }
      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Word Category'),
        BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Daily Challenge'),
        BottomNavigationBarItem(icon: Icon(Icons.quiz), label: 'Quizzes'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}
