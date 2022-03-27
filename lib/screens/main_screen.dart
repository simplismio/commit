import 'package:commit/services/language_service.dart';
import '../services/contract_service.dart';
import '../../services/user_service.dart';
import '../../services/local_authentication_service.dart';
import '../../services/theme_service.dart';
import '../utilities/authorization_utility.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'edit_commitment_screen.dart';
import 'edit_contract_screen.dart';
import 'new_contract_screen.dart';
import 'new_commitment_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();

    for (var i = 0; i < 100; i++) {
      toggledCommitments[i] = false;
    }
  }

  bool loading = false;
  final double breakpoint = 600;
  final Map<int, bool> toggledCommitments = {};
  bool toggledCommitmentsValue = kIsWeb ? true : false;

  toggleCommitments(int _index) async {
    setState(() {
      toggledCommitmentsValue = !toggledCommitmentsValue;
      toggledCommitments[_index] = toggledCommitmentsValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    List contracts = Provider.of<List<ContractService>>(context, listen: true);

    contractBlock(contractIndex) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Consumer<ThemeService>(
                    builder: (context, theme, child) => Container(
                          color: theme.darkTheme == true
                              ? Colors.grey[800]
                              : Colors.grey[300],
                          child: ListTile(
                            // leading: CachedNetworkImage(
                            //   imageUrl: "",
                            //   placeholder: (context, url) =>
                            //       const CircularProgressIndicator(),
                            //   errorWidget: (context, url, error) =>
                            //       const Icon(Icons.error),
                            // ),
                            title: Padding(
                              padding: const EdgeInsets.fromLTRB(2, 10, 2, 10),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        contracts[contractIndex].title,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.more_horiz,
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        EditContractScreen(
                                                  contract:
                                                      contracts[contractIndex],
                                                ),
                                              ));
                                        },
                                      ),
                                      toggledCommitmentsValue == false
                                          ? IconButton(
                                              icon: const Icon(
                                                Icons.chevron_right,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  toggleCommitments(
                                                      contractIndex);
                                                });
                                              },
                                            )
                                          : IconButton(
                                              icon: const Icon(
                                                Icons.expand_more,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  toggleCommitments(
                                                      contractIndex);
                                                });
                                              },
                                            )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 5, 0, 0),
                                        child: Chip(
                                            avatar: CircleAvatar(
                                              backgroundColor:
                                                  Colors.grey.shade800,
                                              child: Text(
                                                  contracts[contractIndex]
                                                      .commitments
                                                      .length
                                                      .toString()),
                                            ),
                                            label: const Text('commitments')),
                                      ),
                                      const Spacer()
                                    ],
                                  )
                                ],
                              ),
                            ),
                            subtitle: Column(
                              children: <Widget>[
                                toggledCommitments[contractIndex] == false
                                    ? Container()
                                    : contracts[contractIndex]
                                                .commitments
                                                .asMap()
                                                .containsKey(0) ==
                                            true
                                        ? Column(
                                            children: [
                                              SizedBox(
                                                child: ListView.builder(
                                                    shrinkWrap: true,
                                                    physics:
                                                        const ClampingScrollPhysics(),
                                                    itemCount:
                                                        contracts[contractIndex]
                                                            .commitments
                                                            .length,
                                                    itemBuilder: (BuildContext
                                                            context,
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
                                                                            FontWeight.bold)),
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
                                                                            FontWeight.bold)),
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
                                                                        contracts[contractIndex]
                                                                            .key,
                                                                    commitmentArray:
                                                                        contracts[contractIndex]
                                                                            .commitments,
                                                                    commitmentIndex:
                                                                        commitmentIndex,
                                                                  ),
                                                                ));
                                                            return false;
                                                          } else if (direction ==
                                                              DismissDirection
                                                                  .endToStart) {
                                                            ContractService().deleteCommitment(
                                                                contracts[
                                                                        contractIndex]
                                                                    .key,
                                                                contracts[
                                                                        contractIndex]
                                                                    .commitments,
                                                                commitmentIndex);
                                                            if (kDebugMode) {
                                                              print(
                                                                  'Remove commitment');
                                                            }
                                                            return true;
                                                          }
                                                          return null;
                                                        },
                                                        child: Column(
                                                          children: [
                                                            Consumer<
                                                                    ThemeService>(
                                                                builder: (context,
                                                                        theme,
                                                                        child) =>
                                                                    Container(
                                                                      color: theme.darkTheme ==
                                                                              true
                                                                          ? Colors.grey[
                                                                              700]
                                                                          : Colors
                                                                              .grey[200],
                                                                      child:
                                                                          ListTile(
                                                                        // leading: CachedNetworkImage(
                                                                        //   imageUrl: "",
                                                                        //   placeholder: (context, url) =>
                                                                        //       const CircularProgressIndicator(),
                                                                        //   errorWidget: (context, url, error) =>
                                                                        //       const Icon(Icons.error),
                                                                        // ),
                                                                        title:
                                                                            Text(
                                                                          contracts[contractIndex].commitments[commitmentIndex]
                                                                              [
                                                                              'commitment'],
                                                                          style: const TextStyle(
                                                                              fontSize: 14,
                                                                              fontWeight: FontWeight.bold),
                                                                        ),
                                                                        subtitle:
                                                                            const Text(
                                                                          'subtitle.',
                                                                          style: TextStyle(
                                                                              fontSize: 13,
                                                                              fontWeight: FontWeight.bold),
                                                                        ),
                                                                      ),
                                                                    )),
                                                            const SizedBox(
                                                              height: 5,
                                                            )
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                    scrollDirection:
                                                        Axis.vertical),
                                              ),
                                              const SizedBox(height: 15),
                                              SizedBox(
                                                  child: CircleAvatar(
                                                      radius: 20,
                                                      backgroundColor:
                                                          Colors.grey[500],
                                                      child: IconButton(
                                                        icon: const Icon(
                                                          Icons.add,
                                                        ),
                                                        onPressed: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    NewCommitmentScreen(
                                                                  contractKey:
                                                                      contracts[
                                                                              contractIndex]
                                                                          .key,
                                                                ),
                                                              ));
                                                        },
                                                      ))),
                                              const SizedBox(height: 15),
                                            ],
                                          )
                                        : Column(
                                            children: [
                                              const SizedBox(
                                                  height: 50,
                                                  child: Center(
                                                      child: Text(
                                                          'You have no commitments yet. Click to add'))),
                                              const SizedBox(height: 5),
                                              SizedBox(
                                                  child: CircleAvatar(
                                                      radius: 20,
                                                      backgroundColor:
                                                          Colors.grey[500],
                                                      child: IconButton(
                                                        icon: const Icon(
                                                          Icons.add,
                                                        ),
                                                        onPressed: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    NewCommitmentScreen(
                                                                  contractKey:
                                                                      contracts[
                                                                              contractIndex]
                                                                          .key,
                                                                ),
                                                              ));
                                                        },
                                                      ))),
                                              const SizedBox(height: 15),
                                            ],
                                          ),
                              ],
                            ),
                            //subtitle:
                          ),
                        )),
              ),
            ],
          ),
        ],
      );
    }

    mobileView() {
      return SizedBox(
          height: double.maxFinite,
          width: double.maxFinite,
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: contracts.length,
              itemBuilder: (BuildContext context, int contractIndex) {
                return contractBlock(contractIndex);
              },
              scrollDirection: Axis.vertical));
    }

    desktopView() {
      return contracts.asMap().containsKey(0) == true
          ? SizedBox(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: GridView(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                    ),
                    primary: false,
                    shrinkWrap: true,
                    children: List<Widget>.generate(
                        contracts.length, // same length as the data
                        (contractIndex) => contractBlock(contractIndex))),
              ),
            )
          : Container();
    }

    drawerLeft() {
      return Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 100),

            Consumer<UserService>(
              builder: (context, user, child) => Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  alignment: Alignment.topLeft,
                  child: Text('Hi ${user.username!}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 30)),
                ),
              ),
            ),
            const SizedBox(height: 50),
            Container(
              alignment: Alignment.topLeft,
              child: const Padding(
                padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                child: Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            const Divider(),
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
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Row(
                children: [
                  const Text('Language',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const Spacer(),
                  Consumer<LanguageService>(
                      builder: (context, language, child) =>
                          DropdownButton<String>(
                            value: language.language,
                            icon: const Icon(Icons.expand_more),
                            iconSize: 24,
                            elevation: 16,
                            underline: Container(
                              height: 2,
                            ),
                            onChanged: (String? newValue) {
                              language.setLanguage(newValue);
                            },
                            items: LanguageService.languages
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          )),
                ],
              ),
            ),
            const SizedBox(height: 5),
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
            const SizedBox(height: 15),
            const Divider(),
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
              title: Consumer<LanguageService>(
                  builder: (context, language, _) =>
                      Text(language.mainScreenAppBarTitle ?? '',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ))),
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
              ],
            ),
            body: Scrollbar(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                  child: Column(children: [
                    contracts.isEmpty
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
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            const NewContractScreen()));
              },
              child: const Icon(
                Icons.add,
                size: 29,
              ),
              tooltip: 'New Contract',
              elevation: 5,
              splashColor: Colors.grey,
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
