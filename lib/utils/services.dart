import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud/Provider/home_provider.dart';
import 'package:crud/screens/home.dart';
import 'package:crud/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

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
        showSnackbar(context, 'The provided phone number is not valid.',
            isError: true);
      }
    },
    codeSent: (String verificationId, int? resendToken) async {
      verifyId = verificationId;
    },
    codeAutoRetrievalTimeout: (String verificationId) {},
  );
}

Future verifyOtp(String phone, BuildContext context, String otp) async {
  final provider = Provider.of<HomeProvider>(context, listen: false);
  provider.setIsLoading(true);
  FirebaseAuth _auth = FirebaseAuth.instance;

  PhoneAuthCredential credential =
      PhoneAuthProvider.credential(verificationId: verifyId, smsCode: otp);

  // Sign the user in (or link) with the credential
  await _auth.signInWithCredential(credential).then((value) {
    provider.setIsLoading(false);
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false);
  }).catchError((error) {
    provider.setIsLoading(false);
    log(error.toString());
    showSnackbar(context, error.toString(), isError: true);
  });
}

addData(BuildContext context, String title, String description, String image) {
  final provider = Provider.of<HomeProvider>(context, listen: false);
  provider.setIsLoading(true);
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference items = firestore.collection('items');

  items.add({
    'title': title,
    'description': description,
    'image': image,
    'created_at': DateTime.now().toString()
  }).then((value) {
    items.doc(value.id).update({'id': value.id});
    Navigator.of(context).pop();
    provider.setIsLoading(false);
    showSnackbar(context, "Item Added Successfully", isError: false);
  }).catchError((error) {
    log("Failed to add item: $error");
    Navigator.of(context).pop();
    provider.setIsLoading(false);
    showSnackbar(context, "Failed to add item", isError: true);
  });
}

editData(BuildContext context, String title, String description, String id,
    String image) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference items = firestore.collection('items');

  items.doc(id).update({
    'title': title,
    'description': description,
    'image': image
  }).then((value) {
    Navigator.of(context).pop();
    showSnackbar(context, "Item edited Successfully", isError: false);
  }).catchError((error) {
    log("Failed to edit item: $error");
    showSnackbar(context, "Failed to edit item", isError: true);
  });
}

deleteData(BuildContext context, String id) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference items = firestore.collection('items');

  items.doc(id).delete().then((value) {
    showSnackbar(context, "Item deleted Successfully", isError: false);
  }).catchError((error) {
    log("Failed to delete item: $error");
    showSnackbar(context, "Failed to add item", isError: true);
  });
}

Future<String> uploadImage(BuildContext context) async {
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  final imagePicker = ImagePicker();
  XFile? image;
  final provider = Provider.of<HomeProvider>(context, listen: false);
  //Check Permissions
  await Permission.photos.request();

  var permissionStatus = await Permission.photos.status;

  if (permissionStatus.isGranted) {
    //Select Image
    image = await imagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      provider.setIsLoading(true);
      var file = File(image.path);
      //Upload to Firebase
      var snapshot = await firebaseStorage
          .ref()
          .child('images/${image.path}')
          .putFile(file);
      var downloadUrl = await snapshot.ref.getDownloadURL();

      provider.setIsLoading(false);
      return downloadUrl;
    } else {
      print('No Image Path Received');
      return "";
    }
  } else {
    print('Permission not granted. Try Again with permission access');
    return "";
  }
}
