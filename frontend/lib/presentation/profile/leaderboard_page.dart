// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert'; // For JSON parsing
// import 'package:shared_preferences/shared_preferences.dart';
//
// class LeaderboardScreen extends StatefulWidget {
//   final String? currentUserName;
//   final int? currentUserXp;
//   final String? currentUserAvatar;
//   final String? currentUserRank;
//   final String? currentUserLevel;
//
//   const LeaderboardScreen({
//     Key? key,
//     this.currentUserName,
//     this.currentUserXp,
//     this.currentUserAvatar,
//     this.currentUserRank,
//     this.currentUserLevel,
//   }) : super(key: key);
//
//   @override
//   _LeaderboardScreenState createState() => _LeaderboardScreenState();
// }
//
// class _LeaderboardScreenState extends State<LeaderboardScreen> {
//   List<dynamic> leaderboard = [];
//   bool isLoading = true;
//   bool isError = false;
//   TextEditingController searchController = TextEditingController();
//   int currentUserRank = 0;
//   int currentUserXp = 0;
//   String currentUserName = "User";
//   String currentUserAvatar = "assets/images/avatars/avatar1.png";
//
//   // Medal image assets
//   final String goldMedalAsset = "assets/images/profiles/gold.jpg";
//   final String silverMedalAsset = "assets/images/profiles/silver.jpg";
//   final String bronzeMedalAsset = "assets/images/profiles/bronze.jpg";
//
//   // Theme color
//   final Color primaryColor = const Color(0xFF636AE8);
//
//   // Backend URL (updated to HTTPS)
//   final String backendUrl = "https://lexfy-vocabulary-enhancement-app.onrender.com";
//
//   List<dynamic> get filteredLeaderboard {
//     final query = searchController.text.toLowerCase();
//     return leaderboard
//         .where((user) => user['username'].toLowerCase().contains(query))
//         .toList();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     // Use passed data if available
//     if (widget.currentUserName != null) {
//       currentUserName = widget.currentUserName!;
//     }
//     if (widget.currentUserXp != null) {
//       currentUserXp = widget.currentUserXp!;
//     }
//     if (widget.currentUserAvatar != null) {
//       currentUserAvatar = widget.currentUserAvatar!;
//     }
//
//     _initUserAndFetchLeaderboard();
//     _loadSelectedAvatar();
//   }
//
//   Future<void> _initUserAndFetchLeaderboard() async {
//     try {
//       await fetchLeaderboard();
//     } catch (e) {
//       print("Error initializing user: $e");
//       setState(() {
//         isError = true;
//         isLoading = false;
//       });
//     }
//   }
//
//   Future<void> _loadSelectedAvatar() async {
//     if (widget.currentUserAvatar == null) {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       setState(() {
//         currentUserAvatar =
//             prefs.getString('selectedAvatar') ?? "assets/images/avatars/avatar1.png";
//       });
//     }
//   }
//
//   Future<String> _getCurrentUserEmail() async {
//     // Replace with your actual method to get the current user's email
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString('userEmail') ?? ''; // Default to empty if not found
//   }
//
//   Future<void> fetchLeaderboard() async {
//     try {
//       setState(() {
//         isLoading = true;
//         isError = false;
//       });
//
//       // Add authentication token if required by your backend
//       final String? token = await _getAuthToken(); // Implement this
//       final Map<String, String> headers = token != null
//           ? {"Authorization": "Bearer $token"}
//           : {};
//
//       final response = await http.get(
//         Uri.parse('$backendUrl/api/leaderboard'),
//         headers: headers,
//       );
//
//       print("Response status: ${response.statusCode}");
//       print("Response body: ${response.body}");
//
//       if (response.statusCode == 200) {
//         // Parse JSON response - flexible to handle both object and array
//         final dynamic responseData = json.decode(response.body);
//         List<dynamic> leaderboardData;
//
//         if (responseData is Map<String, dynamic> && responseData.containsKey('leaderboard')) {
//           leaderboardData = responseData['leaderboard'] ?? [];
//         } else if (responseData is List) {
//           leaderboardData = responseData;
//         } else {
//           throw Exception('Unexpected response format');
//         }
//
//         setState(() {
//           leaderboard = leaderboardData;
//           print("Leaderboard data: $leaderboard");
//           isLoading = false;
//           _checkCurrentUserDetails();
//         });
//       } else {
//         throw Exception('Failed to load leaderboard: ${response.statusCode}');
//       }
//     } catch (e) {
//       print("Error fetching leaderboard: $e");
//       setState(() {
//         isLoading = false;
//         isError = true;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error fetching leaderboard: $e')),
//       );
//     }
//   }
//
//   Future<String?> _getAuthToken() async {
//     // Implement this to retrieve the auth token (e.g., from SharedPreferences)
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString('authToken'); // Return null if no token
//   }
//
//   void _checkCurrentUserDetails() async {
//     final currentUserEmail = await _getCurrentUserEmail();
//
//     for (int i = 0; i < leaderboard.length; i++) {
//       if (leaderboard[i]['email'] == currentUserEmail) {
//         setState(() {
//           currentUserRank = i + 1;
//           if (widget.currentUserXp == null) {
//             currentUserXp = leaderboard[i]['xp'] ?? 0;
//           }
//           if (widget.currentUserName == null) {
//             currentUserName = leaderboard[i]['username'] ?? "User";
//           }
//         });
//         break;
//       }
//     }
//   }
//
//   Future<void> _refreshLeaderboard() async {
//     setState(() {
//       isLoading = true;
//       isError = false;
//     });
//     await fetchLeaderboard();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F0FA),
//       appBar: AppBar(
//         backgroundColor: primaryColor,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text(
//           'Leaderboard',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh, color: Colors.white),
//             onPressed: _refreshLeaderboard,
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.grey[200],
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: TextField(
//                 controller: searchController,
//                 decoration: InputDecoration(
//                   hintText: 'Search users...',
//                   prefixIcon: Icon(Icons.search, color: primaryColor.withOpacity(0.6)),
//                   border: InputBorder.none,
//                   contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                 ),
//                 onChanged: (value) {
//                   setState(() {});
//                 },
//               ),
//             ),
//           ),
//           Expanded(
//             child: RefreshIndicator(
//               onRefresh: _refreshLeaderboard,
//               color: primaryColor,
//               child: isLoading
//                   ? Center(child: CircularProgressIndicator(color: primaryColor))
//                   : isError
//                       ? Center(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               const Text(
//                                 'Failed to load leaderboard.',
//                                 style: TextStyle(color: Colors.red, fontSize: 16),
//                               ),
//                               const SizedBox(height: 16),
//                               ElevatedButton(
//                                 onPressed: _refreshLeaderboard,
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: primaryColor,
//                                 ),
//                                 child: const Text('Try Again'),
//                               ),
//                             ],
//                           ),
//                         )
//                       : filteredLeaderboard.isEmpty
//                           ? const Center(
//                               child: Text(
//                                 'No users found.',
//                                 style: TextStyle(fontSize: 16),
//                               ),
//                             )
//                           : _buildLeaderboardContent(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildLeaderboardContent() {
//     return ListView(
//       padding: const EdgeInsets.only(bottom: 16), // Corrected from 'custom' to 'bottom'
//       children: [
//         if (leaderboard.isNotEmpty)
//           Container(
//             padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
//             margin: const EdgeInsets.symmetric(horizontal: 16),
//             decoration: BoxDecoration(
//               color: primaryColor.withOpacity(0.15),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 _buildLinearPodium(leaderboard.length > 1 ? leaderboard[1] : null, 2, silverMedalAsset),
//                 _buildLinearPodium(leaderboard.isNotEmpty ? leaderboard[0] : null, 1, goldMedalAsset, isFirst: true),
//                 _buildLinearPodium(leaderboard.length > 2 ? leaderboard[2] : null, 3, bronzeMedalAsset),
//               ],
//             ),
//           ),
//         const SizedBox(height: 16),
//         ...List.generate(
//           filteredLeaderboard.length > 3 ? filteredLeaderboard.length - 3 : 0,
//           (index) {
//             final userIndex = index + 3;
//             final position = userIndex + 1;
//             final user = filteredLeaderboard[userIndex];
//             final isCurrentUser = user['email'] == _getCurrentUserEmail(); // Async call needs handling
//
//             return LeaderboardItem(
//               position: position,
//               user: user,
//               isCurrentUser: isCurrentUser,
//               primaryColor: primaryColor,
//             );
//           },
//         ),
//       ],
//     );
//   }
//
//   Widget _buildLinearPodium(Map<String, dynamic>? user, int rank, String medalAsset, {bool isFirst = false}) {
//     if (user == null) {
//       return const SizedBox.shrink();
//     }
//
//     final username = user['username'] ?? '';
//     final xp = user['xp']?.toString() ?? '0';
//     final isCurrentUser = user['email'] == _getCurrentUserEmail(); // Async call needs handling
//
//     final Color medalColor = rank == 1
//         ? Colors.amber
//         : rank == 2
//             ? Colors.grey.shade400
//             : Colors.brown.shade300;
//
//     final String badgeText = rank == 1 ? "1st" : rank == 2 ? "2nd" : "3rd";
//
//     return Expanded(
//       child: Column(
//         children: [
//           Container(
//             width: 40,
//             height: 40,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               border: Border.all(
//                 color: medalColor,
//                 width: 3,
//               ),
//             ),
//             child: Center(
//               child: Container(
//                 width: 30,
//                 height: 30,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: medalColor,
//                   border: Border.all(color: Colors.white, width: 1),
//                   image: DecorationImage(
//                     image: AssetImage(medalAsset),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 child: Center(
//                   child: Text(
//                     badgeText,
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 10,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 12),
//           Text(
//             username,
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.bold,
//               color: isCurrentUser ? primaryColor : Colors.black,
//             ),
//             overflow: TextOverflow.ellipsis,
//             textAlign: TextAlign.center,
//             maxLines: 1,
//           ),
//           Text(
//             '$xp XP',
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.bold,
//               color: primaryColor,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     searchController.dispose();
//     super.dispose();
//   }
// }
//
// class LeaderboardItem extends StatelessWidget {
//   final int position;
//   final Map<String, dynamic> user;
//   final bool isCurrentUser;
//   final Color primaryColor;
//
//   const LeaderboardItem({
//     Key? key,
//     required this.position,
//     required this.user,
//     required this.isCurrentUser,
//     required this.primaryColor,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//       decoration: BoxDecoration(
//         color: isCurrentUser ? primaryColor.withOpacity(0.1) : Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 3,
//             offset: const Offset(0, 1),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//         child: Row(
//           children: [
//             SizedBox(
//               width: 30,
//               child: Text(
//                 '#$position',
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.grey,
//                 ),
//               ),
//             ),
//             const SizedBox(width: 10),
//             Expanded(
//               child: Row(
//                 children: [
//                   CircleAvatar(
//                     radius: 20,
//                     backgroundImage: AssetImage(user['avatar'] ?? "assets/images/avatars/avatar1.png"),
//                   ),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           user['username'] ?? 'Unknown',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: isCurrentUser ? primaryColor : Colors.black,
//                           ),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(width: 10),
//             Text(
//               '${user['xp'] ?? 0} XP',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: primaryColor,
//               ),
//             ),
//           ],
//         ),
//      ),
// );
// }
// }

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For JSON parsing
import 'package:shared_preferences/shared_preferences.dart';

