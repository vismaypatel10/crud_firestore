import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_firestore/ctm_textformfield.dart';
import 'package:crud_firestore/users_list.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class AddUser extends StatefulWidget {
  const AddUser({Key? key}) : super(key: key);

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final _form = GlobalKey<FormState>();

  var name = '';
  var email = '';

  TextEditingController NameController = TextEditingController();
  TextEditingController EmailController = TextEditingController();

  CollectionReference Users = FirebaseFirestore.instance.collection('users');

  Future<void> AddUser() {
    return Users.add({
      'Name': name,
      'Email': email,
    })
        .then((value) => print('User Added'))
        .catchError((error) => print("Failed to add user : $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
          height: 56,
          margin: EdgeInsets.all(16),
          color: Colors.blue,
          child: TextButton(
              onPressed: () {
                if (_form.currentState!.validate()) {
                  setState(() {
                    name = NameController.text;
                    email = EmailController.text;
                  });
                  AddUser();
                  Navigator.pop(context);
                }
              },
              child: Text(
                'Add User',
                style: TextStyle(color: Colors.white),
              ))),
      appBar: AppBar(
        title: Text('Add User'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
        child: Form(
          key: _form,
          child: Column(
            children: [
              ctm_textformfield(
                controller: NameController,
                //obscureText: false,
                validator: (name) {
                  if (name == null || name.isEmpty) {
                    return 'Please Enter Name';
                  } else {
                    return null;
                  }
                },
                labelText: 'Name',
              ),
              SizedBox(
                height: 16,
              ),
              ctm_textformfield(
                controller: EmailController,
                //obscureText: false,
                validator: (email) {
                  if (email == null || email.isEmpty) {
                    return 'Please Enter EmailId';
                  } else if (!EmailValidator.validate(email)) {
                    return 'Please Enter Valid  EmailId';
                  }
                },
                labelText: 'Email',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
