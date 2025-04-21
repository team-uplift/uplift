import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uplift/api/recipient_api.dart';
import 'package:uplift/models/donation_model.dart';
import 'package:uplift/models/recipient_model.dart';
import 'package:uplift/models/user_model.dart';
import 'recipient_history_details_screen.dart';
import 'package:uplift/api/recipient_api.dart';


// combo of chatgpt and me
class RecipientHistoryScreen extends StatefulWidget {
  final User profile;
  final Recipient recipient;
  const RecipientHistoryScreen({
    super.key, 
    required this.profile,
    required this.recipient
  });

  @override
  State<RecipientHistoryScreen> createState() => _RecipientHistoryScreenState();
}

class _RecipientHistoryScreenState extends State<RecipientHistoryScreen> {


  @override
  void initState() {
    super.initState();
    _loadDonations();
  }

  List<Donation> historyItems = [];
  bool _isLoading = true;

  Future<void> _loadDonations() async {
    // final userId = widget.profile.id;
    final donations = await RecipientApi.fetchDonationsForRecipient('${widget.profile.id}');

    setState(() {
      historyItems = donations;
      _isLoading = false;
    });
  }


  // List<Map<String, String>> historyItems = [
  //   {"title": "Donation 1", "date": "date", "details": "You received \$50"},
  //   {"title": "Donation 2", "date": "date", "details": "You received \$25", "thankYou": "I really appreciate the help!"},
  //   {"title": "Donation 3", "date": "date", "details": "You received \$10."},
  // ];

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(16),
            child: historyItems.isEmpty
              ? const Center(child: Text("No donations to view"))
              : ListView(
                  children: historyItems.map((item) => _buildHistoryCard(context, item)).toList(),
                ),
          ),
    );
  }


  Widget _buildHistoryCard(BuildContext context, Donation donation) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          title: Text("From ${donation.donorName}", style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(donation.formattedDate),
          trailing: Text(donation.formattedAmount, style: const TextStyle(fontWeight: FontWeight.bold)),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HistoryDetailScreen(item: donation, profile: widget.profile,),
              ),
            );
          },
        ),
      ),
    );
  }


}

// TODO format and clean up
// TODO Need the db tro be seeded with donations to continue with next steps. 
// i could create some demo donations but would rather ping api instead