// Main leaderboard screen widget that displays user rankings
class LeaderboardScreen extends StatefulWidget {
  // Optional parameters to display the current user's information
  final String? currentUserName;
  final int? currentUserXp;
  final String? currentUserAvatar;
  final String? currentUserRank;
  final String? currentUserLevel;

  const LeaderboardScreen({
    Key? key,
    this.currentUserName,
    this.currentUserXp,
    this.currentUserAvatar,
    this.currentUserRank,
    this.currentUserLevel,
  }) : super(key: key);

  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  // State variables for the leaderboard data and UI state
  List<dynamic> leaderboard = [];
  bool isLoading = true;
  bool isError = false;
  TextEditingController searchController = TextEditingController();
  int currentUserRank = 0;
  int currentUserXp = 0;
  String currentUserName = "User";
  String currentUserAvatar = "assets/images/avatars/avatar1.png";

  // Medal image assets for top 3 positions
  final String goldMedalAsset = "assets/images/profiles/gold.jpg";
  final String silverMedalAsset = "assets/images/profiles/silver.jpg";
  final String bronzeMedalAsset = "assets/images/profiles/bronze.jpg";

  // Theme color
  final Color primaryColor = const Color(0xFF636AE8);

  // Backend URL (updated to HTTPS)
  final String backendUrl = "https://lexfy-vocabulary-enhancement-app.onrender.com";

