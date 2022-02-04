import 'package:flutter/material.dart';
import 'package:voterslist/model/voter.dart';
import 'package:voterslist/widgets.dart';

class VoterAddition extends StatefulWidget {
  VoterAddition({Key? key}) : super(key: key);

  @override
  State<VoterAddition> createState() => _VoterAdditionState();
}

class _VoterAdditionState extends State<VoterAddition> {
  bool sex = true;
  final sNo = TextEditingController();
  final name = TextEditingController();
  final id = TextEditingController();
  final father = TextEditingController();
  final husband = TextEditingController();
  final door = TextEditingController();
  final age = TextEditingController();
  final part = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _requiredValidator(value) {
    value = value ?? '';
    var s = value.isEmpty ? "Name is required field" : null;
    return s;
  }

  String? _commonRequiredValidator(value) {
    if (father.text.isEmpty && husband.text.isEmpty) {
      return "Either father name or Husband name is required";
    }
  }

  String? _requiredINteger(value) {
    var number = int.tryParse(value);
    if (number == null) {
      return "Age should be integer";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
              onPressed: () {
                Voter.loadDummyData();
              },
              child: const Text("Load DAta")),
          ElevatedButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  var voter = Voter(
                    name: name.text,
                    id: id.text,
                    door: door.text,
                    age: int.parse(age.text),
                    partNumber: int.parse(part.text),
                    male: sex,
                    husband: husband.text,
                    father: father.text,
                    sNo: int.parse(sNo.text),
                  );
                  showFutureDialog(
                      context: context,
                      future: voter.add(),
                      callback: () {
                        sNo.text = (int.parse(sNo.text) + 1).toString();
                        name.clear();
                        id.clear();
                        father.clear();
                        husband.clear();
                        door.clear();
                        age.clear();
                        Navigator.of(context).pop();
                      });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please check the fields")));
                }
              },
              child: const Text("Submit")),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Row(
        children: [
          Expanded(child: Container()),
          SizedBox(
            width: 380,
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    ListTile(
                      title: const Text("S No"),
                      subtitle: CustomTextBox(
                        controller: sNo,
                        keyboardType: TextInputType.number,
                        hintText: '',
                        labelText: '',
                        validator: _requiredINteger,
                      ),
                    ),
                    ListTile(
                      title: const Text("Part No"),
                      subtitle: CustomTextBox(
                        controller: part,
                        keyboardType: TextInputType.number,
                        hintText: '',
                        labelText: '',
                        validator: _requiredINteger,
                      ),
                    ),
                    ListTile(
                      title: const Text("Name"),
                      subtitle: CustomTextBox(
                        controller: name,
                        hintText: '',
                        labelText: '',
                        validator: _requiredValidator,
                      ),
                    ),
                    ListTile(
                      title: const Text("Voter's ID"),
                      subtitle: CustomTextBox(
                        controller: id,
                        hintText: '',
                        labelText: '',
                        validator: _requiredValidator,
                      ),
                    ),
                    Table(
                      children: [
                        TableRow(
                          children: [
                            ListTile(
                              title: const Text("father"),
                              subtitle: CustomTextBox(
                                controller: father,
                                hintText: '',
                                labelText: '',
                                validator: _commonRequiredValidator,
                              ),
                            ),
                            ListTile(
                              title: const Text("husband"),
                              subtitle: CustomTextBox(
                                controller: husband,
                                hintText: '',
                                labelText: '',
                                validator: _commonRequiredValidator,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    ListTile(
                      title: const Text("door"),
                      subtitle: CustomTextBox(
                        controller: door,
                        hintText: '',
                        labelText: '',
                        validator: _requiredValidator,
                      ),
                    ),
                    ListTile(
                      title: const Text("age"),
                      subtitle: CustomTextBox(
                        controller: age,
                        keyboardType: TextInputType.number,
                        hintText: '',
                        labelText: '',
                        validator: _requiredINteger,
                      ),
                    ),
                    ListTile(
                      title: const Text("Sex"),
                      subtitle: Row(
                        children: [
                          const Text("Male"),
                          Radio<bool>(
                            value: true,
                            groupValue: sex,
                            onChanged: (bool? value) {
                              setState(() {
                                sex = value!;
                              });
                            },
                          ),
                          const Text("Female"),
                          Radio<bool>(
                            value: false,
                            groupValue: sex,
                            onChanged: (bool? value) {
                              setState(() {
                                sex = value!;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(child: Container()),
        ],
      ),
    );
  }
}
