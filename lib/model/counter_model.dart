import 'package:cloud_firestore/cloud_firestore.dart';

class CounterModel {
  final int count;
  final Timestamp lastUpdated;
  final String updatedBy;

  CounterModel({
    required this.count,
    required this.lastUpdated,
    required this.updatedBy,
  });


  // from document
  factory CounterModel.fromDocument(DocumentSnapshot document) {
    return CounterModel(
      count: document['count'],
      lastUpdated: document['lastUpdated'],
      updatedBy: document['updatedBy'],
    );
  }

  //to document
  Map<String, dynamic> toDocument() {
    return {
      'count': count,
      'lastUpdated': lastUpdated,
      'updatedBy': updatedBy,
    };
  }
}
