
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class LeaderboardScreen extends StatefulWidget {
//   @override
//   _LeaderboardScreenState createState() => _LeaderboardScreenState();
// }

// class _LeaderboardScreenState extends State<LeaderboardScreen> {
//   List<dynamic> leaderboard = [];
//   bool isLoading = true;
//   TextEditingController searchController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     fetchLeaderboard();
//   }

//   Future<void> fetchLeaderboard() async {
//     final url = Uri.parse('https://example.com/api/leaderboard');
//     try {
//       final response = await http.get(url);
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         setState(() {
//           leaderboard = data;
//           isLoading = false;
//         });
//       } else {
//         throw Exception('Failed to load leaderboard');
//       }
//     } catch (e) {
//       print('Error fetching leaderboard: $e');
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text(
//           'Leaderboard',
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         actions: [
//           CircleAvatar(
//             radius: 16,
//             backgroundColor: Colors.grey[200],
//             child: Icon(Icons.person, color: Colors.grey[600]),
//           ),
//           SizedBox(width: 16),
//         ],
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: EdgeInsets.all(16),
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.grey[100],
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: TextField(
//                 controller: searchController,
//                 decoration: InputDecoration(
//                   hintText: 'Search users...',
//                   hintStyle: TextStyle(color: Colors.grey[400]),
//                   prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
//                   border: InputBorder.none,
//                   contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                 ),
//               ),
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Leaderboard',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   'Rankings based on XP Points',
//                   style: TextStyle(
//                     color: Colors.grey[600],
//                     fontSize: 14,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: isLoading
//                 ? Center(child: CircularProgressIndicator())
//                 : ListView.builder(
//               itemCount: leaderboard.length,
//               itemBuilder: (context, index) {
//                 final user = leaderboard[index];
//                 return Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                   child: Row(
//                     children: [
//                       SizedBox(
//                         width: 24,
//                         child: Text(
//                           '${index + 1}',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: index < 3 ? Colors.blue : Colors.grey[600],
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: 12),
//                       CircleAvatar(
//                         radius: 20,
//                         backgroundColor: Colors.grey[200],
//                         backgroundImage: NetworkImage(user['avatar'] ?? ''),
//                         child: user['avatar'] == null
//                             ? Text(
//                           user['username'][0].toUpperCase(),
//                           style: TextStyle(
//                             color: Colors.grey[600],
//                             fontWeight: FontWeight.bold,
//                           ),
//                         )
//                             : null,
//                       ),
//                       SizedBox(width: 12),
//                       Text(
//                         user['username'],
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       Spacer(),
//                       Text(
//                         '${user['xp']} XP',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.grey[800],
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     searchController.dispose();
//     super.dispose();
//   }
// }

// // Mock data for testing
// final mockLeaderboard = [
//   {
//     'username': 'Username1',
//     'xp': 5000,
//     'avatar': null,
//   },
//   {
//     'username': 'Username2',
//     'xp': 4800,
//     'avatar': null,
//   },
//   {
//     'username': 'Username3',
//     'xp': 4700,
//     'avatar': null,
//   },
// ];








import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;
import 'dart:convert';

class LeaderboardScreen extends StatefulWidget {
  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  List<dynamic> leaderboard = [];
  List<dynamic> filteredLeaderboard = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();
  String currentUserName = "John Doe";
  int currentUserRank = 4;
  String currentUserXP = "4500";

  @override
  void initState() {
    super.initState();
    fetchLeaderboard();
    searchController.addListener(_filterLeaderboard);
  }

  Future<void> fetchLeaderboard() async {
    // Simulated API call with mock data
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      leaderboard = mockLeaderboard;
      filteredLeaderboard = List.from(leaderboard);
      isLoading = false;
    });
  }

  void _filterLeaderboard() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredLeaderboard = leaderboard.where((user) {
        final username = user['username'].toString().toLowerCase();
        return username.contains(query);
      }).toList();
    });
  }

  void _showUserProfile() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Your Profile", style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileInfoRow("Name", currentUserName),
            _buildProfileInfoRow("Current Rank", "#$currentUserRank"),
            _buildProfileInfoRow("Total XP", "$currentUserXP XP"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close", style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text("$label: ", style: TextStyle(fontWeight: FontWeight.w500)),
          SizedBox(width: 10),
          Text(value, style: TextStyle(color: Colors.grey[700])),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Leaderboard',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: _showUserProfile,
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey[200],
              child: Icon(Icons.person, color: Colors.grey[600]),
            ),
          ),
          SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search users...',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Leaderboard',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Rankings based on XP Points',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: filteredLeaderboard.length,
                    itemBuilder: (context, index) {
                      final user = filteredLeaderboard[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 24,
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: index < 3 ? Colors.blue : Colors.grey[600],
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.grey[200],
                              backgroundImage: NetworkImage(user['avatar'] ?? ''),
                              child: user['avatar'] == null
                                  ? Text(
                                      user['username'][0].toUpperCase(),
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : null,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                user['username'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Text(
                              '${user['xp']} XP',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    searchController.removeListener(_filterLeaderboard);
    searchController.dispose();
    super.dispose();
  }
}

final mockLeaderboard = [
  {'username': 'JohnDoe', 'xp': 5000, 'avatar': null},
  {'username': 'SarahSmith', 'xp': 4800, 'avatar': null},
  {'username': 'MikeJohnson', 'xp': 4700, 'avatar': null},
  {'username': 'EmmaWilson', 'xp': 4600, 'avatar': null},
  {'username': 'AlexBrown', 'xp': 4500, 'avatar': null},
];