import 'dart:developer';
import 'package:blooddonar_firebase/presentation/core/colors/colors.dart';
import 'package:blooddonar_firebase/presentation/core/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum ActionType { add, edit }

class AddEditDonar extends StatelessWidget {
  AddEditDonar(
      {super.key, required this.type, this.donorData, this.documentId});
  List<String> bloodGroup = ["A+", "O+", "B+", "A-", "O-", "B-", "AB+", "AB-"];
  String? selectedGroup;
  final donar = FirebaseFirestore.instance.collection('donars');
  final nameController = TextEditingController();
  final contactController = TextEditingController();
  final ActionType type;
  final donorData;
  final documentId;
  @override
  Widget build(BuildContext context) {
    //final args = ModalRoute.of(context)?.settings.arguments as Map;
    final size = MediaQuery.sizeOf(context).width;
// Initialize the text controllers with the donor data for editing.
    if (type == ActionType.edit && donorData != null) {
      nameController.text = donorData['name'] ?? '';
      contactController.text =
          donorData['contact'] != null ? donorData['contact'].toString() : '';
      selectedGroup = donorData['group'];
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: redColor,
        title: const Text(
          "Lifesavers Details 🤍",
          style: TextStyle(color: whiteColor),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: spaceHeight,
            child: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.contain, image: NetworkImage(bloodDonarUrl))),
              height: size * 0.5,
            ),
          ),
          Padding(
            padding: paddingAll10,
            child: TextField(
              controller: nameController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: "donar name"),
            ),
          ),
          Padding(
            padding: paddingAll10,
            child: TextField(
              controller: contactController,
              maxLength: 10,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: "contact number"),
            ),
          ),
          Padding(
            padding: paddingAll10,
            child: DropdownButtonFormField(
              decoration: const InputDecoration(label: Text("Blood Group")),
              items: bloodGroup
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ))
                  .toList(),
              onChanged: (val) => selectedGroup = val,
              value: selectedGroup,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (type == ActionType.add) {
                addDonar(context);
              } else if (type == ActionType.edit) {
                updateDonor(context, documentId);
              }

              // add/update to Firebase
              // pop to Home Screen
            },
            style: ButtonStyle(
                shape: MaterialStatePropertyAll(BeveledRectangleBorder(
                    borderRadius: BorderRadius.circular(10)))),
            child: Text(type == ActionType.add ? "Donate" : "Update"),
          )
        ]),
      ),
    );
  }

  void addDonar(BuildContext context) async {
    final String name = nameController.text;
    final String contact = contactController.text;
    final data = {
      'name': name,
      'contact': contact,
      'group': selectedGroup,
    };
    DocumentReference newDonarRef = await donar.add(data);
    String documentId = newDonarRef.id;
    log(documentId.toString());
    Navigator.pop(context);
  }

  void updateDonor(BuildContext context, String documentId) {
    final String name = nameController.text;
    final String contact = contactController.text;
    final data = {
      'name': name,
      'contact': contact,
      'group': selectedGroup,
    };

    donar.doc(documentId).update(data).then((_) {
      Navigator.pop(context); // Close the edit screen.
    }).catchError((error) {
      // Handle error if the update fails.
      print("Error updating donor: $error");
    });

    Navigator.pop(context);
  }
}
