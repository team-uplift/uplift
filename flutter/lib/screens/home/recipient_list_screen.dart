import 'package:flutter/material.dart';
import 'package:uplift/components/drawer_widget.dart';
import 'package:uplift/components/recipient_list_card.dart';
import 'package:uplift/models/recipient_model.dart';

class RecipientList extends StatefulWidget {
  final List<Recipient>? fetchedRecipients;

  const RecipientList({
    this.fetchedRecipients,
    super.key,
  });

  // Fallback test data in case no recipients are passed
  static final List<Recipient> testRecipients = [
    Recipient(
        id: 1,
        firstName: "Harry",
        lastName: "Potter",
        imageURL:
            "https://i.natgeofe.com/k/015ed957-e87b-403b-92a5-75372e8a28c3/a-8-harry-potter-harry.jpg?wp=1&w=1084.125&h=721.875",
        lastAboutMe:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
        streetAddress1: "123 Mockingbird Ln",
        streetAddress2: "unit 23",
        city: "Chicago",
        state: "IL",
        zipCode: "60617",
        lastReasonForHelp: "lorem ipsum",
        identityLastVerified: DateTime.now(),
        incomeLastVerified: DateTime.now(),
        nickname: "Harry",
        createdAt: DateTime.now()),
    Recipient(
        id: 2,
        firstName: "Hermoine",
        lastName: "Granger",
        imageURL:
            "https://hellogiggles.com/wp-content/uploads/sites/7/2015/08/11/Hermione-Granger-in-HP-and-the-sorcerer-s-stone-hermione-granger-13574341-960-540.jpg?quality=82&strip=1&resize=640%2C360",
        lastAboutMe:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
        streetAddress1: "123 Mockingbird Ln",
        streetAddress2: "unit 23",
        city: "Chicago",
        state: "IL",
        zipCode: "60617",
        lastReasonForHelp: "lorem ipsum",
        identityLastVerified: DateTime.now(),
        incomeLastVerified: DateTime.now(),
        nickname: "Hermoine",
        createdAt: DateTime.now()),
    Recipient(
        id: 3,
        firstName: "Ron",
        lastName: "Weasley",
        imageURL:
            "https://images.immediate.co.uk/production/volatile/sites/3/2016/05/108890.jpg?quality=90&resize=882,588",
        lastAboutMe:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
        streetAddress1: "123 Mockingbird Ln",
        streetAddress2: "unit 23",
        city: "Chicago",
        state: "IL",
        zipCode: "60617",
        lastReasonForHelp: "lorem ipsum",
        identityLastVerified: DateTime.now(),
        incomeLastVerified: DateTime.now(),
        nickname: "Ron",
        createdAt: DateTime.now()),
    Recipient(
        id: 4,
        firstName: "Draco",
        lastName: "Malfoy",
        imageURL:
            "https://cdn.mos.cms.futurecdn.net/er4HXc7zSAUfyCkQbcpauU-1200-80.jpg",
        lastAboutMe:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
        streetAddress1: "123 Mockingbird Ln",
        streetAddress2: "unit 23",
        city: "Chicago",
        state: "IL",
        zipCode: "60617",
        lastReasonForHelp: "lorem ipsum",
        identityLastVerified: DateTime.now(),
        incomeLastVerified: DateTime.now(),
        nickname: "Draco",
        createdAt: DateTime.now()),
  ];

  @override
  State<RecipientList> createState() => _RecipientListState();
}

class _RecipientListState extends State<RecipientList> {
  late List<Recipient> recipients;

  @override
  void initState() {
    super.initState();
    // Use fetched recipients if available, otherwise use test data
    recipients = widget.fetchedRecipients ?? RecipientList.testRecipients;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBar(
        title: const Text(
          "Recipients",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: recipients.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No recipients found matching your selected tags',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hero Section
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Theme.of(context).primaryColor,
                              Theme.of(context).primaryColor.withOpacity(0.8),
                            ],
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "People Who Need Your Help",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Browse through these recipients who match your selected causes",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Recipients List
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Found ${recipients.length} Recipients",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: recipients.length,
                              itemBuilder: (context, index) {
                                return RecipientListCard(
                                  recipient: recipients[index],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
