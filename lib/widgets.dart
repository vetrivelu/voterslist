import 'package:flutter/material.dart';

import 'model/response.dart';

class CustomTextBox extends StatelessWidget {
  const CustomTextBox(
      {Key? key,
      required this.controller,
      required this.labelText,
      required this.hintText,
      this.keyboardType = TextInputType.text,
      this.onChanged,
      this.onTap,
      // this.leftPad = 20,
      this.maxLines,
      this.validator,
      this.enabled})
      : super(key: key);

  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final TextInputType keyboardType;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final String? Function(String?)? validator;
  // final double? leftPad;
  final int? maxLines;
  final bool? enabled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines,
      onChanged: onChanged,
      validator: validator,
      onTap: onTap,
      keyboardType: keyboardType,
      enabled: enabled,
      controller: controller,
      obscureText: false,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
          fontFamily: 'Lexend Deca',
          color: Color(0xFFEF4C43),
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
          fontFamily: 'Lexend Deca',
          color: Color(0xFF95A1AC),
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0xFFDBE2E7),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0xFFDBE2E7),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsetsDirectional.fromSTEB(20, 24, 0, 24),
      ),
      style: const TextStyle(
        fontFamily: 'Lexend Deca',
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
    );
  }
}

showFutureDialog({required BuildContext context, required Future<dynamic> future, void Function()? callback}) {
  print("I am in future dialog");
  showDialog(
      context: context,
      builder: (context) {
        return FutureBuilder(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active || snapshot.connectionState == ConnectionState.done) {
                var response = snapshot.data as Response;
                return AlertDialog(
                  title: Text(response.code),
                  content: Text(response.message),
                  actions: [
                    ElevatedButton(
                        onPressed: callback ??
                            () {
                              Navigator.of(context).pop();
                            },
                        child: Text("Okay"))
                  ],
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            });
      });
}

class CustomDropDown extends StatelessWidget {
  const CustomDropDown({
    Key? key,
    required this.labelText,
    required this.hintText,
    required this.items,
    this.onChanged,
    this.onTap,
    this.leftPad = 20,
    required this.selectedValue,
  }) : super(key: key);

  final String labelText;
  final String hintText;
  final Object? selectedValue;

  final void Function(Object?)? onChanged;
  final void Function()? onTap;
  final double? leftPad;

  final List<DropdownMenuItem<Object>>? items;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      isExpanded: false,
      value: selectedValue,
      onChanged: onChanged,
      onTap: onTap,
      decoration: InputDecoration(
        constraints: const BoxConstraints.expand(height: 65),
        labelText: labelText,
        labelStyle: const TextStyle(
          fontFamily: 'Lexend Deca',
          color: Color(0xFF138AEB),
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
          fontFamily: 'Lexend Deca',
          color: Color(0xFF95A1AC),
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0xFFDBE2E7),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0xFFDBE2E7),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsetsDirectional.fromSTEB(20, 24, 0, 24),
      ),
      style: const TextStyle(
        fontFamily: 'Lexend Deca',
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
      items: items,
    );
  }
}
