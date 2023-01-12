import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'ctm_textformfield.dart';

class UpdateUser extends StatefulWidget {
  final String id;

  UpdateUser({required this.id, Key? key}) : super(key: key);

  @override
  State<UpdateUser> createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  final _form = GlobalKey<FormState>();

  //update user at specific id
  CollectionReference Users = FirebaseFirestore.instance.collection('users');
  Future<void> updateUser(id, name, email) {
    return Users.doc(id)
        .update({
          'Name': name,
          'Email': email,
        })
        .then((value) => print('User Updated'))
        .catchError((error) {
          print('Failed to update user :${error}');
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Update User'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
          child: Form(
            key: _form,
            child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.id)
                    .get(),
                builder: (_, snapshot) {
                  if (snapshot.hasError) {
                    print('Something went Wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  var data = snapshot.data!.data();
                  String name = data!['Name'];
                  String email = data['Email'];

                  return Column(
                    children: [
                      ctm_textformfield(
                        keyboardType: TextInputType.name,
                        initialValue: name,
                        onChanged: (value) => name = value,
                        //obscureText: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
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
                        keyboardType: TextInputType.emailAddress,
                        initialValue: email,
                        onChanged: (value) => email = value,
                        //obscureText: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter EmailId';
                          } else if (!EmailValidator.validate(value)) {
                            return 'Please Enter Valid  EmailId';
                          }
                        },
                        labelText: 'Email',
                      ),
                      SizedBox(
                        height: 16,
                      ),

                      SizedBox(
                        height: 56,
                        width: double.maxFinite,
                        child: ElevatedButton(
                            onPressed: () {
                              if (_form.currentState!.validate()) {
                                updateUser(widget.id, name, email);

                                Navigator.pop(context);
                              }
                            },
                            child: Text(
                              'Update User',
                              style: TextStyle(color: Colors.white),
                            )),
                      ),

                      // TextButton(
                      //     style: TextButton.styleFrom(
                      //         backgroundColor: Colors.green
                      //
                      //     ),
                      //     onPressed: () {
                      //       if (_form.currentState!.validate()) {
                      //         updateUser(widget.id, name, email);
                      //
                      //         Navigator.pop(context);
                      //       }
                      //     },
                      //     child: Text(
                      //       'Update User',
                      //       style: TextStyle(color: Colors.white),
                      //     )),
                    ],
                  );
                }),
          ),
        ));
  }
}
