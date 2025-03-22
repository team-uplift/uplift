import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stretchy_header/stretchy_header.dart';
import 'package:uplift/components/drawer_widget.dart';
import 'package:uplift/models/recipient_model.dart';
import 'package:uplift/models/transaction_model.dart';
import 'package:uplift/providers/transaction_notifier_provider.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the transactions from the provider
    final transactions = ref.watch(transactionNotifierProvider);
    print(transactions.length);
    // Calculate total donations
    double totalDonations = transactions.fold(
      0.0,
      (sum, transaction) => sum + transaction.amount,
    );

    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBar(
        title: const Text("Dashboard"),
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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Total Donations Display
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.volunteer_activism, size: 28),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total Donations',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        Text(
                          '\$${totalDonations.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Donations List Header
              const Text(
                'Your Donations',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Check if there are transactions
              transactions.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          "No donations yet. Start by adding a new donation!",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        final transaction = transactions[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: const Icon(Icons.attach_money,
                                color: Colors.green),
                            title: Text(
                              'Recipient: ${transaction.recipient.name}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Amount: \$${transaction.amount.toStringAsFixed(2)}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  'Date: ${transaction.date}',
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                            isThreeLine: true,
                          ),
                        );
                      },
                    ),
              FloatingActionButton(
                onPressed: () {
                  final testTransaction = Transaction(
                    id: DateTime.now().toString(),
                    recipient: const Recipient(
                        id: "1",
                        name: "Test User",
                        imageUrl: "",
                        description: ""),
                    amount: 25.0,
                    date: DateTime.now(),
                  );

                  ref
                      .read(transactionNotifierProvider.notifier)
                      .addTransaction(testTransaction);
                  print(
                      "🚀 Manually added transaction: ${testTransaction.amount}");
                },
                child: const Icon(Icons.add),
              )
            ],
          ),
        ),
      ),
    );
  }
}
