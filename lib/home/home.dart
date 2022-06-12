import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/home/functions/modal_bottom_sheet.dart';
import 'package:firebase_project/model/counter_model.dart';
import 'package:flutter/material.dart';

import 'functions/upload_image.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async => await FirebaseAuth.instance.signOut(),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Email: ${FirebaseAuth.instance.currentUser?.email}'),
            const SizedBox(height: 5),
            Text('UID: ${FirebaseAuth.instance.currentUser?.uid}'),
            const SizedBox(height: 30),
            const Text('You have pushed the button this many times:'),
            const SizedBox(height: 10.0),
            StreamBuilder<CounterModel>(
              stream: FirebaseFirestore.instance
                  .collection('firebase_project')
                  .doc('counter')
                  .snapshots()
                  .map((v) => CounterModel.fromDocument(v)),
              builder: ((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (!snapshot.hasData) {
                  return const Text('0', style: TextStyle(fontSize: 40));
                }
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${snapshot.data!.count}',
                      style: const TextStyle(
                        fontSize: 40.0,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Text('Updated By: ${snapshot.data!.updatedBy}'),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: null,
            child: const Icon(Icons.upload),
            onPressed: () async {
              File? file =  await modalBottomSheetMenu(context: context);
              print('picked file: $file');
              if(file != null){
                final downloadUrl = await uploadImageMobile(file: file);
                print('downloadUrl: $downloadUrl');
              }
            },
          ),
          const SizedBox(height: 10.0),
          FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () async {
              CounterModel counter = await FirebaseFirestore.instance
                  .collection('firebase_project')
                  .doc('counter')
                  .get()
                  .then((v) => CounterModel.fromDocument(v));
              await FirebaseFirestore.instance
                  .collection('firebase_project')
                  .doc('counter')
                  .set({
                'count': counter.count + 1,
                'lastUpdated': Timestamp.now(),
                'updatedBy': FirebaseAuth.instance.currentUser?.email,
              });
            },
          ),
        ],
      ),
    );
  }
}
