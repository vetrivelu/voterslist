import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:voterslist/widgets.dart';

import 'model/voter.dart';

CollectionReference<Map<String, dynamic>> users = firestore.collection('Voters');

class VotersList extends StatefulWidget {
  VotersList({Key? key}) : super(key: key);

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

  List<int> getNumbers() {
    List<int> numbers = [];
    for (var i = 1; i < 100; i++) {
      numbers.add(i);
    }
    return numbers;
  }

  get partNumbers => getNumbers().map((e) => DropdownMenuItem(value: e, child: Text(e.toString()))).toList();

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
                      child: Column(
                        children: voters.map((e) => VoterCard(voter: e)).toList(),
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
      color: Colors.blueGrey.shade100,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListRow(property: "Serial Number", Value: voter.sNo.toString()),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListRow(property: "Voter ID", Value: voter.id.toString()),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListRow(property: "Name", Value: voter.name.toString()),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListRow(property: "Father/Husband ", Value: voter.father.isEmpty ? voter.husband : voter.father),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListRow(property: "Door Number ", Value: voter.door),
            ),
            Table(
              // border: TableBorder.symmetric(outside: const BorderSide(color: Colors.black, width: 1.0)),
              children: [
                TableRow(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListRow(property: "Sex", Value: voter.male ? "Male" : "Female"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListRow(property: "Age", Value: voter.age.toString()),
                  ),
                ])
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ListRow extends StatelessWidget {
  const ListRow({Key? key, required this.property, required this.Value}) : super(key: key);

  final String property;
  final String Value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 4, child: Text(property, style: const TextStyle(fontWeight: FontWeight.bold))),
        Expanded(flex: 8, child: Text(Value))
      ],
    );
  }
}
