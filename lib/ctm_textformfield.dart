import 'package:flutter/material.dart';

class ctm_textformfield extends StatefulWidget {
  void Function()? onTap;
  String? Function(String?)? validator;
  // bool obscureText;
  TextEditingController? controller;
  void Function(String)? onChanged;
  String? initialValue;
  TextInputType? keyboardType;
  String labelText;

  ctm_textformfield(
      {this.onTap,
      //required this.obscureText,
      this.keyboardType,
      this.onChanged,
      this.initialValue,
      this.validator,
      this.controller,
      required this.labelText,
      Key? key})
      : super(key: key);

  @override
  State<ctm_textformfield> createState() => _ctm_textformfieldState();
}

class _ctm_textformfieldState extends State<ctm_textformfield> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: widget.onTap,
      validator: widget.validator,
      //obscureText: obscureText,
      controller: widget.controller,
      onChanged: widget.onChanged,
      initialValue: widget.initialValue,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
          labelText: widget.labelText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );
  }
}
