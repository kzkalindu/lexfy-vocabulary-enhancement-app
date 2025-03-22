import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerDialog extends StatefulWidget {
  final YoutubePlayerController controller;
  final String videoId;
  final bool isCaptionOn;
  final VoidCallback onCaptionToggle;
  final Function(String) onVideoEnd;

  const VideoPlayerDialog({
    Key? key,
    required this.controller,
    required this.videoId,
    required this.isCaptionOn,
    required this.onCaptionToggle,
    required this.onVideoEnd,
  }) : super(key: key);

  @override
  _VideoPlayerDialogState createState() => _VideoPlayerDialogState();
}

class _VideoPlayerDialogState extends State<VideoPlayerDialog> {
  bool _isFullScreen = false;
  late bool _localCaptionState;

  @override
  void initState() {
    super.initState();
    _localCaptionState = widget.isCaptionOn;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: Colors.black,
      child: OrientationBuilder(
        builder: (context, orientation) {
          final isLandscape = orientation == Orientation.landscape;
          return Container(
            width: MediaQuery.of(context).size.width,
            height: isLandscape
                ? MediaQuery.of(context).size.height
                : MediaQuery.of(context).size.width * 9 / 16 +
                    (_isFullScreen ? 0 : 100),
            child: Column(
              children: [
                Expanded(
                  child: YoutubePlayer(
                    controller: widget.controller,
                    showVideoProgressIndicator: true,
                    progressIndicatorColor:
                        const Color(0xFF5271FF), // Logo color
                    progressColors: const ProgressBarColors(
                      playedColor: Color(0xFF5271FF), // Logo color
                      handleColor: Color(0xFF5271FF), // Logo color
                    ),
                    onEnded: (metaData) async {
                      await widget.onVideoEnd(widget.videoId);
                      Navigator.pop(context);
                    },
                  ),
                ),
                if (!_isFullScreen) _buildControlPanel(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildControlPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.black87,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildControlButton(
            icon: Icons.speed,
            label: 'Speed',
            onPressed: _showSpeedOptions,
          ),
          _buildControlButton(
            icon: _localCaptionState
                ? Icons.closed_caption
                : Icons.closed_caption_off,
            label: 'Captions',
            onPressed: _toggleCaptions,
          ),
          _buildControlButton(
            icon: _isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
            label: 'Fullscreen',
            onPressed: _toggleFullScreen,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton(
      {required IconData icon,
      required String label,
      required VoidCallback onPressed}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon, color: Colors.white),
          onPressed: onPressed,
        ),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }

  void _showSpeedOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(title: const Text('Speed Options'), onTap: () {}),
          ListTile(
              title: const Text('0.25x'), onTap: () => _setPlaybackSpeed(0.25)),
          ListTile(
              title: const Text('0.5x'), onTap: () => _setPlaybackSpeed(0.5)),
          ListTile(
              title: const Text('Normal'), onTap: () => _setPlaybackSpeed(1.0)),
          ListTile(
              title: const Text('1.5x'), onTap: () => _setPlaybackSpeed(1.5)),
          ListTile(
              title: const Text('2x'), onTap: () => _setPlaybackSpeed(2.0)),
        ],
      ),
    );
  }

  void _setPlaybackSpeed(double speed) {
    widget.controller.setPlaybackRate(speed);
    Navigator.pop(context);
  }

  void _toggleCaptions() {
    setState(() {
      _localCaptionState = !_localCaptionState;
    });

    // Call parent's toggle function to update the state in parent
    widget.onCaptionToggle();

    // Since toggleCaptions doesn't exist, we need to recreate the controller
    // This is handled in the parent component
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
    });

    if (_isFullScreen) {
      // Set to landscape orientation
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      // Hide status bar and navigation bar for true fullscreen
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

      // Force the player to take up the entire screen
      widget.controller.toggleFullScreenMode();
    } else {
      // Return to portrait orientation
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
      // Show status bar and navigation bar again
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: SystemUiOverlay.values,
      );

      // Exit fullscreen mode in the player
      widget.controller.toggleFullScreenMode();
    }
  }

  @override
  void dispose() {
    // Reset orientation and UI overlays
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.dispose();
  }
}
