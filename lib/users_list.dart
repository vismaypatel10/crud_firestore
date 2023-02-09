import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_firestore/add_user.dart';
import 'package:crud_firestore/update_user.dart';
import 'package:flutter/material.dart';

class UsersList extends StatefulWidget {
  const UsersList({Key? key}) : super(key: key);

  @override
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('users').snapshots();

  CollectionReference Users = FirebaseFirestore.instance.collection('users');

  Future<void> deleteuser(id) {
    return Users.doc(id)
        .delete()
        .then((value) => print('User Deleted'))
        .catchError((error) {
      print(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Users'), actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white)),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddUser(),
                    ));
              },
              child: Text(
                "Add Users",
                style: TextStyle(color: Colors.black),
              ),
            ),
          )
        ]),
        body: StreamBuilder<QuerySnapshot>(
            stream: _usersStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              final List storedocs = [];
              snapshot.data!.docs.map(
                (DocumentSnapshot document) {
                  Map data = document.data() as Map<String, dynamic>;
                  storedocs.add(data);
                  data['id'] = document.id;
                },
              ).toList();
              return ListView.builder(
                itemCount: storedocs.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: GlobalKey(),
                    background: Container(
                        margin: EdgeInsets.all(15),
                        padding: EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10)),
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.delete,
                          size: 30,
                          color: Colors.white,
                        )),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      deleteuser(storedocs[index]['id']).then((value) =>
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('User Deleted'))));
                    },
                    child: Container(
                      margin: EdgeInsets.all(15),
                      height: 100,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Name : ${storedocs[index]['Name']}',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Text(
                                'Email : ${storedocs[index]['Email']}',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => UpdateUser(
                                            id: storedocs[index]['id'],
                                          ),
                                        ));
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.green,
                                  )),
                              // IconButton(
                              //     onPressed: () {
                              //       deleteuser(storedocs[index]['id']).then(
                              //           (value) => ScaffoldMessenger.of(context)
                              //               .showSnackBar(SnackBar(
                              //                   content:
                              //                       Text('User Deleted'))));
                              //     },
                              //     icon: Icon(
                              //       Icons.delete,
                              //       color: Colors.red,
                              //     ))
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            }));
  }
}
