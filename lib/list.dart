import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:voterslist/widgets.dart';

import 'auth/auth.dart';
import 'model/voter.dart';

CollectionReference<Map<String, dynamic>> users = firestore.collection('Voters');

class VotersList extends StatefulWidget {
  const VotersList({Key? key, required this.auth}) : super(key: key);

  final Auth auth;

  @override
  State<VotersList> createState() => _VotersListState();
}

class _VotersListState extends State<VotersList> {
  Query query = voters;
  int partNumber = 1;

  @override
  void initState() {
    super.initState();
    query = voters.where("partNumber", isNull: true);
  }

  setQuery() {
    setState(() {
      query = voters.where("partNumber", isEqualTo: partNumber);
      if (voterId.text.isNotEmpty) {
        query = query.where("id", isEqualTo: voterId.text.toUpperCase());
      }
      if (father.text.isNotEmpty) {
        query = query.where("searchFather.${father.text.toLowerCase()}", isEqualTo: true);
      }
      if (name.text.isNotEmpty) {
        query = query.where("searchName.${name.text.toLowerCase()}", isEqualTo: true);
      }
    });
    // print(query.toString());
  }

  get partNumbers => [93, 94, 95].map((e) => DropdownMenuItem(value: e, child: Text(e.toString()))).toList();

  final voterId = TextEditingController();
  final father = TextEditingController();
  final name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Search Voter"),
          centerTitle: true,
          backgroundColor: const Color(0xffe3100f),
          actions: [
            GestureDetector(
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
              ),
              onTap: () {
                widget.auth.signOut();
              },
            )
          ],
        ),
        body: Column(
          children: [
            const Divider(),
            Table(
              children: [
                TableRow(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomDropDown(
                      onChanged: (value) {
                        partNumber = value as int;
                      },
                      labelText: "Part No.",
                      hintText: "Select Part No.",
                      items: partNumbers,
                      selectedValue: partNumber,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomTextBox(controller: voterId, labelText: "Voter's ID", hintText: "Enter Voter's ID"),
                  ),
                ]),
                TableRow(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomTextBox(controller: name, labelText: "Voter's Name", hintText: "Enter Voter's ID"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomTextBox(controller: father, labelText: "Father's Name", hintText: "Enter Voter's ID"),
                  ),
                ])
              ],
            ),
            ElevatedButton(onPressed: setQuery, child: const Text("Search")),
            const Divider(),
            StreamBuilder<QuerySnapshot>(
              stream: query.snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.active && snapshot.hasData) {
                  var docs = snapshot.data!.docs;
                  var voters = docs.map((e) => Voter.fromJson(e.data() as Map<String, dynamic>)).toList();
                  return Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: voters.map((e) => VoterCard(voter: e)).toList(),
                        ),
                      ),
                    ),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class VoterCard extends StatelessWidget {
  const VoterCard({
    Key? key,
    required this.voter,
  }) : super(key: key);
  final Voter voter;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xffe3f1ff),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListRow(property: "Serial Number", value: voter.sNo.toString()),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListRow(property: "Voter ID", value: voter.id.toString()),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListRow(property: "Name", value: voter.name.toString()),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListRow(property: "Father/Husband ", value: voter.father.isEmpty ? voter.husband : voter.father),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListRow(property: "Door Number ", value: voter.door),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListRow(property: "Sex", value: voter.male ? "Male" : "Female"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListRow(property: "Age", value: voter.age.toString()),
            ),
          ],
        ),
      ),
    );
  }
}

class ListRow extends StatelessWidget {
  const ListRow({Key? key, required this.property, required this.value}) : super(key: key);

  final String property;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 5,
            child: Text(property,
                style: const TextStyle(
                  color: Color(0xffe52422),
                  // fontWeight: FontWeight.bold,
                ))),
        Expanded(
            flex: 9,
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xff1b1464),
                // fontWeight: FontWeight.bold,
              ),
            ))
      ],
    );
  }
}
