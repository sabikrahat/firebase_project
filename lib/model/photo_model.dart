import 'package:cloud_firestore/cloud_firestore.dart';

class PhotoModel {
  final String url;
  final Timestamp lastUpdated;
  final String updatedBy;

  PhotoModel({
    required this.url,
    required this.lastUpdated,
    required this.updatedBy,
  });

  // from document
  factory PhotoModel.fromDocument(DocumentSnapshot document) {
    return PhotoModel(
      url: document['url'],
      lastUpdated: document['lastUpdated'],
      updatedBy: document['updatedBy'],
    );
  }

  //to document
  Map<String, dynamic> toDocument() {
    return {
      'url': url,
      'lastUpdated': lastUpdated,
      'updatedBy': updatedBy,
    };
  }
}
