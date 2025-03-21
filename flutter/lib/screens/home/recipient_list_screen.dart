import 'package:flutter/material.dart';
import 'package:uplift/components/drawer_widget.dart';
import 'package:uplift/components/recipient_list_card.dart';
import 'package:uplift/models/recipient_model.dart';

class RecipientList extends StatefulWidget {
  RecipientList({super.key});

  final List<Recipient> recipients = [
    const Recipient(
      id: "1",
      name: "Harry Potter",
      age: 24,
      imageUrl:
          "https://i.natgeofe.com/k/015ed957-e87b-403b-92a5-75372e8a28c3/a-8-harry-potter-harry.jpg?wp=1&w=1084.125&h=721.875",
      description:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
    ),
    const Recipient(
      id: "2",
      name: "Hermoine Granger",
      age: 24,
      imageUrl:
          "https://hellogiggles.com/wp-content/uploads/sites/7/2015/08/11/Hermione-Granger-in-HP-and-the-sorcerer-s-stone-hermione-granger-13574341-960-540.jpg?quality=82&strip=1&resize=640%2C360",
      description:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
    ),
    const Recipient(
      id: "3",
      name: "Ron Weasley",
      age: 24,
      imageUrl:
          "https://images.immediate.co.uk/production/volatile/sites/3/2016/05/108890.jpg?quality=90&resize=882,588",
      description:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
    ),
    const Recipient(
      id: "4",
      name: "Draco Malfoy",
      age: 24,
      imageUrl:
          "https://cdn.mos.cms.futurecdn.net/er4HXc7zSAUfyCkQbcpauU-1200-80.jpg",
      description:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
    ),
  ];

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
        child: ListView.builder(
          itemCount: widget.recipients.length,
          itemBuilder: (context, index) {
            return RecipientListCard(recipient: widget.recipients[index]);
          },
        ),
      ),
    );
  }
}