  // Getter to filter leaderboard based on search text
  List<dynamic> get filteredLeaderboard {
    final query = searchController.text.toLowerCase();
    return leaderboard
        .where((user) => user['username'].toLowerCase().contains(query))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    // Use passed data if available
    if (widget.currentUserName != null) {
      currentUserName = widget.currentUserName!;
    }
    if (widget.currentUserXp != null) {
      currentUserXp = widget.currentUserXp!;
    }
    if (widget.currentUserAvatar != null) {
      currentUserAvatar = widget.currentUserAvatar!;
    }

    _initUserAndFetchLeaderboard();
    _loadSelectedAvatar();
  }

  // Initialize user data and fetch leaderboard
  Future<void> _initUserAndFetchLeaderboard() async {
    try {
      await fetchLeaderboard();
    } catch (e) {
      print("Error initializing user: $e");
      setState(() {
        isError = true;
        isLoading = false;
      });
    }
  }

  // Load user avatar from shared preferences if not provided via widget
  Future<void> _loadSelectedAvatar() async {
    if (widget.currentUserAvatar == null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        currentUserAvatar =
            prefs.getString('selectedAvatar') ?? "assets/images/avatars/avatar1.png";
      });
    }
  }

  // Get current user's email from local storage
  Future<String> _getCurrentUserEmail() async {
    // Replace with your actual method to get the current user's email
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userEmail') ?? ''; // Default to empty if not found
  }

  // Fetch leaderboard data from the backend API
  Future<void> fetchLeaderboard() async {
    try {
      setState(() {
        isLoading = true;
        isError = false;
      });

      // Add authentication token if required by your backend
      final String? token = await _getAuthToken(); // Implement this
      final Map<String, String> headers = token != null
          ? {"Authorization": "Bearer $token"}
          : {};

      final response = await http.get(
        Uri.parse('$backendUrl/api/leaderboard'),
        headers: headers,
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        // Parse JSON response - flexible to handle both object and array
        final dynamic responseData = json.decode(response.body);
        List<dynamic> leaderboardData;

        if (responseData is Map<String, dynamic> && responseData.containsKey('leaderboard')) {
          leaderboardData = responseData['leaderboard'] ?? [];
        } else if (responseData is List) {
          leaderboardData = responseData;
        } else {
          throw Exception('Unexpected response format');
        }

        setState(() {
          leaderboard = leaderboardData;
          print("Leaderboard data: $leaderboard");
          isLoading = false;
          _checkCurrentUserDetails();
        });
      } else {
        throw Exception('Failed to load leaderboard: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching leaderboard: $e");
      setState(() {
        isLoading = false;
        isError = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching leaderboard: $e')),
      );
    }
  }

  // Get authentication token from shared preferences
  Future<String?> _getAuthToken() async {
    // Implement this to retrieve the auth token (e.g., from SharedPreferences)
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken'); // Return null if no token
  }

  // Find current user in leaderboard and update rank/info
  void _checkCurrentUserDetails() async {
    final currentUserEmail = await _getCurrentUserEmail();

    for (int i = 0; i < leaderboard.length; i++) {
      if (leaderboard[i]['email'] == currentUserEmail) {
        setState(() {
          currentUserRank = i + 1;
          if (widget.currentUserXp == null) {
            currentUserXp = leaderboard[i]['xp'] ?? 0;
          }
          if (widget.currentUserName == null) {
            currentUserName = leaderboard[i]['username'] ?? "User";
          }
        });
        break;
      }
    }
  }

  // Refresh leaderboard data
  Future<void> _refreshLeaderboard() async {
    setState(() {
      isLoading = true;
      isError = false;
    });
    await fetchLeaderboard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0FA),
      // App bar with title and refresh button
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Leaderboard',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _refreshLeaderboard,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar for filtering users
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search users...',
                  prefixIcon: Icon(Icons.search, color: primaryColor.withOpacity(0.6)),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
          ),
          // Main leaderboard content with refresh capability
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshLeaderboard,
              color: primaryColor,
              child: isLoading
                  ? Center(child: CircularProgressIndicator(color: primaryColor))
                  : isError
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Failed to load leaderboard.',
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _refreshLeaderboard,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                      ),
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              )
                  : filteredLeaderboard.isEmpty
                  ? const Center(
                child: Text(
                  'No users found.',
                  style: TextStyle(fontSize: 16),
                ),
              )
                  : _buildLeaderboardContent(),
            ),
          ),
        ],
      ),
    );
  }

  // Build the main leaderboard content with podium and user list
  Widget _buildLeaderboardContent() {
    return ListView(
      padding: const EdgeInsets.only(bottom: 16), // Corrected from 'custom' to 'bottom'
      children: [
        // Top 3 podium display
        if (leaderboard.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLinearPodium(leaderboard.length > 1 ? leaderboard[1] : null, 2, silverMedalAsset),
                _buildLinearPodium(leaderboard.isNotEmpty ? leaderboard[0] : null, 1, goldMedalAsset, isFirst: true),
                _buildLinearPodium(leaderboard.length > 2 ? leaderboard[2] : null, 3, bronzeMedalAsset),
              ],
            ),
          ),
        const SizedBox(height: 16),
        // Rest of the users (4th place and below)
        ...List.generate(
          filteredLeaderboard.length > 3 ? filteredLeaderboard.length - 3 : 0,
              (index) {
            final userIndex = index + 3;
            final position = userIndex + 1;
            final user = filteredLeaderboard[userIndex];
            final isCurrentUser = user['email'] == _getCurrentUserEmail(); // Async call needs handling

            return LeaderboardItem(
              position: position,
              user: user,
              isCurrentUser: isCurrentUser,
              primaryColor: primaryColor,
            );
          },
        ),
      ],
    );
  }

  // Build individual podium item for top 3 users
  Widget _buildLinearPodium(Map<String, dynamic>? user, int rank, String medalAsset, {bool isFirst = false}) {
    if (user == null) {
      return const SizedBox.shrink();
    }

    final username = user['username'] ?? '';
    final xp = user['xp']?.toString() ?? '0';
    final isCurrentUser = user['email'] == _getCurrentUserEmail(); // Async call needs handling

    final Color medalColor = rank == 1
        ? Colors.amber
        : rank == 2
        ? Colors.grey.shade400
        : Colors.brown.shade300;

    final String badgeText = rank == 1 ? "1st" : rank == 2 ? "2nd" : "3rd";

    return Expanded(
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: medalColor,
                width: 3,
              ),
            ),
            child: Center(
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: medalColor,
                  border: Border.all(color: Colors.white, width: 1),
                  image: DecorationImage(
                    image: AssetImage(medalAsset),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                  child: Text(
                    badgeText,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            username,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isCurrentUser ? primaryColor : Colors.black,
            ),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            maxLines: 1,
          ),
          Text(
            '$xp XP',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}

// Widget for displaying individual leaderboard items (rank 4 and below)
class LeaderboardItem extends StatelessWidget {
  final int position;
  final Map<String, dynamic> user;
  final bool isCurrentUser;
  final Color primaryColor;

  const LeaderboardItem({
    Key? key,
    required this.position,
    required this.user,
    required this.isCurrentUser,
    required this.primaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isCurrentUser ? primaryColor.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            SizedBox(
              width: 30,
              child: Text(
                '#$position',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage(user['avatar'] ?? "assets/images/avatars/avatar1.png"),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user['username'] ?? 'Unknown',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isCurrentUser ? primaryColor : Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Text(
              '${user['xp'] ?? 0} XP',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}