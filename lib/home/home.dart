import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/counter_model.dart';
import '../photo/photo_process_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
        child: SizedBox(
          height: size.height,
          width: size.width > 600 ? 600 : size.width,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                Text('Name: ${FirebaseAuth.instance.currentUser?.displayName}'),
                const SizedBox(height: 5.0),
                Text('Email: ${FirebaseAuth.instance.currentUser?.email}'),
                const SizedBox(height: 5.0),
                Text('Uid: ${FirebaseAuth.instance.currentUser?.uid}'),
                const Spacer(),
                const Text('You have pushed the button this many times:'),
                const SizedBox(height: 10),
                StreamBuilder<CounterModel>(
                  stream: FirebaseFirestore.instance
                      .collection('firebase_project')
                      .doc('counter')
                      .snapshots()
                      .map((snapshot) => CounterModel.fromDocument(snapshot)),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (!snapshot.hasData) {
                      return const Text('0', style: TextStyle(fontSize: 40));
                    }
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(snapshot.data!.count.toString(),
                            style: const TextStyle(fontSize: 40)),
                        const SizedBox(height: 30),
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
                    );
                  },
                ),
                const Spacer(),
                ElevatedButton.icon(
                  icon: const Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: Icon(Icons.photo),
                  ),
                  label: const Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 5.0, 15.0, 5.0),
                    child: Text('Photo Process'),
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PhotoProcess(),
                    ),
                  ),
                ),
                const Spacer(),
                const Text('Developed by: Sabik Rahat'),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: null,
            tooltip: 'Increase',
            child: const Icon(Icons.add),
            onPressed: () async {
              CounterModel counter = await FirebaseFirestore.instance
                  .collection('firebase_project')
                  .doc('counter')
                  .get()
                  .then((value) {
                if (value.exists) {
                  return CounterModel.fromDocument(value);
                }
                return CounterModel(
                  count: 0,
                  lastUpdated: Timestamp.now(),
                  updatedBy: '',
                );
              });
              //
              await FirebaseFirestore.instance
                  .collection('firebase_project')
                  .doc('counter')
                  .set({
                'count': counter.count + 1,
                'lastUpdated': Timestamp.now(),
                'updatedBy': FirebaseAuth.instance.currentUser?.displayName,
              });
            },
          ),
          const SizedBox(height: 5.0),
          FloatingActionButton(
            heroTag: null,
            tooltip: 'Clear Database',
            child: const Icon(Icons.delete),
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('firebase_project')
                  .doc('counter')
                  .delete()
                  .then(
                    (value) => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Database Cleared'),
                      ),
                    ),
                  );
            },
          ),
        ],
      ),
    );
  }
}
