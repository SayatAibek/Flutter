const List<String> _months = <String>[
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

String formatDate(DateTime value) => '${value.day} ${_months[value.month - 1]}';

String formatTime(DateTime value) =>
    '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';

String formatDateTime(DateTime value) => '${formatDate(value)}, ${formatTime(value)}';

String formatDuration(Duration duration) {
  if (duration.inDays > 0) {
    final hours = duration.inHours.remainder(24);
    return '${duration.inDays}d ${hours}h';
  }
  if (duration.inHours > 0) {
    final minutes = duration.inMinutes.remainder(60);
    return '${duration.inHours}h ${minutes}m';
  }
  return '${duration.inMinutes}m';
}
