import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stretchy_header/stretchy_header.dart';
import 'package:uplift/components/drawer_widget.dart';
import 'package:uplift/providers/transaction_notifier_provider.dart';
import 'package:uplift/models/transaction_model.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  String _formatDate(DateTime date) {
    try {
      return '${date.month}/${date.day}/${date.year}';
    } catch (e) {
      return 'Invalid date';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Explicitly type the transactions list
    List<Transaction> transactions = [];
    double totalDonations = 0.0;

    try {
      transactions = ref.watch(transactionNotifierProvider);
      debugPrint('Successfully loaded ${transactions.length} transactions');

      totalDonations = transactions.fold<double>(
        0.0,
        (sum, Transaction transaction) => sum + transaction.amount,
      );
    } catch (e) {
      debugPrint('Error loading transactions: $e');
    }

    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBar(
        title: const Text("Dashboard"),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Image
                  Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.grey[200],
                    child: Image.network(
                      "https://media.istockphoto.com/id/1391352876/vector/thank-you-colorful-typography-banner.jpg?s=612x612&w=0&k=20&c=jzm-E-RXHtLDQNxs_8RNe_388gbl7t7dEsYuyC0xtF8=",
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(Icons.image_not_supported, size: 50),
                        );
                      },
                    ),
                  ),

                  // Total Donations Card
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
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
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
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
                  ),

                  // Donations List Header
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Your Donations',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),

            // Donations List
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: transactions.isEmpty
                  ? SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            "No donations yet. Start by adding a new donation!",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index >= transactions.length) return null;
                          final transaction = transactions[index];

                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: const Icon(
                                Icons.attach_money,
                                color: Colors.green,
                              ),
                              title: Text(
                                'Recipient: ${transaction.recipient.firstName ?? 'Anonymous'}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Amount: \$${transaction.amount.toStringAsFixed(2)}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    'Date: ${_formatDate(transaction.date)}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              isThreeLine: true,
                            ),
                          );
                        },
                        childCount: transactions.length,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
