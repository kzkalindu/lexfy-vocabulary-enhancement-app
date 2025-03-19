import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LeaderboardScreen extends StatefulWidget {
  final String? currentUserName;
  final int? currentUserXp;
  final String? currentUserAvatar;
  final String? currentUserRank;
  final int? currentUserLevel;

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
  //final UserService _userService = UserService();
  List<dynamic> leaderboard = [];
  bool isLoading = true;
  bool isError = false;
  TextEditingController searchController = TextEditingController();
  int currentUserRank = 0;
  int currentUserXp = 0;
  String currentUserName = "User";
  String currentUserAvatar = "assets/images/avatars/avatar1.png";

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
    if (widget.currentUserName != null) {
      currentUserName = widget.currentUserName!;
    }
    
    _initUserAndFetchLeaderboard();
    _loadSelectedAvatar();
    fetchLeaderboard();
  }
  Future<void> _initUserAndFetchLeaderboard() async {
    try {
      //await _userService.syncUser(FirebaseAuth.instance.currentUser);
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

        return {
          'username': data['displayName'] ?? data['email']?.toString().split('@')[0] ?? 'Unknown',
          'email': data['email'] ?? '',
          'xp': xp,
          'rank': rank,
          'avatar': data['avatar'] ?? 'assets/images/avatars/avatar1.png',
          'level': data['currentLevel'] ?? 1,
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
      backgroundColor: const Color.fromARGB(255, 250, 243, 255),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 152, 79, 247),
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
                decoration: const InputDecoration(
                  hintText: 'Search users...',
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
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
                                  backgroundColor: const Color.fromARGB(255, 152, 79, 247),
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
      children: [
        if (leaderboard.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 208, 179, 252),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildPodium(leaderboard.length > 1 ? leaderboard[1] : null, 2, 'silver'),
                _buildPodium(leaderboard.isNotEmpty ? leaderboard[0] : null, 1, 'gold', isFirst: true),
                _buildPodium(leaderboard.length > 2 ? leaderboard[2] : null, 3, 'bronze'),
              ],
            ),
          ),
        const SizedBox(height: 16),
        ...List.generate(
          filteredLeaderboard.length > 3 ? filteredLeaderboard.length - 3 : 0,
          (index) {
            final position = index + 4;
            final user = filteredLeaderboard[index + 3];
            final isCurrentUser = user['email'] == FirebaseAuth.instance.currentUser?.email;

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: isCurrentUser ? Colors.deepPurple.shade50 : Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    SizedBox(
                      width: 30,
                      child: Text(
                        '#$position',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
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
                              color: isCurrentUser ? Colors.deepPurple : Colors.black,
                            ),
                          ),
                          Text(
                            'Level ${user['level']} • ${user['xp']} XP • ${user['rank']}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
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

  Widget _buildPodium(Map<String, dynamic>? user, int rank, String medalType, {bool isFirst = false}) {
    final username = user?['username'] ?? '';
    final xp = user?['xp']?.toString() ?? '0';
    final rankTitle = user?['rank'] ?? 'Newbie';
    final avatar = user?['avatar'] ?? currentUserAvatar;
    final level = user?['level']?.toString() ?? '1';
    final isCurrentUser = user != null && user['email'] == FirebaseAuth.instance.currentUser?.email;

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

    final double avatarSize = isFirst ? 80.0 : 70.0;
    final double badgeSize = isFirst ? 25.0 : 22.0;
    final Color medalColor = medalType == 'gold'
        ? Colors.amber
        : medalType == 'silver'
            ? Colors.grey.shade400
            : Colors.brown;

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: avatarSize,
              height: avatarSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(avatar),
                  fit: BoxFit.cover,
                ),
                border: Border.all(
                  color: medalColor,
                  width: 3,
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: badgeSize,
                height: badgeSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: medalColor,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Center(
                  child: Text(
                    rankText,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: isFirst ? 12 : 10,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          username,
          style: TextStyle(
            fontSize: isFirst ? 16 : 14,
            fontWeight: FontWeight.bold,
            color: isCurrentUser ? Colors.deepPurple : Colors.black,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          '$xp XP',
          style: TextStyle(
            fontSize: isFirst ? 14 : 12,
            color: Colors.grey[700],
          ),
        ),
        Text(
          '$rankTitle • Level $level',
          style: TextStyle(
            fontSize: isFirst ? 14 : 12,
            color: Colors.grey[600],
          ),
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