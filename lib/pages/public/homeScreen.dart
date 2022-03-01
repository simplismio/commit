// ignore_for_file: deprecated_member_use, file_names, avoid_print, prefer_typing_uninitialized_variables, prefer_const_constructors

import 'package:commit/services/dataService.dart';
import 'package:commit/shares/loadingShare.dart';
import 'package:flutter/material.dart';
import 'package:commit/screens/public/detailPage.dart';
import 'package:commit/services/authenticationService.dart';
import 'package:commit/services/localAuthenticationService.dart';
import 'package:commit/services/themeService.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  builder: (context) => const Text('Show notifications'),
                );
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
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins-Bold',
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      "Sort by",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins-Bold',
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
              StreamBuilder<QuerySnapshot>(
                  stream: DataService().commitmentStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text('Loading');
                    }
                    return ListView(
                      shrinkWrap: true, // use this
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        return Builder(builder: (context) {
                          return Dismissible(
                            key: ValueKey<String>(document.id),
                            background: Container(
                              color: Colors.blue,
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Row(
                                  children: const [
                                    Icon(Icons.edit, color: Colors.white),
                                    SizedBox(width: 10),
                                    Text('Edit commitment',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ),
                            secondaryBackground: Container(
                              color: Colors.red,
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: const [
                                    Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 10),
                                    Text('Delete commitment',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ),
                            confirmDismiss: (direction) async {
                              if (direction == DismissDirection.startToEnd) {
                                /// edit item
                                showMaterialModalBottomSheet(
                                    expand: false,
                                    context: context,
                                    builder: (context) => SizedBox(
                                        height: 300,
                                        child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: EditCommitment(
                                            commitmentKey: document.id,
                                            currentDescription:
                                                data['description'],
                                          ),
                                        )));
                                return false;
                              } else if (direction ==
                                  DismissDirection.endToStart) {
                                DataService().deleteCommitment(document.id);
                                print('Remove commitment');
                                return true;
                              }
                              return null;
                            },
                            child: GestureDetector(
                              onTap: () {
                                Get.to(DetailPage(
                                    description: data['description']));
                              },
                              child: Card(
                                margin: const EdgeInsets.fromLTRB(5, 1, 5, 5),
                                child: ListTile(
                                  // leading: CachedNetworkImage(
                                  //   imageUrl: "",
                                  //   placeholder: (context, url) =>
                                  //       const CircularProgressIndicator(),
                                  //   errorWidget: (context, url, error) =>
                                  //       const Icon(Icons.error),
                                  // ),
                                  title: Text(
                                    data['description'],
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontFamily: 'Poppins-Bold',
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: const Text(
                                    'A sufficiently long subtitle warrants.',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontFamily: 'Poppins-Regular',
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          );
                        });
                      }).toList(),
                    );
                  }),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: const [
                  Positioned(
                    top: 30.0,
                    left: 90.0,
                    child: CircleAvatar(
                      radius: 50,
                      child: Icon(Icons.person, size: 60, color: Colors.grey),
                    ),
                  ),
                  Positioned(
                    child: Text(
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
                title: const Text(
                  "Dark Mode",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onChanged: (value) {
                  theme.toggleTheme();
                },
                value: theme.darkTheme != false ? true : false,
              ),
            ),
            Consumer<LocalAuthenticationService>(
              builder: (context, localAuthentication, child) => SwitchListTile(
                title: const Text(
                  "Biometric Unlock",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
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
                      child: const Text(
                        "Log Out",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
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
      endDrawer: Drawer(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: const [
                  SizedBox(height: 50),
                  Text(
                    'Sort',
                    style: TextStyle(
                      fontFamily: 'Poppins-Bold',
                      fontSize: 30,
                    ),
                  ),
                  SizedBox(height: 50),
                  Text(
                    'Sort',
                    style: TextStyle(
                      fontFamily: 'Poppins-Regular',
                      fontSize: 20,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add), //child widget inside this button
        onPressed: () {
          showMaterialModalBottomSheet(
              expand: false,
              context: context,
              builder: (context) =>
                  const SizedBox(height: 300, child: NewCommitment()));
        },
      ),
    );
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
                      SizedBox(
                        width: 300,
                        child: ElevatedButton(
                          child: const Text(
                            "Add commitment",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () async {
                            if (_formKeyForm.currentState!.validate()) {
                              setState(() => loading = true);
                              DataService().addCommitment(description);
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
                            return (value != null && value.length < 2)
                                ? 'Please provide a valid commitment.'
                                : null;
                          },
                          onChanged: (val) {
                            setState(() => description = val);
                          }),
                      const SizedBox(height: 10.0),
                      SizedBox(
                        width: 300,
                        child: ElevatedButton(
                          child: const Text(
                            "Edit commitment",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () async {
                            if (_formKeyForm.currentState!.validate()) {
                              setState(() => loading = true);
                              DataService().editCommitment(
                                  widget.commitmentKey, description);
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
