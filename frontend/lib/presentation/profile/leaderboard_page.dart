import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';

// Create ApiConstants class
class ApiConstants {
  static const String baseUrl = 'http://192.168.146.167'; 
}

class LeaderboardScreen extends StatefulWidget {
  // Add key parameter
  const LeaderboardScreen({Key? key}) : super(key: key);

  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  List<dynamic> leaderboard = [];
  bool isLoading = true;
  bool isError = false;
  TextEditingController searchController = TextEditingController();
  int currentUserRank = 0;
  int currentUserXp = 0;

  List<dynamic> get filteredLeaderboard {
    final query = searchController.text.toLowerCase();
    return leaderboard.where((user) => 
      user['username'].toLowerCase().contains(query)
    ).toList();
  }

  @override
  void initState() {
    super.initState();
    fetchLeaderboard();
  }

  Future<void> fetchLeaderboard() async {
    final url = Uri.parse('${ApiConstants.baseUrl}/api/leaderboard');

    //try {
      // Get authentication token if needed
      //final token = await _getAuthToken();
      
      // Use the token in headers if needed
      //final headers = token.isNotEmpty ? {'Authorization': 'Bearer $token'} : {};
      
      //final response = await http.get(url, headers: headers);
      
    //   if (response.statusCode == 200) {
    //     final data = json.decode(response.body);
    //     setState(() {
    //       leaderboard = data;
    //       isLoading = false;
    //       isError = false;
    //     });
        
    //     // Check if current user exists in leaderboard
    //     _checkCurrentUserRank();
    //   } else {
    //     throw Exception('Failed to load leaderboard');
    //   }
    // } catch (e) {
    //   print("Error fetching leaderboard: $e");
    //   setState(() {
    //     isLoading = false;
    //     isError = true;
    //   });
   // }
  }

  // Add this method to check user rank
  void _checkCurrentUserRank() {
    String currentUserEmail = FirebaseAuth.instance.currentUser?.email ?? "";
    
    for (int i = 0; i < leaderboard.length; i++) {
      if (leaderboard[i]['email'] == currentUserEmail) {
        setState(() {
          currentUserRank = i + 1;
          currentUserXp = leaderboard[i]['xp'];
        });
        break;
      }
    }
  }

  // Fix return type issue
//   Future<String> _getAuthToken() async {
//   User? user = FirebaseAuth.instance.currentUser;
//   if (user != null) {
//     return await user.getIdToken() ?? ''; // Return empty string if null
//   }
//   return '';
// }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 152, 79, 247),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Leaderboard',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search users...',
                  prefixIcon: Icon(Icons.search, color: Colors.blueGrey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
          ),
          Flexible(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : isError
                    ? Center(
                        child: Text(
                          'Failed to load leaderboard. Please try again later.',
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      )
                    : Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 208, 179, 252),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildPodium(leaderboard.length > 1 ? leaderboard[1] : null, 2, 'assets/images/profiles/silver.jpg'),
                                    _buildPodium(leaderboard.isNotEmpty ? leaderboard[0] : null, 1, 'assets/images/profiles/gold.jpg'),
                                    _buildPodium(leaderboard.length > 2 ? leaderboard[2] : null, 3, 'assets/images/profiles/bronze.jpg'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            child: ListView.builder(
                              itemCount: filteredLeaderboard.length > 3 ? filteredLeaderboard.length - 3 : 0,
                              itemBuilder: (context, index) {
                                final adjustedIndex = index + 3;
                                
                                if (adjustedIndex >= filteredLeaderboard.length) {
                                  return SizedBox.shrink();
                                }
                                
                                final user = filteredLeaderboard[adjustedIndex];
                                
                                return Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border(
                                      bottom: BorderSide(color: Colors.grey.shade200, width: 1),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      // Rank with circle
                                      Container(
                                        width: 36,
                                        height: 36,
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade100,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Text(
                                            '#${adjustedIndex + 1}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue.shade800,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 16),
                                      // User info
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              user['username'],
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              '${user['xp']} XP',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey[700],
                                              ),
                                            ),
                                          ],
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
          ),
        ],
      ),
    );
  }

  Widget _buildPodium(Map<String, dynamic>? user, int rank, String medalImage) {
    final username = user?['username'] ?? 'N/A';
    final xp = user?['xp']?.toString() ?? '0';
    
    // Determine rank text for the badge
    String rankText;
    switch (rank) {
      case 1:
        rankText = "1st";
        break;
      case 2:
        rankText = "2nd";
        break;
      case 3:
        rankText = "3rd";
        break;
      default:
        rankText = rank.toString();
    }

    return Column(
      children: [
        // Medal container with badge
        Stack(
          alignment: Alignment.center,
          children: [
            // Main medal image - no white circle
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(medalImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            
            // Rank badge
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    rankText,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Text(
          username, 
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          '$xp XP', 
          style: TextStyle(color: Colors.grey[700]),
        ),
      ],
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}