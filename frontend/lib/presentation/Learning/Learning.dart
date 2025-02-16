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
      "id": "dQw4w9WgXcQ", // Replace with actual video ID
      "title": "Mastering English Vocabulary",
      "thumbnail": "https://img.youtube.com/vi/dQw4w9WgXcQ/0.jpg"
    },
    {
      "id": "3JZ_D3ELwOQ",
      "title": "Top 10 Commonly Mispronounced Words",
      "thumbnail": "https://img.youtube.com/vi/3JZ_D3ELwOQ/0.jpg"
    },
    {
      "id": "LXb3EKWsInQ",
      "title": "Learn 100 English Words in 10 Minutes",
      "thumbnail": "https://img.youtube.com/vi/LXb3EKWsInQ/0.jpg"
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
                      child: Text(
                        video["title"]!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          backgroundColor: Colors.black54,
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
