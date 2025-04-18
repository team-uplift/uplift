import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:flutter_paypal_native/flutter_paypal_native.dart';
import 'package:flutter_paypal_native/models/custom/currency_code.dart';
import 'package:flutter_paypal_native/models/custom/environment.dart';
import 'package:flutter_paypal_native/models/custom/order_callback.dart';
import 'package:flutter_paypal_native/models/custom/purchase_unit.dart';
import 'package:flutter_paypal_native/models/custom/user_action.dart';
import 'package:flutter_paypal_native/str_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uplift/components/standard_button.dart';
import 'package:uplift/models/recipient_model.dart';
import 'package:uplift/models/transaction_model.dart';
import 'package:uplift/providers/transaction_notifier_provider.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

final String secretKey =
    "EKwrpcfi3uHe0lxsC_kwuKr3L5paEFn41Z49fZEwdjVFohu0x-djRhfNGqusnpP_cJ3C6rbErp_HqYc4";
final String clientID =
    "ATbWGfUDrWnJ1TI5ys3QWXuiy_y2paBxgF7FBjwSrh1Yu3JEZykq1V8mQQ2dg6r5cYtp67PQk9gqvWQ8";

class DonatePage extends ConsumerStatefulWidget {
  final Recipient recipient;
  const DonatePage({super.key, required this.recipient});

  @override
  ConsumerState<DonatePage> createState() => _DonatePageState();
}

class _DonatePageState extends ConsumerState<DonatePage> {
  final TextEditingController _amountController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  final _flutterPaypalNativePlugin = FlutterPaypalNative.instance;

  // log queue
  List<String> logQueue = [];

