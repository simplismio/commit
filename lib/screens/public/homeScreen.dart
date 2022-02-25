// ignore_for_file: deprecated_member_use

import 'package:commit/shares/loadingShare.dart';
import 'package:flutter/material.dart';
import 'package:commit/screens/public/detailPage.dart';
import 'package:commit/services/authenticationService.dart';
import 'package:commit/services/localAuthenticationService.dart';
import 'package:commit/services/themeService.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool loading = false;

  final Stream<QuerySnapshot> _commitmentStream = FirebaseFirestore.instance
      .collection('commitments')
      .snapshots(includeMetadataChanges: true);

  CollectionReference commitments =
      FirebaseFirestore.instance.collection('commitments');

  Future<void> deleteCommitment(key) {
    return commitments
        .doc(key)
        .delete()
        .then((value) => print("Commitment deleted"))
        .catchError((error) => print("Failed to delete user: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(
                Icons.menu_rounded,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: const Text('Home',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins-Bold',
            )),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
              icon: const Icon(
                Icons.notifications,
              ),
              onPressed: () {
                showMaterialModalBottomSheet(
                  expand: false,
                  context: context,
                  backgroundColor: Colors.white,
                  builder: (context) =>
                      Container(child: const Text('Show notifications')),
                );
              }),
          IconButton(
              icon: const Icon(
                Icons.add,
                size: 35.0,
              ),
              onPressed: () {
                showMaterialModalBottomSheet(
                    expand: false,
                    context: context,
                    builder: (context) => Container(
                        height: 300,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: NewCommitment(),
                        )));
              }),
        ],
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 20, 10, 5),
                child: Row(
                  children: <Widget>[
                    const Text(
                      "Just in",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins-Bold',
                      ),
                    ),
                    const Spacer(),
                    Container(
                      child: const Text(
                        "Sort by",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins-Bold',
                        ),
                      ),
                    ),
                    Builder(
                      builder: (context) {
                        return IconButton(
                          icon: const Icon(Icons.sort),
                          onPressed: () {
                            Scaffold.of(context).openEndDrawer();
                          },
                        );
                      },
                    )
                  ],
                ),
              ),
              const SizedBox(height: 5.0),
              GestureDetector(
                  onTap: () {
                    setState(() {
                      Get.to(const DetailPage());
                      //_lights = true;
                    });
                  },
                  child: StreamBuilder<QuerySnapshot>(
                      stream: _commitmentStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('Something went wrong');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text("Loading");
                        }
                        return ListView(
                          shrinkWrap: true, // use this
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            Map<String, dynamic> data =
                                document.data()! as Map<String, dynamic>;
                            return ListTile(
                              // leading: CachedNetworkImage(
                              //   imageUrl: "",
                              //   placeholder: (context, url) =>
                              //       const CircularProgressIndicator(),
                              //   errorWidget: (context, url, error) =>
                              //       const Icon(Icons.error),
                              // ),
                              title: Text(
                                data['description'],
                                style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'Poppins-Bold',
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: const Text(
                                'A sufficiently long subtitle warrants .',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'Poppins-Regular',
                                    fontWeight: FontWeight.bold),
                              ),
                              trailing: Wrap(
                                children: <Widget>[
                                  Column(
                                    children: [
                                      IconButton(
                                          icon: const Icon(
                                            Icons.edit,
                                            size: 25.0,
                                          ),
                                          onPressed: () {
                                            showMaterialModalBottomSheet(
                                                expand: false,
                                                context: context,
                                                builder: (context) => Container(
                                                    height: 300,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              15.0),
                                                      child: EditCommitment(
                                                        commitmentKey:
                                                            document.id,
                                                        currentDescription:
                                                            data['description'],
                                                      ),
                                                    )));
                                          }),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            size: 25.0,
                                          ),
                                          onPressed: () {
                                            deleteCommitment(document.id);
                                          }),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        );

                        // child: Card(
                        //     child: Padding(
                        //   padding: const EdgeInsets.all(7.0),
                        //   child: ListTile(
                        //     leading: CachedNetworkImage(
                        //       imageUrl: "",
                        //       placeholder: (context, url) =>
                        //           const CircularProgressIndicator(),
                        //       errorWidget: (context, url, error) =>
                        //           const Icon(Icons.error),
                        //     ),
                        //     title: const Text(
                        //       "This is my ListTile",
                        //       style: TextStyle(
                        //           fontSize: 20,
                        //           fontFamily: 'Poppins-Bold',
                        //           fontWeight: FontWeight.bold),
                        //     ),
                        //     subtitle: const Text(
                        //       'A sufficiently long subtitle warrants .',
                        //       style: TextStyle(
                        //           fontSize: 15,
                        //           fontFamily: 'Poppins-Regular',
                        //           fontWeight: FontWeight.bold),
                        //     ),
                        //     trailing: Wrap(
                        //       spacing: 12, // space between two icons
                        //       children: <Widget>[
                        //         Column(
                        //           children: [
                        //             const Icon(Icons.mobile_friendly),
                        //             const SizedBox(height: 5.0),
                        //             const Icon(Icons.mobile_friendly),
                        //           ],
                        //         ), // icon-1
                        //         Column(
                        //           children: [
                        //             const Icon(Icons.mobile_friendly),
                        //             const SizedBox(height: 5.0),
                        //             const Icon(Icons.mobile_friendly),
                        //           ],
                        //         ),

                        //         // icon-2
                        //       ],
                        //     ),
                        //     //isThreeLine: true,
                        //   ),
                        // )),
                      })),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: Container(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: [
                    const Positioned(
                      top: 30.0,
                      left: 90.0,
                      child: CircleAvatar(
                        radius: 50,
                        child: const Icon(Icons.person,
                            size: 60, color: Colors.grey),
                      ),
                    ),
                    const Positioned(
                      child: const Text(
                        'Username',
                        style: TextStyle(
                          fontFamily: 'Poppins-Bold',
                          fontSize: 30,
                        ),
                      ),
                      top: 150,
                      left: 60,
                    ),
                  ],
                ),
              ),
              Consumer<ThemeService>(
                builder: (context, theme, child) => SwitchListTile(
                  title: const Text("Dark Mode"),
                  onChanged: (value) {
                    theme.toggleTheme();
                  },
                  value: theme.darkTheme,
                ),
              ),
              Consumer<LocalAuthenticationService>(
                builder: (context, localAuthentication, child) =>
                    SwitchListTile(
                  title: const Text("Biometric Unlock"),
                  onChanged: (value) {
                    localAuthentication.toggleBiometrics();
                  },
                  value: localAuthentication.biometrics,
                ),
              ),
              const Divider(
                color: Colors.white,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 0, 0, 0),
                    child: GestureDetector(
                        child: const Text("Log Out", style: const TextStyle()),
                        onTap: () {
                          setState(() => loading = true);
                          AuthenticationService().signOut().then((result) {
                            Get.back();
                          });
                        }),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      endDrawer: Drawer(
        child: Container(
            child: Container(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    const Text(
                      'Sort',
                      style: const TextStyle(
                        fontFamily: 'Poppins-Bold',
                        fontSize: 30,
                      ),
                    ),
                    const SizedBox(height: 50),
                    const Text(
                      'Sort',
                      style: const TextStyle(
                        fontFamily: 'Poppins-Regular',
                        fontSize: 20,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        )),
      ),
    ));
  }
}

