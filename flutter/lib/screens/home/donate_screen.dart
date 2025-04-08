import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uplift/components/standard_button.dart';
import 'package:uplift/models/recipient_model.dart';
import 'package:uplift/models/transaction_model.dart';
import 'package:uplift/providers/transaction_notifier_provider.dart';

final String secretKey = "EKwrpcfi3uHe0lxsC_kwuKr3L5paEFn41Z49fZEwdjVFohu0x-djRhfNGqusnpP_cJ3C6rbErp_HqYc4";
final String clientID = "ATbWGfUDrWnJ1TI5ys3QWXuiy_y2paBxgF7FBjwSrh1Yu3JEZykq1V8mQQ2dg6r5cYtp67PQk9gqvWQ8";

class DonatePage extends ConsumerStatefulWidget {
  final Recipient recipient;
  const DonatePage({super.key, required this.recipient});

  @override
  ConsumerState<DonatePage> createState() => _DonatePageState();
}

class _DonatePageState extends ConsumerState<DonatePage> {
  final TextEditingController _amountController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _amountController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  String _formatAmount(String value) {
    value = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (value.isEmpty) return '';
    double parsed = double.parse(value) / 100;
    return parsed.toStringAsFixed(2);
  }

  List<Map<String, dynamic>> buildTransaction(String amount) {
    debugPrint('clientID: $clientID');
    debugPrint('secretKey: $secretKey');
    return [
      {
        "amount": {
          "total": amount,
          "currency": "USD",
          "details": {
            "subtotal": amount,
            "shipping": '0',
            "shipping_discount": 0
          }
        },
        "description": "Donation to ${widget.recipient.firstName}",
        "item_list": {
          "items": [
            {
              "name": "Donation",
              "quantity": 1,
              "price": amount,
              "currency": "USD"
            }
          ],
          "shipping_address": {
            "recipient_name": widget.recipient.firstName,
            "line1": "123 Donation Lane",
            "city": "Austin",
            "country_code": "US",
            "postal_code": "73301",
            "state": "TX"
          }
        }
      }
    ];
  }

  void usePaypal() {
    final amount = _amountController.text;
    if (amount.isEmpty ||
        double.tryParse(amount) == null ||
        double.parse(amount) <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid donation amount")),
      );
      return;
    }

    try {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => UsePaypal(
            sandboxMode: true,
            clientId: clientID,
            secretKey: secretKey,
            returnURL: "https://samplesite.com/return",
            cancelURL: "https://samplesite.com/cancel",
            transactions: buildTransaction(amount),
            note: "Donation to ${widget.recipient.firstName}",
            onSuccess: (params) {
              debugPrint("✅ PayPal success: $params");
            },
            onError: (error) {
              debugPrint("❌ PayPal error: $error");
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("PayPal error occurred.")),
              );
            },
            onCancel: (params) {
              debugPrint("🚫 PayPal cancelled: $params");
            },
          ),
        ),
      );
    } catch (e) {
      debugPrint("❗ PayPal launch error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text("Donate")),
      body: GestureDetector(
        onTap: () => _focusNode.unfocus(),
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  "https://www.giftcards.com/content/dam/bhn/live/nam/us/en/catalog-assets/product-images/07675041083/07675041083_1006089_master.png/_jcr_content/renditions/cq5dam.web.1280.1280.jpeg",
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "You are donating to ${widget.recipient.firstName}",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text("Please choose a donation amount"),
              const SizedBox(height: 16),
              TextField(
                focusNode: _focusNode,
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
                  prefixText: "\$",
                  labelText: "Enter amount",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 24),
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
                    final text = _amountController.text;
                    if (text.isEmpty ||
                        double.tryParse(text) == null ||
                        double.parse(text) <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please enter a valid amount"),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    double amount = double.parse(text);
                    final newTransaction = Transaction.create(
                      recipient: widget.recipient,
                      amount: amount,
                    );

                    debugPrint(
                        "✅ Logging transaction: \$${newTransaction.amount} to ${newTransaction.recipient.firstName}");

                    ref
                        .read(transactionNotifierProvider.notifier)
                        .addTransaction(newTransaction);

                    context.goNamed('/dashboard');
                  },
                  child: const Text("Donate",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 10),
              StandardButton(
                title: 'DONATE WITH PAYPAL',
                onPressed: usePaypal,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
