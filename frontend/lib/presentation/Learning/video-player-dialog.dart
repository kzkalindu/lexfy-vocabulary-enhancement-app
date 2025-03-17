import 'package:flutter/material.dart';
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
      child: OrientationBuilder(
        builder: (context, orientation) {
          return Container(
            width: orientation == Orientation.portrait
                ? MediaQuery.of(context).size.width
                : MediaQuery.of(context).size.height,
            height: orientation == Orientation.portrait
                ? MediaQuery.of(context).size.width * 9 / 16 +
                    100 // Add extra height for controls
                : MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Expanded(
                  child: YoutubePlayer(
                    controller: widget.controller,
                    showVideoProgressIndicator: true,
                    progressIndicatorColor: Colors.red,
                    progressColors: const ProgressBarColors(
                      playedColor: Colors.red,
                      handleColor: Colors.redAccent,
                    ),
                    onEnded: (metaData) async {
                      await widget.onVideoEnd(widget.videoId);
                      Navigator.pop(context);
                    },
                  ),
                ),
                if (orientation == Orientation.portrait) _buildControlPanel(),
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
    widget.controller.toggleFullScreenMode();
  }
}
