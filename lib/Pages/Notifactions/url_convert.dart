String fixMinioUrl(String url) {
  if (url.contains('minio:9000')) {
    return url.replaceFirst('minio:9000', '10.0.2.2:9000'); // For emulator
    // return url.replaceFirst('minio:9000', '192.168.1.x:9000'); // For real device
  }
  return url;
}
