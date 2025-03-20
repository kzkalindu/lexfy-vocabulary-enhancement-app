import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/services/user_service.dart';
import 'leaderboard_page.dart';

// Global variables
String userEmail = "";
int userLevel = 0;
int userXp = 0;
String userRank = ''; // Changed from int to String to match UserService

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = "User";
  String selectedAvatar = "assets/images/avatars/avatar1.png";
  bool isLoading = false;
  final UserService _userService = UserService();
  
  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _loadSelectedAvatar();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }
  
  Future<void> _fetchUserData() async {
    setState(() {
      isLoading = true;
    });
    
    // Replace with your actual API endpoint
    //final String apiUrl = "https://172.20.10.6:5001'/api/user/$email";

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        userEmail = user.email ?? "";
        userName = user.displayName ?? "User";
        
        await _userService.syncUser(user);
        
        if (mounted) {
          setState(() {
            userLevel = _userService.user.currentLevel;
            userXp = _userService.user.xpPoints;
            userRank = _userService.user.rank; // Now String instead of int
            isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          userLevel = 1;
          userXp = 0;
          userRank = 'Newbie'; // Match default from UserService
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching user data: $e')),
        );
      }
    }
  }
  
  // Load selected avatar from SharedPreferences
  void _loadSelectedAvatar() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedAvatar = prefs.getString('selectedAvatar') ?? "assets/images/avatars/avatar1.png";
    });
  }
  
  // Save selected avatar to SharedPreferences
  void _saveSelectedAvatar(String avatarPath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedAvatar', avatarPath);
  }
  
  // Show Avatar Selection Dialog
  void _showAvatarSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Choose Your Avatar"),
          content: Container(
            width: 300,
            height: 300,
            child: GridView.count(
              crossAxisCount: 3,
              children: [
                _buildAvatarOption("assets/images/profiles/male.jpg"),
                _buildAvatarOption("assets/images/profiles/female.jpg"),
                _buildAvatarOption("assets/images/profiles/one.jpg"),
                _buildAvatarOption("assets/images/profiles/two.jpg"),
                _buildAvatarOption("assets/images/profiles/three.jpg"),
                _buildAvatarOption("assets/images/profiles/four.jpg"),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }
  
  Widget _buildAvatarOption(String avatarPath) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAvatar = avatarPath;
        });
        _saveSelectedAvatar(avatarPath);
        Navigator.pop(context);
      },
      child: Container(
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: selectedAvatar == avatarPath ? Colors.deepPurple : Colors.transparent,
            width: 3,
          ),
        ),
        child: CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage(avatarPath),
        ),
      ),
    );
  }
  
  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      print("Error signing out: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error signing out. Please try again.")),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 243, 255),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 152, 79, 247),
        elevation: 0,
        title: Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _signOut,
            color: Colors.white,
          ),
        ],
      ),
      body: isLoading 
        ? Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 152, 79, 247),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundImage: AssetImage(selectedAvatar),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 6,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: InkWell(
                                onTap: _showAvatarSelectionDialog,
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.deepPurple,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Text(
                        userName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        userEmail,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                
                Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Stats',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              'Level',
                              userLevel.toString(),
                              Icons.trending_up,
                              Colors.deepPurple,
                            ),
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            child: _buildStatCard(
                              'XP',
                              userXp.toString(),
                              Icons.star,
                              Colors.amber,
                            ),
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            child: _buildStatCard(
                              'Rank',
                              userRank.isNotEmpty ? userRank : 'Newbie', // Updated to handle String
                              Icons.bar_chart,
                              Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LeaderboardScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.leaderboard, color: Colors.white),
                        SizedBox(width: 10),
                        Text(
                          'View Leaderboard',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Settings',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      SizedBox(height: 15),
                    
                      _buildSettingsOption(
                        'Privacy',
                        Icons.lock,
                        () {},
                      ),
                      _buildSettingsOption(
                        'Help & Support',
                        Icons.help,
                        () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
    );
  }
  
  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 3),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSettingsOption(String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.deepPurple, size: 22),
            SizedBox(width: 15),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
          ],
        ),
     ),
);
}
}