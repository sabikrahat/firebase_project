import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

Future<String?> uploadImageMobile({required File? file}) async {
  //
  if (file == null) return null;

  final ref = FirebaseStorage.instance.ref().child(
        'images/${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
  UploadTask? uploadTask = ref.putFile(file);

  final snapshot = await uploadTask.whenComplete(() {});

  final downloadUrl = await snapshot.ref.getDownloadURL();

  print('Photo uploaded. Url: $downloadUrl');

  return downloadUrl;
}
