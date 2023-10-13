import 'package:blooddonar_firebase/presentation/add_edit/add_edit.dart';
import 'package:blooddonar_firebase/presentation/core/colors/colors.dart';
import 'package:blooddonar_firebase/presentation/core/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final donar = FirebaseFirestore.instance.collection('donars');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: redColor,
        title: const Text(
          "Blood Donars",
          style: TextStyle(color: whiteColor),
        ),
        centerTitle: false,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddEditDonar(type: ActionType.add),
                    ));
              },
              icon: const Icon(
                Icons.bloodtype,
                color: whiteColor,
                size: 31,
              ))
        ],
      ),
      body: StreamBuilder(
        stream: donar.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching data'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No data available'));
          }
          return ListView.separated(
              itemBuilder: (context, index) {
                final data = snapshot.data!.docs[index];

                return Padding(
                  padding: spaceHeight,
                  child: ListTile(
                    title: Text(
                      data['name'] ?? "dummy name",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(data['contact'] != null
                        ? data['contact'].toString()
                        : "dummy number"),
                    leading: CircleAvatar(
                      radius: 27,
                      child: Text(data['group'].toString(),
                          style: const TextStyle(fontSize: 21)),
                    ),
                    trailing: IconButton(
                        onPressed: () {
                          // alert dialogue
                          showDialog(
                            context: context,
                            builder: (context) {
                              final donorName = data['name'] ?? "name";
                              return AlertDialog(
                                title: Text('Delete $donorName ?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      deleteDonor(data.id);
                                    },
                                    child: const Text('Yes'),
                                  ),
                                  TextButton(
                                    style: ButtonStyle(
                                        shape: MaterialStateProperty.all(
                                            const BeveledRectangleBorder()),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                redColor)),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      // pop back to home page
                                    },
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(color: whiteColor),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );

                          // delete function call
                          // pop back to home page
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: redColor,
                        )),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddEditDonar(
                            type: ActionType.edit,
                            donorData: data,
                            documentId: data.id,
                          ),
                        ),
                      );
                      // navigate to edit page with existing data
                      // save to firebase db
                      // pop back to home page
                    },
                  ),
                );
              },
              separatorBuilder: (context, index) => const Divider(),
              itemCount: snapshot.data!.docs.length);
        },
      ),
    );
  }

  void deleteDonor(String docId) {
    donar.doc(docId).delete();
  }
}
