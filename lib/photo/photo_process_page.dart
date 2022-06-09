import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/model/photo_model.dart';
import 'package:firebase_project/photo/api_mobile/image_picker/modal_bottom_sheet_menu.dart';
import 'package:firebase_project/photo/api_mobile/upload_image/upload_image_mobile.dart';
import 'package:firebase_project/photo/api_web/upload_image/upload_image_web.dart';
import 'package:firebase_project/photo/api_web/image_picker/image_pick_web.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PhotoProcess extends StatelessWidget {
  const PhotoProcess({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Process'),
      ),
      body: Center(
        child: SizedBox(
          height: size.height,
          width: size.width > 600 ? 600 : size.width,
          child: Center(
            child: StreamBuilder<PhotoModel>(
                stream: FirebaseFirestore.instance
                    .collection('firebase_project')
                    .doc('photo')
                    .snapshots()
                    .map((snapshot) => PhotoModel.fromDocument(snapshot)),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.blue[100],
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.blue,
                                width: 2,
                              ),
                            ),
                            child: snapshot.hasData
                                ? CachedNetworkImage(
                                    imageUrl: snapshot.data!.url,
                                    progressIndicatorBuilder: (context, url,
                                            downloadProgress) =>
                                        Center(
                                            child: CircularProgressIndicator(
                                                value:
                                                    downloadProgress.progress)),
                                    errorWidget: (context, url, error) =>
                                        const Center(child: Icon(Icons.error)))
                                // ? Image.network(snapshot.data!.url)
                                : snapshot.hasError
                                    ? const Icon(Icons.error, size: 30.0)
                                    : const Icon(Icons.add, size: 30.0)),
                        const SizedBox(height: 20.0),
                        ElevatedButton.icon(
                          icon: const Padding(
                            padding: EdgeInsets.only(left: 15.0),
                            child: Icon(Icons.upload),
                          ),
                          label: const Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 5.0, 15.0, 5.0),
                            child: Text('Upload'),
                          ),
                          onPressed: () async {
                            String? url;
                            if (kIsWeb) {
                              PlatformFile? file =
                                  await filePickFromDeviceWeb();
                              if (file != null) {
                                url = await uploadImageWeb(file);
                              }
                            } else {
                              final file =
                                  await modalBottomSheetMenu(context: context);
                              if (file != null) {
                                url = await uploadImageMobile(file: file);
                              }
                            }
                            print('URL: $url');
                            if (url != null) {
                              print('URL: $url');
                              await FirebaseFirestore.instance
                                  .collection('firebase_project')
                                  .doc('photo')
                                  .set(
                                {
                                  'url': url,
                                  'lastUpdated': Timestamp.now(),
                                  'updatedBy': FirebaseAuth
                                      .instance.currentUser?.displayName,
                                },
                              ).then(
                                (_) =>
                                    ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Image Uploaded'),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                        const Spacer(),
                        if (snapshot.hasData)
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Last Updated By: ${snapshot.data!.updatedBy}',
                              ),
                              const SizedBox(height: 5.0),
                              const Text(
                                'at',
                              ),
                              const SizedBox(height: 5.0),
                              Text(
                                DateFormat('MMMM dd, y  hh:mm:ss a').format(
                                  snapshot.data!.lastUpdated.toDate(),
                                ),
                              ),
                            ],
                          ),
                        const Spacer(),
                        const Text('Developed by: Sabik Rahat'),
                        const SizedBox(height: 30),
                      ],
                    ),
                  );
                }),
          ),
        ),
      ),
    );
  }
}
