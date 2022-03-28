import 'package:firebase_storage/firebase_storage.dart';

class FireStorageService {
  final FirebaseStorage _fireStorage = FirebaseStorage.instance;

  Future<String> getImgUrl(String fileName) async =>
      await _fireStorage.ref().child("images").child(fileName).getDownloadURL();
}
