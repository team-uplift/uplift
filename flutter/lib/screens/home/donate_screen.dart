import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uplift/models/recipient_model.dart';

class DonatePage extends StatefulWidget {
  final Recipient recipient;
  const DonatePage({super.key, required this.recipient});

  @override
  State<DonatePage> createState() => _DonatePageState();
}

class _DonatePageState extends State<DonatePage> {
  final TextEditingController _amountController = TextEditingController();
  final FocusNode _focusNode = FocusNode(); // Focus node for input field

  @override
  void dispose() {
    _amountController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  /// Format amount input to always have two decimal places
  String _formatAmount(String value) {
    value = value.replaceAll(RegExp(r'[^0-9]'), ''); // Remove non-numeric chars
    if (value.isEmpty) return '';

    double parsed = double.parse(value) / 100; // Convert cents to dollars
    return parsed.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          true, // Allows UI to resize when keyboard appears
      appBar: AppBar(title: const Text("Donate")),
      body: GestureDetector(
        onTap: () =>
            _focusNode.unfocus(), // Dismiss keyboard when tapping outside
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Instacart Gift Card Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  "https://www.giftcards.com/content/dam/bhn/live/nam/us/en/catalog-assets/product-images/07675041083/07675041083_1006089_master.png/_jcr_content/renditions/cq5dam.web.1280.1280.jpeg",
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 24),

              /// Donation Info
              Text(
                "You are donating to ${widget.recipient.name}",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text("Please choose a donation amount"),
              const SizedBox(height: 16),

              /// Donation Amount Input
              TextField(
                focusNode: _focusNode, // Assign focus node
                controller: _amountController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) {
                  String formatted = _formatAmount(value);
                  _amountController.value = TextEditingValue(
                    text: formatted,
                    selection:
                        TextSelection.collapsed(offset: formatted.length),
                  );
                },
                decoration: InputDecoration(
                  prefixText: "\$", // Add dollar sign
                  labelText: "Enter amount",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 24),

              /// Donate Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    _focusNode.unfocus(); // Close keyboard when pressed
                    // Handle donation logic here
                  },
                  child: const Text(
                    "Donate",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
