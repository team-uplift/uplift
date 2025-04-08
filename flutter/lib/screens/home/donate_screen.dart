import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uplift/components/standard_button.dart';
import 'package:uplift/models/recipient_model.dart';
import 'package:uplift/models/transaction_model.dart';
import 'package:uplift/providers/transaction_notifier_provider.dart';

class DonatePage extends ConsumerStatefulWidget {
  final Recipient recipient;
  const DonatePage({super.key, required this.recipient});

  @override
  ConsumerState<DonatePage> createState() => _DonatePageState();
}

class _DonatePageState extends ConsumerState<DonatePage> {
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

  void usePaypal() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => UsePaypal(
            sandboxMode: true,
            clientId:
                "AW1TdvpSGbIM5iP4HJNI5TyTmwpY9Gv9dYw8_8yW5lYIbCqf326vrkrp0ce9TAqjEGMHiV3OqJM_aRT0",
            secretKey:
                "EHHtTDjnmTZATYBPiGzZC_AZUfMpMAzj2VZUeqlFUrRJA_C0pQNCxDccB5qoRQSEdcOnnKQhycuOWdP9",
            returnURL: "https://samplesite.com/return",
            cancelURL: "https://samplesite.com/cancel",
            transactions: const [
              {
                "amount": {
                  "total": '10.12',
                  "currency": "USD",
                  "details": {
                    "subtotal": '10.12',
                    "shipping": '0',
                    "shipping_discount": 0
                  }
                },
                "description": "The payment transaction description.",
                // "payment_options": {
                //   "allowed_payment_method":
                //       "INSTANT_FUNDING_SOURCE"
                // },
                "item_list": {
                  "items": [
                    {
                      "name": "A demo product",
                      "quantity": 1,
                      "price": '10.12',
                      "currency": "USD"
                    }
                  ],

                  // shipping address is not required though
                  "shipping_address": {
                    "recipient_name": "Jane Foster",
                    "line1": "Travis County",
                    "line2": "",
                    "city": "Austin",
                    "country_code": "US",
                    "postal_code": "73301",
                    "phone": "+00000000",
                    "state": "Texas"
                  },
                }
              }
            ],
            note: "Contact us for any questions on your order.",
            onSuccess: (Map params) async {
              print("onSuccess: $params");
            },
            onError: (error) {
              print("onError: $error");
            },
            onCancel: (params) {
              print('cancelled: $params');
            }),
      ),
    );
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
                "You are donating to ${widget.recipient.firstName}",
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
                    _focusNode.unfocus();

                    if (_amountController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please enter a valid amount"),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    double amount = double.parse(_amountController.text);
                    final newTransaction = Transaction.create(
                      recipient: widget.recipient,
                      amount: amount,
                    );

                    print(
                        "✅ Adding transaction: ${newTransaction.amount} to ${newTransaction.recipient.firstName}");

                    // ✅ Add transaction
                    ref
                        .read(transactionNotifierProvider.notifier)
                        .addTransaction(newTransaction);
                    context.goNamed('/dashboard');
                  },
                  child: const Text(
                    "Donate",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 10),
              StandardButton(
                title: 'DONATE WITH PAYPAL',
                onPressed: usePaypal,
              )
            ],
          ),
        ),
      ),
    );
  }
}