class NewCommitment extends StatefulWidget {
  const NewCommitment({Key? key}) : super(key: key);

  @override
  _NewCommitmentState createState() => _NewCommitmentState();
}

class _NewCommitmentState extends State<NewCommitment> {
  final _formKeyForm = GlobalKey<FormState>();
  bool loading = false;
  String error = '';

  String? description;

  @override
  Widget build(BuildContext context) {
    CollectionReference commitments =
        FirebaseFirestore.instance.collection('commitments');

    Future<void> addCommitment() {
      return commitments
          .add({'description': description})
          .then((value) => print("Commitment Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }

    return loading
        ? LoadingShare()
        : Scaffold(
            body: Padding(
              padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
              child: Form(
                  key: _formKeyForm,
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 20.0),
                      const Text('New commitment',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 25.0, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 5.0),
                      TextFormField(
                          decoration:
                              const InputDecoration(hintText: "New commitment"),
                          textAlign: TextAlign.left,
                          autofocus: true,
                          validator: (String? value) {
                            //print(value.length);
                            return (value != null && value.length < 2)
                                ? 'Please provide a valid commitment.'
                                : null;
                          },
                          onChanged: (val) {
                            setState(() => description = val);
                          }),
                      const SizedBox(height: 10.0),
                      ButtonTheme(
                        minWidth: 330.0,
                        height: 50.0,
                        child: ElevatedButton(
                          child: const Text(
                            "Add commitment",
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () async {
                            if (_formKeyForm.currentState!.validate()) {
                              setState(() => loading = true);
                              addCommitment();
                              Get.back();
                            } else {
                              setState(() {
                                loading = false;
                                error = 'Something went wrong.';
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  )),
            ),
          );
  }
}

class EditCommitment extends StatefulWidget {
  final currentDescription;
  final commitmentKey;

  const EditCommitment({Key? key, this.commitmentKey, this.currentDescription})
      : super(key: key);

  @override
  _EditCommitmentState createState() => _EditCommitmentState();
}

class _EditCommitmentState extends State<EditCommitment> {
  final _formKeyForm = GlobalKey<FormState>();
  bool loading = false;
  String error = '';

  String? description;

  @override
  Widget build(BuildContext context) {
    CollectionReference commitments =
        FirebaseFirestore.instance.collection('commitments');

    Future<void> editCommitment() {
      return commitments
          .doc(widget.commitmentKey)
          .update({'description': description})
          .then((value) => print("Commitment updated"))
          .catchError((error) => print("Failed to merge data: $error"));
    }

    return loading
        ? LoadingShare()
        : Scaffold(
            body: Padding(
              padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
              child: Form(
                  key: _formKeyForm,
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 20.0),
                      const Text('Edit commitment',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 25.0, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 5.0),
                      TextFormField(
                          decoration: const InputDecoration(
                              hintText: "Edit commitment"),
                          textAlign: TextAlign.left,
                          initialValue: widget.currentDescription,
                          autofocus: true,
                          validator: (String? value) {
                            //print(value.length);
                            return (value != null && value.length < 2)
                                ? 'Please provide a valid commitment.'
                                : null;
                          },
                          onChanged: (val) {
                            setState(() => description = val);
                          }),
                      const SizedBox(height: 10.0),
                      ButtonTheme(
                        minWidth: 330.0,
                        height: 50.0,
                        child: ElevatedButton(
                          child: const Text(
                            "Edit commitment",
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () async {
                            if (_formKeyForm.currentState!.validate()) {
                              setState(() => loading = true);
                              editCommitment();
                              Get.back();
                            } else {
                              setState(() {
                                loading = false;
                                error = 'Something went wrong.';
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  )),
            ),
          );
  }
}
