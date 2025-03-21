import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeaderboardScreen extends StatefulWidget {
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
  List<dynamic> leaderboard = [];
  bool isLoading = true;
  bool isError = false;
  TextEditingController searchController = TextEditingController();
  int currentUserRank = 0;
  int currentUserXp = 0;
  String currentUserName = "User";
  String currentUserAvatar = "assets/images/avatars/avatar1.png";

  // Medal image assets
  final String goldMedalAsset = "assets/images/profiles/gold.jpg";
  final String silverMedalAsset = "assets/images/profiles/silver.jpg";
  final String bronzeMedalAsset = "assets/images/profiles/bronze.jpg";

  // Theme color - using the specified color code
  final Color primaryColor = const Color(0xFF673AB7);

  List<dynamic> get filteredLeaderboard {
    final query = searchController.text.toLowerCase();
    return leaderboard.where((user) =>
      user['username'].toLowerCase().contains(query)
    ).toList();
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

  Future<void> _loadSelectedAvatar() async {
    // Only load from preferences if not passed as a parameter
    if (widget.currentUserAvatar == null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        currentUserAvatar = prefs.getString('selectedAvatar') ?? "assets/images/avatars/avatar1.png";
      });
    }
  }

  Future<void> fetchLeaderboard() async {
    try {
      setState(() {
        isLoading = true;
        isError = false;
      });

      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception("Please log in to view the leaderboard.");
      }

      final QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .orderBy('xpPoints', descending: true)
          .get();

      if (userSnapshot.docs.isEmpty) {
        throw Exception("No users found in the database.");
      }

      final List<dynamic> leaderboardData = userSnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        String rank;
        int xp = data['xpPoints'] ?? 0;

        if (xp >= 5000) {
          rank = 'Master';
        } else if (xp >= 2500) {
          rank = 'Expert';
        } else if (xp >= 1000) {
          rank = 'Pro';
        } else if (xp >= 100) {
          rank = 'Beginner';
        } else {
          rank = 'Newbie';
        }

        // Prioritize displayName over email, ensure we only use username not email
        String username = data['displayName'] ?? '';
        if (username.isEmpty) {
          // If email is available, extract username from email (before @)
          if (data['email'] != null && data['email'].toString().contains('@')) {
            username = data['email'].toString().split('@')[0];
          } else {
            username = 'Unknown';
          }
        }

        return {
          'username': username,
          'email': data['email'] ?? '',
          'xp': xp,
          'rank': rank,
          'avatar': data['avatar'] ?? 'assets/images/avatars/avatar1.png',
          'level': data['currentLevel'] ?? 1,
          'uid': doc.id,
        };
      }).toList();

      if (mounted) {
        setState(() {
          leaderboard = leaderboardData;
          isLoading = false;
          _checkCurrentUserDetails();
        });
      }
    } catch (e) {
      print("Error fetching leaderboard from Firestore: $e");
      if (mounted) {
        setState(() {
          isLoading = false;
          isError = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  void _checkCurrentUserDetails() {
    String currentUserEmail = FirebaseAuth.instance.currentUser?.email ?? "";
    
    for (int i = 0; i < leaderboard.length; i++) {
      if (leaderboard[i]['email'] == currentUserEmail) {
        setState(() {
          currentUserRank = i + 1;
          // Only set these values if they weren't passed in as parameters
          if (widget.currentUserXp == null) {
            currentUserXp = leaderboard[i]['xp'];
          }
          if (widget.currentUserName == null) {
            currentUserName = leaderboard[i]['username'];
          }
        });
        break;
      }
    }
  }

  Future<void> _refreshLeaderboard() async {
    if (mounted) {
      setState(() {
        isLoading = true;
        isError = false;
      });
    }
    await fetchLeaderboard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0FA), // Lighter shade of purple as background
      appBar: AppBar(
        backgroundColor: primaryColor, // Using the 0xFF673AB7 color
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

  Widget _buildLeaderboardContent() {
    return ListView(
      padding: const EdgeInsets.only(bottom: 16),
      children: [
        if (leaderboard.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.15), // Lighter shade of primary color
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
        ...List.generate(
          filteredLeaderboard.length > 3 ? filteredLeaderboard.length - 3 : 0,
          (index) {
            final userIndex = index + 3;  // Start from the 4th user
            final position = userIndex + 1;  // Position is 1-based
            final user = filteredLeaderboard[userIndex];
            final isCurrentUser = user['email'] == FirebaseAuth.instance.currentUser?.email;

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
                            backgroundImage: AssetImage(user['avatar']),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user['username'],
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
                      '${user['xp']} XP',
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
          },
        ),
      ],
    );
  }

  Widget _buildLinearPodium(Map<String, dynamic>? user, int rank, String medalAsset, {bool isFirst = false}) {
    if (user == null) {
      return const SizedBox.shrink();
    }
    
    final username = user['username'] ?? '';
    final xp = user['xp']?.toString() ?? '0';
    final isCurrentUser = user['email'] == FirebaseAuth.instance.currentUser?.email;

    // Define medal colors
    final Color medalColor = rank == 1
        ? Colors.amber
        : rank == 2
            ? Colors.grey.shade400
            : Colors.brown.shade300;

    // Define badge text (e.g., "1st", "2nd", "3rd")
    final String badgeText = rank == 1 ? "1st" : rank == 2 ? "2nd" : "3rd";

    return Expanded(
      child: Column(
        children: [
          // Medal badge
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
          // Username
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
          // XP
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