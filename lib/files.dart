/// Supported video file extensions.
const List<String> videoFormats = <String>[
  '.mp4',
  '.mov',
  '.avi',
  '.wmv',
  '.3gp',
  '.3gpp',
  '.mkv',
  '.flv',
];

/// Supported image file extensions.
const List<String> imageFormats = <String>[
  '.jpeg',
  '.png',
  '.jpg',
  '.gif',
  '.webp',
  '.tif',
  '.heic',
];

/// Scheme prefix used to determine if a file path is an HTTP or HTTPS network resource.
const String _httpSchemePrefix = 'http';

/// Determines whether the supplied [path] refers to a local filesystem asset or a remote URL.
///
/// Returns [true] if the path scheme does not contain HTTP/HTTPS.
bool isLocalFilePath(String path) {
  final Uri uri = Uri.parse(path);
  return !uri.scheme.toLowerCase().contains(_httpSchemePrefix);
}

/// Checks whether the target file at [path] corresponds to a supported video format.
bool isVideo(String path) {
  final String lowerPath = path.toLowerCase();
  return videoFormats.any(lowerPath.contains);
}

/// Checks whether the target file at [path] corresponds to a supported image format.
bool isImage(String path) {
  final String lowerPath = path.toLowerCase();
  return imageFormats.any(lowerPath.contains);
}