  @override
  void initState() {
    super.initState();

    initPayPal();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  String _formatAmount(String value) {
    // Only allow digits, remove any non-digit characters
    value = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (value.isEmpty) return '';
    return value;
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
        int.tryParse(amount) == null ||
        int.parse(amount) <= 0) {
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

  void initPayPal() async {
    //set debugMode for error logging
    FlutterPaypalNative.isDebugMode = true;

    //initiate payPal plugin
    await _flutterPaypalNativePlugin.init(
      //your app id !!! No Underscore!!! see readme.md for help
      returnUrl: "com.uplift.app://paypalpay",
      //client id from developer dashboard
      clientID: clientID,
      //sandbox, staging, live etc
      payPalEnvironment: FPayPalEnvironment.sandbox,
      //what currency do you plan to use? default is US dollars
      currencyCode: FPayPalCurrencyCode.usd,
      //action paynow?
      action: FPayPalUserAction.payNow,
    );

    //call backs for payment
    _flutterPaypalNativePlugin.setPayPalOrderCallback(
      callback: FPayPalOrderCallback(
        onCancel: () {
          //user canceled the payment
          showResult("Payment cancelled");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Payment cancelled")),
          );
        },
        onSuccess: (data) {
          //successfully paid
          //remove all items from queue
          _flutterPaypalNativePlugin.removeAllPurchaseItems();

          // Create and log the transaction
          final amount = int.parse(_amountController.text);
          final newTransaction = Transaction.create(
            recipient: widget.recipient,
            amount: amount
                .toDouble(), // Convert to double for backward compatibility
          );

          debugPrint(
              "✅ Logging PayPal transaction: \$${newTransaction.amount} to ${newTransaction.recipient.firstName}");
          ref
              .read(transactionNotifierProvider.notifier)
              .addTransaction(newTransaction);

          showResult("Payment successful!");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Payment successful!")),
          );
          context.goNamed('/dashboard');
        },
        onError: (data) {
          //an error occurred
          showResult("Payment error: ${data.reason}");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Payment error: ${data.reason}")),
          );
        },
        onShippingChange: (data) {
          //the user updated the shipping address
          showResult(
            "Shipping change: ${data.shippingChangeAddress?.adminArea1 ?? ""}",
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayName =
        widget.recipient.firstName ?? widget.recipient.nickname ?? 'Anonymous';

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
                "You are donating to $displayName",
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
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: const InputDecoration(
                  prefixText: '\$',
                  border: OutlineInputBorder(),
                  labelText: 'Amount',
                ),
                onChanged: (value) {
                  final formatted = _formatAmount(value);
                  if (formatted != value) {
                    _amountController.value = TextEditingValue(
                      text: formatted,
                      selection:
                          TextSelection.collapsed(offset: formatted.length),
                    );
                  }
                },
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
                  onPressed: () async {
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

                    if (widget.recipient.id == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Invalid recipient information"),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    double amount = double.parse(text);

                    try {
                      debugPrint('Making donation request...');
                      debugPrint(
                          'Full recipient data: ${widget.recipient.toString()}');

                      // Get current user attributes
                      final attributes =
                          await Amplify.Auth.fetchUserAttributes();
                      final attrMap = {
                        for (final attr in attributes)
                          attr.userAttributeKey.key: attr.value,
                      };
                      final cognitoId = attrMap['sub'];

                      if (cognitoId == null) {
                        throw Exception(
                            'Failed to get user authentication information');
                      }

                      // Get user info from backend
                      final userResponse = await http.get(
                        Uri.parse(
                            'http://ec2-54-162-45-38.compute-1.amazonaws.com/uplift/users/cognito/$cognitoId'),
                        headers: {
                          'Content-Type': 'application/json',
                          'Accept': 'application/json'
                        },
                      );

                      if (userResponse.statusCode != 200) {
                        throw Exception('Failed to get user information');
                      }

                      final userData = jsonDecode(userResponse.body);
                      final userId = userData['id'];
                      final donorData = userData['donorData'];

                      if (userId == null) {
                        throw Exception('Failed to get user ID');
                      }

                      // Create donation
                      final uri = Uri.parse(
                          'http://ec2-54-162-45-38.compute-1.amazonaws.com/uplift/donations');

                      final headers = {
                        'Content-Type': 'application/json',
                        'Accept': 'application/json'
                      };

                      // Validate all required fields
                      if (amount <= 0) {
                        throw Exception(
                            'Donation amount must be greater than 0');
                      }

                      if (userId == null || userId <= 0) {
                        throw Exception('Invalid donor ID');
                      }

                      if (widget.recipient.id == null ||
                          widget.recipient.id <= 0) {
                        throw Exception('Invalid recipient ID');
                      }

                      final requestBody = {
                        'amount': amount.toInt(), // Convert to integer
                        'donorId': userId,
                        'recipientId': widget.recipient.id,
                      };

                      debugPrint('Request URI: $uri');
                      debugPrint('Request headers: ${jsonEncode(headers)}');
                      debugPrint('Request body: ${jsonEncode(requestBody)}');

                      try {
                        final response = await http.post(
                          uri,
                          headers: headers,
                          body: jsonEncode(requestBody),
                        );

                        debugPrint(
                            'Response status code: ${response.statusCode}');
                        debugPrint('Response headers: ${response.headers}');
                        debugPrint('Raw response body: ${response.body}');

                        if (response.statusCode != 200 &&
                            response.statusCode != 201) {
                          if (response.body.isEmpty) {
                            throw Exception(
                                'Failed to create donation: Empty response from server (Status ${response.statusCode})');
                          }

                          try {
                            final errorData = jsonDecode(response.body);
                            final errorMessage = errorData['message'] ??
                                errorData['error'] ??
                                errorData['details'] ??
                                'Unknown error occurred';
                            throw Exception(
                                'Failed to create donation: $errorMessage');
                          } catch (e) {
                            debugPrint('Error parsing error response: $e');
                            throw Exception(
                                'Failed to create donation: Invalid error response from server (Status ${response.statusCode})');
                          }
                        }

                        // Only try to parse response if we have content
                        if (response.body.isNotEmpty) {
                          try {
                            final donationData = jsonDecode(response.body);
                            debugPrint(
                                'Donation created successfully: ${donationData['id']}');
                          } catch (e) {
                            debugPrint(
                                'Warning: Could not parse successful response: $e');
                          }
                        }

                        // Create local transaction
                        final newTransaction = Transaction.create(
                          recipient: widget.recipient,
                          amount: amount,
                        );

                        debugPrint(
                            "✅ Logging transaction: \$${newTransaction.amount} to ${newTransaction.recipient.firstName ?? 'Anonymous'}");

                        ref
                            .read(transactionNotifierProvider.notifier)
                            .addTransaction(newTransaction);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Donation successful!"),
                            backgroundColor: Colors.green,
                          ),
                        );

                        context.goNamed('/dashboard');
                      } catch (e) {
                        debugPrint("❌ Error creating donation: $e");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                "Failed to process donation: ${e.toString()}"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } catch (e) {
                      debugPrint("❌ Error in donation process: $e");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              "Failed to process donation: ${e.toString()}"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: const Text("Donate",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 10),
              StandardButton(
                title: 'DONATE WITH PAYPAL',
                onPressed: usePaypal2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void usePaypal2() {
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
    if (_flutterPaypalNativePlugin.canAddMorePurchaseUnit) {
      _flutterPaypalNativePlugin.addPurchaseUnit(
        FPayPalPurchaseUnit(
          amount: amount,
          referenceId: DateTime.now().millisecondsSinceEpoch.toString(),
        ),
      );
    }

    _flutterPaypalNativePlugin.makeOrder(
      action: FPayPalUserAction.payNow,
    );
  }

  // all to log queue
  showResult(String text) {
    logQueue.add(text);
    setState(() {});
  }
}
