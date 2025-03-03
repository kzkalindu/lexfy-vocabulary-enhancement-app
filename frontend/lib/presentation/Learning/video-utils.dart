String formatDuration(int seconds) {
  final Duration duration = Duration(seconds: seconds);
  final int minutes = duration.inMinutes;
  final int remainingSeconds = duration.inSeconds - minutes * 60;
  return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
}

double calculateProgress(int current, int total) {
  return total > 0 ? current / total : 0.0;
}

String getRelativeTime(int timestamp) {
  final DateTime now = DateTime.now();
  final DateTime videoTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
  final Duration difference = now.difference(videoTime);

  if (difference.inDays > 0) {
    return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
  } else if (difference.inHours > 0) {
    return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
  } else {
    return 'Just now';
  }
}
