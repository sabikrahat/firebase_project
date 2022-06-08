// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:async';
// import 'dart:html';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';

Future<String?> uploadImageWeb() async {
  print('executing...');

  String? url;
  // InputElement input = InputElement(type: 'image/*');
  // FirebaseStorage fs = FirebaseStorage.instance;
  // input.click();
  // print('object');
  // input.onChange.listen((event) {
  //   final file = input.files!.first;
  //   final reader = FileReader();
  //   reader.readAsDataUrl(file);
  //   reader.onLoadEnd.listen((event) async {
  //     var snapshot = await fs
  //         .ref()
  //         .child('images/${FirebaseAuth.instance.currentUser!.uid}.jpg')
  //         .putBlob(file);
  //     String downloadUrl = await snapshot.ref.getDownloadURL();
  //     url = downloadUrl;
  //   });
  // });
  // print('object last');
  // print(url);
  return url;
}
