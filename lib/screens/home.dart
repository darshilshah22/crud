import 'package:crud/utils/colors.dart';
import 'package:crud/widgets/button.dart';
import 'package:crud/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: MyColor.secondaryColor.withOpacity(0.08),
        toolbarHeight: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return buildAddItemBottomSheet();
              });
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Column(
          children: [
            buildAppBar(),
            const SizedBox(height: 20),
            ListView.builder(
              itemCount: 4,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return buildTile();
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
      decoration: BoxDecoration(
        color: MyColor.secondaryColor.withOpacity(0.08),
      ),
      child: const Text(
        "ITEMS",
        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 22),
      ),
    );
  }

  Widget buildTile() {
    return Slidable(
      key: const ValueKey(0),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(onDismissed: () {}),
        dragDismissible: false,
        children: [
          SlidableAction(
            onPressed: (BuildContext context) {},
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
            Image.asset("assets/icons/media.png", width: 80),
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Title",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Description",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(right: 24),
              decoration: const BoxDecoration(
                  color: MyColor.bgColor, shape: BoxShape.circle),
              child: const Icon(
                Icons.edit_outlined,
                color: MyColor.secondaryColor,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildAddItemBottomSheet() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 34),
      width: double.maxFinite,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Add Items",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
          ),
          Container(
            margin: const EdgeInsets.only(top: 15, bottom: 22),
            child: Image.asset("assets/icons/pick.png", height: 110),
          ),
          TextFieldWidget(controller: titleController, hint: "Title"),
          const SizedBox(height: 18),
          TextFieldWidget(controller: titleController, hint: "Description"),
          Container(
            margin: const EdgeInsets.only(top: 22, bottom: 22),
              width: double.maxFinite,
              child: ButtonWidget(title: "Save", onTap: () {}))
        ],
      ),
    );
  }
}
