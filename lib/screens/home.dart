import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud/Provider/home_provider.dart';
import 'package:crud/models/item_model.dart';
import 'package:crud/utils/colors.dart';
import 'package:crud/utils/services.dart';
import 'package:crud/widgets/button.dart';
import 'package:crud/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String imageUrl = "";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> itemsStream =
        FirebaseFirestore.instance.collection('items').snapshots();
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: MyColor.secondaryColor.withOpacity(0.08),
        toolbarHeight: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            titleController.clear();
            descriptionController.clear();
            imageUrl = "";
          });
          showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (context) {
                return buildAddItemBottomSheet(context, false, "");
              });
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Column(
          children: [
            buildAppBar(),
            const SizedBox(height: 20),
            StreamBuilder<QuerySnapshot>(
              stream: itemsStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height / 1.4,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                if (snapshot.data!.docs.isEmpty) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height / 1.4,
                    child: const Center(
                      child: Text(
                        "No Data",
                        style: TextStyle(fontSize: 20, color: Colors.grey),
                      ),
                    ),
                  );
                }
                return ListView(
                  shrinkWrap: true,
                  children: snapshot.data!.docs.map(
                    (DocumentSnapshot document) {
                      ItemModel itemModel = ItemModel.fromJson(
                          document.data()! as Map<String, dynamic>);
                      return buildTile(itemModel.title!, itemModel.description!,
                          itemModel.id ?? "", itemModel.imageUrl!);
                    },
                  ).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAppBar() {
    return Container(
      alignment: Alignment.center,
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(color: const Color(0xFFFFFBFE), boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.15),
            offset: const Offset(0, 2),
            blurRadius: 6,
            spreadRadius: 2),
        BoxShadow(
            color: Colors.black.withOpacity(0.30),
            offset: const Offset(0, 1),
            blurRadius: 2,
            spreadRadius: 0)
      ]),
      child: const Text(
        "ITEMS",
        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 22),
      ),
    );
  }

  Widget buildTile(String title, String description, String id, String image) {
    return Slidable(
      key: const ValueKey(0),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(onDismissed: () {}),
        dragDismissible: false,
        children: [
          SlidableAction(
            onPressed: (BuildContext context) {
              SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                deleteData(context, id);
              });
            },
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            borderRadius: BorderRadius.circular(12),
            label: 'Delete',
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFBFE),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.15),
                offset: const Offset(0, 2),
                blurRadius: 6,
                spreadRadius: 2)
          ],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12)),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12)),
                child: Image.network(
                  image,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                ],
              ),
            ),
            const Spacer(),
            InkWell(
              overlayColor: const MaterialStatePropertyAll(Colors.transparent),
              onTap: () {
                setState(() {
                  titleController.text = title;
                  descriptionController.text = description;
                });
                showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (context) {
                      return buildAddItemBottomSheet(context, true, id);
                    });
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(right: 24),
                decoration: const BoxDecoration(
                    color: MyColor.bgColor, shape: BoxShape.circle),
                child: const Icon(
                  Icons.edit_outlined,
                  color: MyColor.secondaryColor,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildAddItemBottomSheet(BuildContext context, bool isEdit, String id) {
    final provider = Provider.of<HomeProvider>(context, listen: true);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: MediaQuery.of(context).size.height / 1.2,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 34),
        width: double.maxFinite,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isEdit ? "Edit Item" : "Add Items",
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w700),
                      ),
                      InkWell(
                        onTap: () async {
                          imageUrl = await uploadImage(context);
                          setState(() {
                            log(imageUrl);
                          });
                        },
                        child: Container(
                          height: 110,
                          width: 110,
                          margin: const EdgeInsets.only(top: 15, bottom: 22),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(12)),
                          child: imageUrl.isNotEmpty
                              ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                    imageUrl,
                                    fit: BoxFit.cover,
                                    alignment: Alignment.topCenter,
                                  ),
                              )
                              : Image.asset("assets/icons/pick.png",
                                  height: 110),
                        ),
                      ),
                      TextFieldWidget(
                          controller: titleController,
                          hint: "Title",
                          isEnable: !provider.isLoading),
                      const SizedBox(height: 18),
                      TextFieldWidget(
                          controller: descriptionController,
                          hint: "Description",
                          isEnable: !provider.isLoading),
                      Container(
                        margin: const EdgeInsets.only(top: 40, bottom: 22),
                        width: double.maxFinite,
                        child: ButtonWidget(
                          title: "Save",
                          onTap: () {
                            if (!provider.isLoading) {
                              if (isEdit) {
                                editData(context, titleController.text,
                                    descriptionController.text, id, imageUrl);
                              } else {
                                addData(context, titleController.text,
                                    descriptionController.text, imageUrl);
                              }
                            }
                          },
                        ),
                      )
                    ],
                  ),
                  if (provider.isLoading) const CircularProgressIndicator()
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
