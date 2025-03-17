import 'package:flutter/material.dart';
import 'video-utils.dart';

class ContinueWatchingSection extends StatelessWidget {
  final List<Map<String, dynamic>> continueWatchingList;
  final Function(String, {int startAt}) onPlayVideo;
  final Function(String) onRemoveVideo;

  const ContinueWatchingSection({
    Key? key,
    required this.continueWatchingList,
    required this.onPlayVideo,
    required this.onRemoveVideo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // If the list is empty, don't show anything
    if (continueWatchingList.isEmpty) {
      return const SizedBox
          .shrink(); // This will make the section completely disappear
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Continue Watching",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () => _showAllContinueWatching(context),
                child: const Text("See all"),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: continueWatchingList.length,
            itemBuilder: (context, index) {
              final video = continueWatchingList[index];
              return _buildContinueWatchingItem(context, video);
            },
          ),
        ),
        const Divider(height: 32),
      ],
    );
  }

  Widget _buildContinueWatchingItem(
      BuildContext context, Map<String, dynamic> video) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 8.0),
      child: GestureDetector(
        onTap: () => onPlayVideo(video["id"], startAt: video["progress"]),
        child: SizedBox(
          width: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      video["thumbnail"],
                      height: 110,
                      width: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: LinearProgressIndicator(
                      value: calculateProgress(
                        video["progress"],
                        video["duration"],
                      ),
                      minHeight: 3,
                      backgroundColor: Colors.grey[300],
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.red),
                    ),
                  ),
                  Positioned(
                    right: 8,
                    bottom: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        formatDuration(video["duration"] - video["progress"]),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                video["title"],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              Text(
                getRelativeTime(video["timestamp"]),
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAllContinueWatching(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => ListView.builder(
        itemCount: continueWatchingList.length,
        itemBuilder: (context, index) {
          final video = continueWatchingList[index];
          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                video["thumbnail"],
                width: 80,
                height: 45,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(video["title"]),
            subtitle: Text(getRelativeTime(video["timestamp"])),
            trailing: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                onRemoveVideo(video["id"]);
                Navigator.pop(context);
              },
            ),
            onTap: () {
              Navigator.pop(context);
              onPlayVideo(video["id"], startAt: video["progress"]);
            },
          );
        },
      ),
    );
  }
}
