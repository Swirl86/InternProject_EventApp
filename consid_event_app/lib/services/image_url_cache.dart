import 'package:consid_event_app/services/fire_storage_service.dart';

class ImageUrlCache {
  // Always only one ImageUrlCache instance like Singleton
  ImageUrlCache._privateConstructor();
  static final ImageUrlCache _instance = ImageUrlCache._privateConstructor();
  static ImageUrlCache get instance => _instance;

  final Map<String, String> _urlCache = {};
  final FireStorageService _storageService = FireStorageService();

  Future<String> getSvgUrl(String refKey) async {
    String url = _urlCache[refKey] ?? "Not added";
    if (url == "Not added") {
      url = await _storageService.getImgUrl("$refKey.svg");
      _urlCache[refKey] = url;
    }
    return url;
  }
}
