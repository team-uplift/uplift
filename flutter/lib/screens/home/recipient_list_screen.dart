import 'package:flutter/material.dart';
import 'package:uplift/components/drawer_widget.dart';
import 'package:uplift/components/recipient_list_card.dart';

class RecipientList extends StatefulWidget {
  const RecipientList({super.key});

  @override
  State<RecipientList> createState() => _RecipientListState();
}

class _RecipientListState extends State<RecipientList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBar(
        title: const Text("You Might Like to Help"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: const [
            RecipientListCard(),
            RecipientListCard(),
            RecipientListCard(),

          ],
        ),
      ),
    );
  }
}
