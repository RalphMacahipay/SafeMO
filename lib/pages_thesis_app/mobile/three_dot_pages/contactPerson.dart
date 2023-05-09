import 'package:accounts/no_sql_db/encrypt_decrypt_service.dart';
import 'package:accounts/routes/route_pages.dart';
import 'package:accounts/sound_image_code/sound_images_code.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../pages_mobile/update_info_contactPerson.dart';

class ContactPersonProfile extends StatefulWidget {
  const ContactPersonProfile({super.key});

  @override
  State<ContactPersonProfile> createState() => _ContactPersonProfileState();
}

class _ContactPersonProfileState extends State<ContactPersonProfile> {
  final auth = FirebaseFirestore.instance;
  final _user = FirebaseAuth.instance;
  double boxConstraintsMaxWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  double boxConstraintsMaxHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            color: Colors.black,
            onPressed: () async {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(homePageRoute, (route) => false);
            },
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(backgroundImage),
              fit: BoxFit.cover,
            ),
          ),
          child: StreamBuilder(
              stream: auth
                  .collection("users")
                  .where("uid", isEqualTo: _user.currentUser?.uid)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.active:
                    final myName = snapshot.data?.docs.singleWhere((element) =>
                        element.id ==
                        _user.currentUser?.uid)["contactPerson.Name"];
                    final displayName =
                        EncryptAndDecryptService.decryptFernet(myName);
                    final myNum = snapshot.data?.docs.singleWhere((element) =>
                        element.id ==
                        _user.currentUser?.uid)["contactPerson.contactNumber"];
                    final displayNum =
                        EncryptAndDecryptService.decryptFernet(myNum);

                    return SafeArea(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 100),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Container(
                                constraints: BoxConstraints(
                                  maxHeight: boxConstraintsMaxWidth(context),
                                  maxWidth: boxConstraintsMaxWidth(context),
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.person_pin,
                                            size: 120,
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              setState(() {
                                                UpdateInfo.contactNamePerson =
                                                    displayName;
                                                UpdateInfo.contactNumberPerson =
                                                    displayNum;
                                              });
                                              // TODO FIXED EDIT PROFILE
                                              Navigator.of(context)
                                                  .pushNamedAndRemoveUntil(
                                                      updateInfoPageRoute,
                                                      (route) => false);
                                            },
                                            icon: const Icon(
                                              Icons.edit,
                                              size: 30,
                                            ),
                                          ),
                                        ],
                                      ),

                                      Text(
                                        "Name: $displayName",
                                        style: _styleTEXT(),
                                      ),
                                      Text(
                                        "Phone Number: $displayNum",
                                        style: _styleTEXT(),
                                      ),

                                      // backButton,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );

                  default:
                    return const Center(child: CircularProgressIndicator());
                }
              }),
        ),
      ),
    );
  }

  TextStyle _styleTEXT() {
    return const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.bold,
    );
  }
}
