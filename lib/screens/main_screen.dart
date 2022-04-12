import 'package:badges/badges.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../services/theme_service.dart';
import '../../services/user_service.dart';
import '../models/contract_model.dart';
import '../models/notification_model.dart';
import '../models/user_model.dart';
import '../services/analytics_service.dart';
import '../services/biometric_service.dart';
import '../services/contract_service.dart';
import '../services/language_service.dart';
import '../services/notification_service.dart';
import '../utilities/authorization_utility.dart';
import 'add_commitment_screen.dart';
import 'add_contract_screen.dart';
import 'edit_commitment_screen.dart';
import 'edit_contract_screen.dart';
import 'edit_profile.dart';

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
    List contracts = Provider.of<List<ContractModel>>(context, listen: true);
    List notifications =
        Provider.of<List<NotificationModel>>(context, listen: true);
    //UserService? user = Provider.of<UserService?>(context, listen: false);
    //List users = Provider.of<List<UserService>>(context);

    contractBlock(contractIndex) {
      ContractService().checkForEmailAsParticipant(contracts[contractIndex]);
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Consumer<ThemeService>(
                    builder: (context, theme, child) => Padding(
                          padding: const EdgeInsets.fromLTRB(6, 4, 6, 4),
                          child: Container(
                            color: theme.darkTheme == true
                                ? Colors.grey[800]
                                : Colors.grey[300],
                            child: ListTile(
                              title: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(2, 10, 2, 10),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          contracts[contractIndex].title,
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Spacer(),
                                        IconButton(
                                          icon: const FaIcon(
                                              FontAwesomeIcons.ellipsis),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          EditContractScreen(
                                                    contract: contracts[
                                                        contractIndex],
                                                  ),
                                                ));
                                          },
                                        ),
                                        toggledCommitments[contractIndex] ==
                                                false
                                            ? IconButton(
                                                icon: const FaIcon(
                                                    FontAwesomeIcons
                                                        .chevronRight),
                                                onPressed: () {
                                                  setState(() {
                                                    toggleCommitments(
                                                        contractIndex);
                                                  });
                                                },
                                              )
                                            : IconButton(
                                                icon: const FaIcon(
                                                    FontAwesomeIcons
                                                        .chevronDown),
                                                onPressed: () async {
                                                  await NotificationService()
                                                      .subscribeToTopic(
                                                          contracts[
                                                                  contractIndex]
                                                              .key);
                                                  setState(() {
                                                    toggleCommitments(
                                                        contractIndex);
                                                  });
                                                },
                                              )
                                      ],
                                    ),
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
                                                      itemCount: contracts[
                                                              contractIndex]
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
                                                                children: [
                                                                  const FaIcon(
                                                                      FontAwesomeIcons
                                                                          .penToSquare,
                                                                      color: Colors
                                                                          .white),
                                                                  const SizedBox(
                                                                      width:
                                                                          10),
                                                                  Consumer<
                                                                          LanguageService>(
                                                                      builder: (context, language, _) => Text(
                                                                          language.mainScreenDismissebleEditCommitmentLink ??
                                                                              '',
                                                                          style: const TextStyle(
                                                                              color: Colors.white,
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 15))),
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
                                                                children: [
                                                                  const FaIcon(
                                                                    FontAwesomeIcons
                                                                        .trash,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                  const SizedBox(
                                                                      width:
                                                                          10),
                                                                  Consumer<
                                                                          LanguageService>(
                                                                      builder: (context, language, _) => Text(
                                                                          language.mainScreenDismissebleDeleteCommitmentLink ??
                                                                              '',
                                                                          style: const TextStyle(
                                                                              color: Colors.white,
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 15))),
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
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(10),
                                                                          color: theme.darkTheme == true
                                                                              ? Colors.grey[700]
                                                                              : Colors.grey[200],
                                                                          boxShadow: const [
                                                                            BoxShadow(
                                                                                color: Colors.transparent,
                                                                                spreadRadius: 3),
                                                                          ],
                                                                        ),
                                                                        child:
                                                                            ListTile(
                                                                          leading: Consumer<UserModel>(
                                                                              builder: (context, user, child) => CircularProfileAvatar(
                                                                                    user.avatar!,
                                                                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                                                                    placeHolder: (context, url) => const SizedBox(
                                                                                      width: 20,
                                                                                      height: 20,
                                                                                      child: CircularProgressIndicator(),
                                                                                    ),
                                                                                    radius: 20,
                                                                                    borderWidth: 2,
                                                                                    borderColor: Colors.grey,
                                                                                    elevation: 10,
                                                                                    backgroundColor: Colors.transparent,
                                                                                    imageFit: BoxFit.fill,
                                                                                    cacheImage: true,
                                                                                  )),
                                                                          title:
                                                                              Text(
                                                                            contracts[contractIndex].commitments[commitmentIndex]['commitment'],
                                                                            style:
                                                                                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                                                          ),
                                                                          subtitle:
                                                                              const Text(
                                                                            'subtitle.',
                                                                            style:
                                                                                TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
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
                                                          icon: const FaIcon(
                                                              FontAwesomeIcons
                                                                  .plus),
                                                          onPressed: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (BuildContext
                                                                          context) =>
                                                                      AddCommitmentScreen(
                                                                    contractKey:
                                                                        contracts[contractIndex]
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
                                                SizedBox(
                                                    height: 50,
                                                    child: Center(
                                                        child: Consumer<
                                                                LanguageService>(
                                                            builder: (context,
                                                                    language,
                                                                    _) =>
                                                                Text(language
                                                                        .mainScreenNoCommitmentsErrorMessage ??
                                                                    '')))),
                                                const SizedBox(height: 5),
                                                SizedBox(
                                                    child: CircleAvatar(
                                                        radius: 20,
                                                        backgroundColor:
                                                            Colors.grey[500],
                                                        child: IconButton(
                                                          icon: const FaIcon(
                                                            FontAwesomeIcons
                                                                .plus,
                                                          ),
                                                          onPressed: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (BuildContext
                                                                          context) =>
                                                                      AddCommitmentScreen(
                                                                    contractKey:
                                                                        contracts[contractIndex]
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 75),
              Consumer<UserModel>(
                  builder: (context, user, child) => SizedBox(
                        child: Center(
                          child: user.avatar != null
                              ? CircularProfileAvatar(
                                  user.avatar ?? '',
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                  placeHolder: (context, url) => const SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: CircularProgressIndicator(),
                                  ),
                                  radius: 50,
                                  borderWidth: 2,
                                  borderColor: Colors.grey,
                                  elevation: 10,
                                  backgroundColor: Colors.transparent,
                                  imageFit: BoxFit.fill,
                                  cacheImage: true,
                                )
                              : const CircleAvatar(
                                  radius: 50,
                                  child: FaIcon(FontAwesomeIcons.user,
                                      size: 60, color: Colors.grey),
                                ),
                        ),
                      )),
              Center(
                child: Consumer<UserModel>(
                  builder: (context, user, child) => Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(user.username ?? '',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 5, 0),
                  child: Row(
                    children: [
                      Consumer<LanguageService>(
                          builder: (context, language, child) => Text(
                              language.mainScreenSettingEditProfileLabel ?? '',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15))),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      Consumer<UserModel>(
                                          builder: (context, user, child) =>
                                              EditProfileScreen(
                                                currentAvatarLink: user.avatar,
                                                currentUserUid: user.uid,
                                                currentUsername: user.username,
                                                currentUserEmail: user.email,
                                              ))));
                        },
                      ),
                    ],
                  )),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: Row(
                  children: [
                    Consumer<LanguageService>(
                        builder: (context, language, child) => Text(
                            language.mainScreenSettingsLanguageLabel ?? '',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15))),
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
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
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
                  title: Consumer<LanguageService>(
                      builder: (context, language, child) => Text(
                            language.mainScreenSettingsThemeLabel ?? '',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          )),
                  onChanged: (value) {
                    theme.toggleTheme();
                  },
                  value: theme.darkTheme,
                ),
              ),
              defaultTargetPlatform == TargetPlatform.iOS ||
                      defaultTargetPlatform == TargetPlatform.android
                  ? Consumer<BiometricService>(
                      builder: (context, localAuthentication, child) =>
                          SwitchListTile(
                        title: Consumer<LanguageService>(
                            builder: (context, language, child) => Text(
                                  language.mainScreenSettingsBiometricsLabel ??
                                      '',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                )),
                        onChanged: (value) {
                          localAuthentication.toggleBiometrics();
                        },
                        value: localAuthentication.biometrics,
                      ),
                    )
                  : Container(),
              const SizedBox(height: 5),
              Consumer<AnalyticsService>(
                builder: (context, analytics, child) => SwitchListTile(
                  title: Consumer<LanguageService>(
                      builder: (context, language, child) => Text(
                            language.mainScreenSettingsAnalyticsLabel ?? '',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          )),
                  onChanged: (value) {
                    analytics.toggleAnalytics();
                  },
                  value: analytics.analytics,
                ),
              ),
              const SizedBox(height: 75),
              Padding(
                padding: const EdgeInsets.fromLTRB(15.0, 0, 0, 0),
                child: SizedBox(
                  width: 120,
                  child: ElevatedButton(
                    child: Consumer<LanguageService>(
                        builder: (context, language, child) => Text(
                              language.mainScreenSettingsLogoutButton ?? '',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )),
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
              ),
            ],
          ),
        ),
      );
    }

    drawerRight() {
      return Drawer(
          child: SingleChildScrollView(
              child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 100, 8, 8),
              child: Consumer<LanguageService>(
                  builder: (context, language, child) => Text(
                      language.mainScreenNotificationHeader ?? '',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18)))),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: notifications.isEmpty
                ? SizedBox(
                    height: 150,
                    child: Center(
                        child: Consumer<LanguageService>(
                            builder: (context, language, _) => Text(language
                                    .mainScreenNoNotificationsErrorMessage ??
                                ''))))
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: notifications.length,
                    physics: const ClampingScrollPhysics(),
                    itemBuilder: (BuildContext context, int notificationIndex) {
                      return Dismissible(
                        key: ValueKey<int>(notificationIndex),
                        background: Container(
                          color: Colors.red,
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Row(
                              children: [
                                const FaIcon(FontAwesomeIcons.envelopeOpen,
                                    color: Colors.white),
                                const SizedBox(width: 10),
                                Consumer<LanguageService>(
                                    builder: (context, language, _) => Text(
                                        language.mainScreenDismissebleMarkNotificationReadLink ??
                                            '',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15))),
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
                              children: [
                                const FaIcon(
                                  FontAwesomeIcons.envelopeOpen,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 10),
                                Consumer<LanguageService>(
                                    builder: (context, language, _) => Text(
                                        language.mainScreenDismissebleMarkNotificationReadLink ??
                                            '',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15))),
                              ],
                            ),
                          ),
                        ),
                        confirmDismiss: (direction) async {
                          if (direction == DismissDirection.startToEnd) {
                            NotificationService().markNotificationAsRead(
                                notifications[notificationIndex].key);
                            return true;
                          } else if (direction == DismissDirection.endToStart) {
                            NotificationService().markNotificationAsRead(
                                notifications[notificationIndex].key);
                            return true;
                          }
                          return null;
                        },
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: ListTile(
                              title: Text(
                                  notifications[notificationIndex].title ?? ''),
                              subtitle: Text(
                                  notifications[notificationIndex].body ?? ''),
                            ),
                          ),
                        ),
                      );
                    },
                    scrollDirection: Axis.vertical),
          )
        ],
      )));
    }

// Consumer<ThemeService>(
//                     builder: (context, theme, child) =>

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const FaIcon(
                FontAwesomeIcons.bars,
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
              return notifications.isNotEmpty
                  ? Badge(
                      badgeContent: Text(notifications.length.toString()),
                      position: BadgePosition.topEnd(top: 5, end: 5),
                      child: IconButton(
                        icon: const FaIcon(FontAwesomeIcons.bell),
                        onPressed: () {
                          Scaffold.of(context).openEndDrawer();
                        },
                      ),
                    )
                  : IconButton(
                      icon: const FaIcon(FontAwesomeIcons.bell),
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
            padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
            child: Column(children: [
              contracts.isEmpty
                  ? SizedBox(
                      height: 175,
                      child: Center(
                          child: Consumer<LanguageService>(
                              builder: (context, language, _) => Text(
                                  language.mainScreenNoContractsErrorMessage ??
                                      ''))))
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
                      const AddContractScreen()));
        },
        child: const FaIcon(
          FontAwesomeIcons.plus,
          size: 29,
        ),
        tooltip: 'New Contract',
        elevation: 5,
        splashColor: Colors.grey,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
