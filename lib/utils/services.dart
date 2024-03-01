import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud/models/item_model.dart';
import 'package:crud/screens/home.dart';
import 'package:crud/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

String verifyId = "";
Future sentCode(String phone, BuildContext context, String otp) async {
  FirebaseAuth _auth = FirebaseAuth.instance;

  _auth.verifyPhoneNumber(
    phoneNumber: phone,
    timeout: const Duration(seconds: 60),
    verificationCompleted: (PhoneAuthCredential credential) async {},
    verificationFailed: (FirebaseAuthException e) {
      if (e.code == 'invalid-phone-number') {
        log('The provided phone number is not valid.');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('The provided phone number is not valid.'),
          backgroundColor: Colors.red,
        ));
      }
    },
    codeSent: (String verificationId, int? resendToken) async {
      verifyId = verificationId;
    },
    codeAutoRetrievalTimeout: (String verificationId) {},
  );
}

Future verifyOtp(String phone, BuildContext context, String otp) async {
  FirebaseAuth _auth = FirebaseAuth.instance;

  PhoneAuthCredential credential =
      PhoneAuthProvider.credential(verificationId: verifyId, smsCode: otp);

  // Sign the user in (or link) with the credential
  await _auth.signInWithCredential(credential).then((value) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false);
  }).catchError((error) {
    log(error);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(error.toString()),
      backgroundColor: Colors.red,
    ));
  });
}

addData(BuildContext context, String title, String description) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference items = firestore.collection('items');

  items.add({'title': title, 'description': description}).then((value) {
    items.doc(value.id).update({'id': value.id});
    Navigator.pop(context);
    showSnackbar(context, "Item Added Successfully", isError: false);
  }).catchError((error) {
    log("Failed to add user: $error");
    showSnackbar(context, "Failed to add item", isError: true);
  });
}

editData(BuildContext context, String title, String description, String id) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference items = firestore.collection('items');

  items
      .doc(id)
      .update({'title': title, 'description': description}).then((value) {
    showSnackbar(context, "Item edited Successfully", isError: false);
  }).catchError((error) {
    log("Failed to add user: $error");
    showSnackbar(context, "Failed to add item", isError: true);
  });
}
