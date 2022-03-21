import '../services/contract_service.dart';
import '../../services/user_service.dart';
import '../../services/local_authentication_service.dart';
import '../../services/theme_service.dart';
import '../utilities/authorization_utility.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kDebugMode, defaultTargetPlatform;

import 'edit_commitment_screen.dart';
import 'edit_contract_screen.dart';
import 'new_contract_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();

    for (var i = 0; i < 50; i++) {
      _toggleCommitments[i] = false;
    }
  }

  bool loading = false;

  final double breakpoint = 600;
  final int paneProportion = 70;

  final Map<int, bool> _toggleCommitments = {};
  bool _toggleCommitmentsValue = false;

  toggleCommitments(int _index, bool _value) async {
    _toggleCommitmentsValue = _value;
    _toggleCommitments[_index] = _value;
  }

  @override
  Widget build(BuildContext context) {
    List _contracts = Provider.of<List<ContractService>>(context, listen: true);
    ThemeService _theme = Provider.of<ThemeService>(context, listen: true);

    mobileView() {
      return SizedBox(
          height: double.maxFinite,
          width: double.maxFinite,
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: _contracts.length,
              itemBuilder: (BuildContext context, int contractIndex) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Dismissible(
                            key:
                                ValueKey<String>(_contracts[contractIndex].key),
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
                                ///
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            EditContractScreen(
                                              contract:
                                                  _contracts[contractIndex],
                                            )));
                                return false;
                              } else if (direction ==
                                  DismissDirection.endToStart) {
                                ContractService().deleteContract(
                                    _contracts[contractIndex].key);
                                if (kDebugMode) {
                                  print('Remove commitment');
                                }
                                return true;
                              }
                              return null;
                            },
                            child: GestureDetector(
                              onTap: (() {
                                setState(() {
                                  toggleCommitments(
                                      contractIndex, !_toggleCommitmentsValue);
                                });
                              }),
                              child: Card(
                                margin: const EdgeInsets.fromLTRB(5, 1, 5, 5),
                                child: ListTile(
                                  isThreeLine: true,

                                  // leading: CachedNetworkImage(
                                  //   imageUrl: "",
                                  //   placeholder: (context, url) =>
                                  //       const CircularProgressIndicator(),
                                  //   errorWidget: (context, url, error) =>
                                  //       const Icon(Icons.error),
                                  // ),
                                  title: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(5, 10, 5, 10),
                                    child: Text(
                                      _contracts[contractIndex].title,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  subtitle: Column(
                                    children: <Widget>[
                                      _toggleCommitments[contractIndex] == false
                                          ? Container()
                                          : SizedBox(
                                              child: ListView.builder(
                                                  shrinkWrap: true,
                                                  physics:
                                                      const ClampingScrollPhysics(),
                                                  itemCount:
                                                      _contracts[contractIndex]
                                                          .commitments
                                                          .length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int commitmentIndex) {
                                                    // return Text(commitmentList[index].description);
                                                    return Dismissible(
                                                      key: ValueKey<int>(
                                                          commitmentIndex),
                                                      background: Container(
                                                        color: Colors.blue,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(15),
                                                          child: Row(
                                                            children: const [
                                                              Icon(Icons.edit,
                                                                  color: Colors
                                                                      .white),
                                                              SizedBox(
                                                                  width: 10),
                                                              Text(
                                                                  'Edit commitment',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      secondaryBackground:
                                                          Container(
                                                        color: Colors.red,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(15),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: const [
                                                              Icon(
                                                                Icons.delete,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              SizedBox(
                                                                  width: 10),
                                                              Text(
                                                                  'Delete commitment',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      confirmDismiss:
                                                          (direction) async {
                                                        if (direction ==
                                                            DismissDirection
                                                                .startToEnd) {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    EditCommitmentScreen(
                                                                  contractKey:
                                                                      _contracts[
                                                                              contractIndex]
                                                                          .key,
                                                                  commitmentArray:
                                                                      _contracts[
                                                                              contractIndex]
                                                                          .commitments,
                                                                  commitmentIndex:
                                                                      commitmentIndex,
                                                                ),
                                                              ));
                                                          return false;
                                                        } else if (direction ==
                                                            DismissDirection
                                                                .endToStart) {
                                                          ContractService()
                                                              .deleteCommitment(_contracts[
                                                                      contractIndex]
                                                                  .commitments[
                                                                      commitmentIndex]
                                                                  .key);
                                                          if (kDebugMode) {
                                                            print(
                                                                'Remove commitment');
                                                          }
                                                          return true;
                                                        }
                                                        return null;
                                                      },
                                                      child: Card(
                                                        color:
                                                            _theme.darkTheme ==
                                                                    true
                                                                ? Colors
                                                                    .grey[700]
                                                                : Colors
                                                                    .grey[200],
                                                        child: ListTile(
                                                          // leading: CachedNetworkImage(
                                                          //   imageUrl: "",
                                                          //   placeholder: (context, url) =>
                                                          //       const CircularProgressIndicator(),
                                                          //   errorWidget: (context, url, error) =>
                                                          //       const Icon(Icons.error),
                                                          // ),
                                                          title: Text(
                                                            _contracts[contractIndex]
                                                                        .commitments[
                                                                    commitmentIndex]
                                                                ['commitment'],
                                                            style: const TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          subtitle: const Text(
                                                            'subtitle.',
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  scrollDirection:
                                                      Axis.vertical)),
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                                  //subtitle:
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
              scrollDirection: Axis.vertical));
    }

    desktopView() {
      return SizedBox(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: GridView(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
              ),
              primary: false,
              shrinkWrap: true,
              children: List<Widget>.generate(
                  _contracts.length, // same length as the data
                  (contractIndex) => GestureDetector(
                        onTap: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (BuildContext
                          //                 context) =>
                          //             CommitmentScreen(
                          //                 contract: _contracts[
                          //                         index]
                          //                     .key)));
                        },
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: GridTile(
                              // footer: Text(
                              //   _contracts[
                              //           contractIndex]
                              //       .description,
                              //   style: const TextStyle(
                              //       fontSize: 14,
                              //       fontWeight:
                              //           FontWeight
                              //               .bold),
                              // ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        5, 15.0, 5, 25.0),
                                    child: Text(_contracts[contractIndex].title,
                                        style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  SizedBox(
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const ClampingScrollPhysics(),
                                          itemCount: _contracts[contractIndex]
                                              .commitments
                                              .length,
                                          itemBuilder: (BuildContext context,
                                              int commitmentIndex) {
                                            // return Text(commitmentList[index].title);
                                            return Dismissible(
                                              key: ValueKey<int>(
                                                  commitmentIndex),
                                              background: Container(
                                                color: Colors.blue,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(15),
                                                  child: Row(
                                                    children: const [
                                                      Icon(Icons.edit,
                                                          color: Colors.white),
                                                      SizedBox(width: 10),
                                                      Text('Edit commitment',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              secondaryBackground: Container(
                                                color: Colors.red,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(15),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: const [
                                                      Icon(
                                                        Icons.delete,
                                                        color: Colors.white,
                                                      ),
                                                      SizedBox(width: 10),
                                                      Text('Delete commitment',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              confirmDismiss:
                                                  (direction) async {
                                                if (direction ==
                                                    DismissDirection
                                                        .startToEnd) {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            EditCommitmentScreen(
                                                          contractKey: _contracts[
                                                                  contractIndex]
                                                              .key,
                                                          commitmentArray:
                                                              _contracts[
                                                                      contractIndex]
                                                                  .commitments,
                                                          commitmentIndex:
                                                              commitmentIndex,
                                                        ),
                                                      ));
                                                  return false;
                                                } else if (direction ==
                                                    DismissDirection
                                                        .endToStart) {
                                                  ContractService()
                                                      .deleteCommitment(
                                                          _contracts[
                                                                  contractIndex]
                                                              .commitments[
                                                                  commitmentIndex]
                                                              .key);
                                                  if (kDebugMode) {
                                                    print('Remove commitment');
                                                  }
                                                  return true;
                                                }
                                                return null;
                                              },
                                              child: Card(
                                                color: _theme.darkTheme == true
                                                    ? Colors.grey[700]
                                                    : Colors.grey[200],
                                                child: ListTile(
                                                  // leading: CachedNetworkImage(
                                                  //   imageUrl: "",
                                                  //   placeholder: (context, url) =>
                                                  //       const CircularProgressIndicator(),
                                                  //   errorWidget: (context, url, error) =>
                                                  //       const Icon(Icons.error),
                                                  // ),
                                                  title: Text(
                                                    _contracts[contractIndex]
                                                                .commitments[
                                                            commitmentIndex]
                                                        ['commitment'],
                                                    style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  subtitle: const Text(
                                                    'subtitle.',
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                          scrollDirection: Axis.vertical)),
                                ],
                              ),

                              //just for testing, will fill with image later
                            ),
                          ),
                        ),
                      ))),
        ),
      );
    }

    drawerLeft() {
      return Drawer(
        child: Column(
          children: [
            const SizedBox(height: 100),
            Container(
              alignment: Alignment.topLeft,
              child: const Padding(
                padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                child: Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 100),

            // SizedBox(
            //   height: MediaQuery.of(context).size.height * 0.3,
            //   width: MediaQuery.of(context).size.width,
            //   child: Stack(
            //     children: const [
            //       Positioned(
            //         top: 30.0,
            //         left: 90.0,
            //         child: CircleAvatar(
            //           radius: 50,
            //           child: Icon(Icons.person, size: 60, color: Colors.grey),
            //         ),
            //       ),
            //       Positioned(
            //         child: Text(
            //           'Username',
            //           style: TextStyle(
            //             fontSize: 30,
            //           ),
            //         ),
            //         top: 150,
            //         left: 60,
            //       ),
            //     ],
            //   ),
            // ),
            Consumer<ThemeService>(
              builder: (context, theme, child) => SwitchListTile(
                title: const Text(
                  "Dark Mode",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onChanged: (value) {
                  theme.toggleTheme();
                },
                value: theme.darkTheme,
              ),
            ),
            defaultTargetPlatform == TargetPlatform.iOS ||
                    defaultTargetPlatform == TargetPlatform.android
                ? Consumer<LocalAuthenticationService>(
                    builder: (context, localAuthentication, child) =>
                        SwitchListTile(
                      title: const Text(
                        "Biometric Unlock",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onChanged: (value) {
                        localAuthentication.toggleBiometrics();
                      },
                      value: localAuthentication.biometrics,
                    ),
                  )
                : Container(),
            const Divider(
              color: Colors.white,
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(15.0, 0, 0, 0),
                  child: SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      child: const Text(
                        "Log out",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () async {
                        setState(() => loading = true);
                        UserService().signOut().then((result) {
                          setState(() => loading = false);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const AuthorizationUtility()));
                        });
                      },
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      );
    }

    drawerRight() {
      return Drawer(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: const [
                  SizedBox(height: 50),
                  Text(
                    'Notifications',
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                  SizedBox(height: 50),
                  Card(
                    child: Text(
                      'Notification',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    }

    return loading
        ? const CircularProgressIndicator(
            strokeWidth: 10,
          )
        : Scaffold(
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
              title: const Text('Contracts',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  )),
              centerTitle: true,
              elevation: 0,
              actions: [
                Builder(
                  builder: (context) {
                    return IconButton(
                      icon: const Icon(
                        Icons.notifications,
                      ),
                      onPressed: () {
                        Scaffold.of(context).openEndDrawer();
                      },
                    );
                  },
                ),
                Builder(builder: (context) {
                  return IconButton(
                    icon: const Icon(
                      Icons.add_box,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const NewContractScreen()));
                    },
                  );
                })
              ],
            ),
            body: Scrollbar(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                  child: Column(children: [
                    _contracts.isEmpty
                        ? const SizedBox(
                            height: 150,
                            child: Center(
                                child: Text('You have no contracts yet')))
                        : breakpoint > MediaQuery.of(context).size.width
                            ? mobileView()
                            : desktopView()
                  ]),
                ),
              ),
            ),
            drawer: drawerLeft(),
            endDrawer: drawerRight(),
          );
  }
}
