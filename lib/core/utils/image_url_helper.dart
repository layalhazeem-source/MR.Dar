class ImageUrlHelper {
  static String fix(String url) {
    if (url.contains('127.0.0.1')) {
      return url.replaceFirst('127.0.0.1', '10.0.2.2');
    }
    return url;
  }
}
