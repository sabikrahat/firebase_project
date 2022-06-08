import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<String?> uploadImage(
    {required PlatformFile? platformFile,
    String folder = 'images',
    String? uuid}) async {
  //
  if (platformFile == null) return null;

  uuid ??= FirebaseAuth.instance.currentUser!.uid;

  File file = File(platformFile.path!);

  final ref =
      FirebaseStorage.instance.ref().child('$folder/$uuid/${platformFile.name}');
  UploadTask? uploadTask = ref.putFile(file);

  final snapshot = await uploadTask.whenComplete(() {});

  final downloadUrl = await snapshot.ref.getDownloadURL();

  print('Photo uploaded. Url: $downloadUrl');

  return downloadUrl;
}
