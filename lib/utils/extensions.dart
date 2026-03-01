

extension StringExtensions on String {

String get capitalised =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';

bool get isValidUrl {
    final uri = Uri.tryParse(this);
    return uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
  }

String truncate(int maxLength) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}…';
  }
}

extension NullableStringExtensions on String? {

  String orDefault(String fallback) {
    if (this == null || this!.trim().isEmpty) return fallback;
    return this!;
  }
}

extension DateTimeExtensions on DateTime {

String get relative {
    final now = DateTime.now();
    final diff = now.difference(this);

    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes} minute${diff.inMinutes == 1 ? '' : 's'} ago';
    }
    if (diff.inHours < 24) {
      return '${diff.inHours} hour${diff.inHours == 1 ? '' : 's'} ago';
    }
    if (diff.inDays < 7) {
      return '${diff.inDays} day${diff.inDays == 1 ? '' : 's'} ago';
    }
    return '${day.toString().padLeft(2, '0')}/'
        '${month.toString().padLeft(2, '0')}/'
        '$year';
  }
}
