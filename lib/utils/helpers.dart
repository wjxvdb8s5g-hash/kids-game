String formatMs(int ms) {
  final sec = (ms / 1000).toStringAsFixed(2);
  return '${sec}s';
}
