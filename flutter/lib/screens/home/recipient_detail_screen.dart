import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uplift/components/standard_button.dart';
import 'package:uplift/models/recipient_model.dart';

class RecipientDetailPage extends StatefulWidget {
  final Recipient recipient;
  const RecipientDetailPage({super.key, required this.recipient});

  @override
  State<RecipientDetailPage> createState() => _RecipientDetailPageState();
}

class _RecipientDetailPageState extends State<RecipientDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recipient Detail"),
      ),
      body: Column(
        children: [
          /// Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: widget.recipient.id,
                    child: Image.network(
                      widget.recipient.imageUrl,
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.recipient.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.recipient.description,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// Fixed Donate Button at the Bottom with a Background
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: const BoxDecoration(
              color: Colors.white, // Ensures text is not visible below button
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  spreadRadius: 1,
                  offset: Offset(0, -3), // Adds shadow for separation
                )
              ],
            ),
            child: StandardButton(
              title: "DONATE",
              onPressed: ()=> context.pushNamed('/donate', extra: widget.recipient),
            ),
          ),
        ],
      ),
    );
  }
}
