import 'package:flutter/material.dart';
import 'package:stretchy_header/stretchy_header.dart';
import 'package:uplift/components/drawer_widget.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  /// **Make donations a state variable**
  List<Map<String, dynamic>> donations = [
    {"id": 1, "amount": 50.0, "recipient": "Aaron Watkins"},
    {"id": 2, "amount": 50.0, "recipient": "Cami Watkins"},
    {"id": 3, "amount": 50.0, "recipient": "Finley Watkins"},
    {"id": 4, "amount": 10.0, "recipient": "Barbara Watkins"},
  ];

  /// **Calculates total donation amount**
  double getTotal() {
    return donations.fold(
        0.0, (sum, donation) => sum + (donation['amount'] as double));
  }

  /// **Function to add a new donation**
  void addDonation(String recipient, double amount) {
    setState(() {
      donations.add({
        "id": donations.length + 1, // Incremental ID
        "amount": amount,
        "recipient": recipient,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double totalAmount = getTotal(); // Get total amount before UI builds

    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBar(
        title: const Text("Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              addDonation("New Recipient", 25.0); // Example new donation
            },
          )
        ],
      ),
      body: StretchyHeader.singleChild(
        headerData: HeaderData(
          headerHeight: 200,
          header: Image.network(
            "https://t4.ftcdn.net/jpg/05/05/39/07/360_F_505390776_8ilykzGiVSpIjUqdEXFhDY1ACRJZPDRD.jpg",
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            shrinkWrap: true,
            physics:
                const NeverScrollableScrollPhysics(), // Prevents double scrolling
            children: [
              /// **Total Donations Display**
              Text(
                'Total Donations: \$${totalAmount.toStringAsFixed(2)}',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              /// **Donations List**
              const Text(
                'Your Donations',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: donations.length,
                itemBuilder: (context, index) {
                  final donation = donations[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: const Icon(Icons.attach_money),
                      title: Text('Recipient: ${donation['recipient']}'),
                      subtitle: Text('Amount: \$${donation['amount']}'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
