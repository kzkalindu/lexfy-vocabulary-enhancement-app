import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'video-player-dialog.dart';
import 'continue-watching-section.dart';
import 'all-videos-section.dart';
import 'video-utils.dart';

class YouTubeVideoScreen extends StatefulWidget {
  const YouTubeVideoScreen({Key? key}) : super(key: key);

  @override
  _YouTubeVideoScreenState createState() => _YouTubeVideoScreenState();
}

class _YouTubeVideoScreenState extends State<YouTubeVideoScreen> {
  List<Map<String, String>> videos = [];
  bool isLoading = true;
  String? errorMessage;
  YoutubePlayerController? _controller;
  List<Map<String, dynamic>> continueWatchingList = [];
  bool _isCaptionOn = false;

  // Backend URL (Change if needed)
  final String backendUrl = 'http://192.168.177.252:3000/api/videos';

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await Future.wait([
      fetchVideos(),
      _loadContinueWatchingList(),
    ]);
  }

  Future<void> fetchVideos() async {
    try {
      final response = await http.get(Uri.parse(backendUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          videos = data
              .map((video) => {
                    "id": video["id"].toString(),
                    "title": video["title"].toString(),
                    "thumbnail": video["thumbnail"].toString(),
                  })
              .toList();
          isLoading = false;
        });
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (error) {
      setState(() {
        errorMessage = 'Failed to load videos. Check your internet connection.';
        isLoading = false;
      });
    }
  }

  Future<void> _saveVideoProgress(
      String videoId, int progress, int duration) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> savedList =
        prefs.getStringList('continueWatchingList') ?? [];

    final Map<String, String>? videoInfo =
        videos.firstWhere((v) => v["id"] == videoId, orElse: () => {});
    if (videoInfo == null || videoInfo.isEmpty) return;

    final Map<String, dynamic> entry = {
      "id": videoId,
      "title": videoInfo["title"],
      "thumbnail": videoInfo["thumbnail"],
      "progress": progress,
      "duration": duration,
      "timestamp": DateTime.now().millisecondsSinceEpoch,
    };

    final List<Map<String, dynamic>> existingList = savedList
        .map((item) => json.decode(item) as Map<String, dynamic>)
        .where((item) => item["id"] != videoId)
        .toList();

    if (progress < duration - 10) {
      existingList.add(entry);
    }

    existingList.sort((a, b) => b["timestamp"].compareTo(a["timestamp"]));

    final updatedList =
        existingList.take(10).map((item) => json.encode(item)).toList();
    await prefs.setStringList('continueWatchingList', updatedList);

    await _loadContinueWatchingList();
  }

  Future<void> _loadContinueWatchingList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> savedList =
        prefs.getStringList('continueWatchingList') ?? [];

    final List<Map<String, dynamic>> loadedList = savedList
        .map((item) => json.decode(item) as Map<String, dynamic>)
        .toList();

    loadedList.sort((a, b) => b["timestamp"].compareTo(a["timestamp"]));

    setState(() {
      continueWatchingList = loadedList;
    });
  }

  Future<void> _removeFromContinueWatching(String videoId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> savedList =
        prefs.getStringList('continueWatchingList') ?? [];

    final updatedList =
        savedList.where((item) => json.decode(item)["id"] != videoId).toList();

    await prefs.setStringList('continueWatchingList', updatedList);
    await _loadContinueWatchingList();
  }

  // Rebuilds the controller with the updated caption setting.
  void _toggleCaptions() {
    setState(() {
      _isCaptionOn = !_isCaptionOn;
    });
    if (_controller != null) {
      final int currentPosition = _controller!.value.position.inSeconds;
      final String videoId = _controller!.initialVideoId;
      _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: YoutubePlayerFlags(
          autoPlay: true,
          startAt: currentPosition,
          enableCaption: _isCaptionOn,
          captionLanguage: 'en',
          controlsVisibleAtStart: true,
        ),
      );
    }
  }

  // Play video using a dialog that includes settings.
  void _playVideo(String videoId, {int startAt = 0}) {
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        startAt: startAt,
        enableCaption: _isCaptionOn,
        captionLanguage: 'en',
        controlsVisibleAtStart: true,
      ),
    );

    showDialog(
      context: context,
      builder: (context) => VideoPlayerDialog(
        controller: _controller!,
        videoId: videoId,
        isCaptionOn: _isCaptionOn,
        onCaptionToggle: _toggleCaptions,
        onVideoEnd: _removeFromContinueWatching,
      ),
    ).then((_) {
      if (_controller!.value.position.inSeconds > 0) {
        _saveVideoProgress(
          videoId,
          _controller!.value.position.inSeconds,
          _controller!.metadata.duration.inSeconds,
        );
      }
      _controller!.pause();
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Video Learning",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _initializeData,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage != null
                ? Center(
                    child: Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ContinueWatchingSection(
                          continueWatchingList: continueWatchingList,
                          onPlayVideo: _playVideo,
                          onRemoveVideo: _removeFromContinueWatching,
                        ),
                        AllVideosSection(
                          videos: videos,
                          onPlayVideo: _playVideo,
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
