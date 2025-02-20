import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Learning Videos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: YouTubeVideoScreen(),


    );
  }
}

class YouTubeVideoScreen extends StatefulWidget {
  @override
  _YouTubeVideoScreenState createState() => _YouTubeVideoScreenState();
}

class _YouTubeVideoScreenState extends State<YouTubeVideoScreen> {
  final List<Map<String, String>> videos = [
    {
      "id": "7zUZagriZXM", // Replace with actual video ID
      "title": "30 English grammar test practice questions with answers & explanations",
      "thumbnail": "https://img.youtube.com/vi/7zUZagriZXM/0.jpg"
    },
    {
      "id": "opKPVqxE_QY",
      "title": "English Words You’re Probably Mispronouncing",
      "thumbnail": "https://img.youtube.com/vi/opKPVqxE_QY/0.jpg"

    },
    {

      "id": "KDpfN0TA4c4",
      "title": "Practice Speaking & Reading Out Loud with This English Shadowing Exercise",
      "thumbnail": "https://img.youtube.com/vi/KDpfN0TA4c4/0.jpg"
    },
    {
      "id": "_KYln3kIfP8",

      "title": "What is YOUR English vocabulary level? Take this test!",
      "thumbnail": "https://img.youtube.com/vi/_KYln3kIfP8/0.jpg"
    },
    {
      "id": "IrNDVWXokwY",
      "title": "What’s your English level? Take this test!",
      "thumbnail": "https://img.youtube.com/vi/IrNDVWXokwY/0.jpg"
    },
    {
      "id": "9bZkp7q19f0",
      "title": "Imp4"
          ""
          "rove Your English Listening Skills",
      "thumbnail": "https://img.youtube.com/vi/9bZkp7q19f0/0.jpg"
    },
    {
      "id": "kJQP7kiw5Fk",
      "title": "English Pronunciation Tips",
      "thumbnail": "https://img.youtube.com/vi/kJQP7kiw5Fk/0.jpg"
    },
    {
      "id": "OPf0YbXqDm0",
      "title": "Common English Phrases",
      "thumbnail": "https://img.youtube.com/vi/OPf0YbXqDm0/0.jpg"
    },
    {
      "id": "CevxZvSJLk8",
      "title": "English Conversation Practice",
      "thumbnail": "https://img.youtube.com/vi/CevxZvSJLk8/0.jpg"
    },
    {
      "id": "F2BwGZ6Z8R0",
      "title": "English for Beginners",
      "thumbnail": "https://img.youtube.com/vi/F2BwGZ6Z8R0/0.jpg"
    },
    {
      "id": "G6r2Tk0J5Xo",
      "title": "Advanced English Vocabulary",
      "thumbnail": "https://img.youtube.com/vi/G6r2Tk0J5Xo/0.jpg"
    },

  ];

  late YoutubePlayerController _controller;

  void _playVideo(String videoId) {
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(autoPlay: true),
    );

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      builder: (context) => YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Video Learning",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: videos.length,
          itemBuilder: (context, index) {
            final video = videos[index];
            return GestureDetector(
              onTap: () => _playVideo(video["id"]!),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        video["thumbnail"]!,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    const Icon(
                      Icons.play_circle_fill,
                      color: Colors.white,
                      size: 64,
                    ),
                    Positioned(
                      bottom: 16,
                      left: 16,
                      right: 16, // Constrain the title to the width of the card
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          video["title"]!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 2, // Allow up to 2 lines
                          overflow: TextOverflow.ellipsis, // Add ellipsis if text overflows
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
