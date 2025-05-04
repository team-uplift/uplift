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
import 'package:uplift/services/badge_service.dart';
import '../../constants/constants.dart';
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
  late final BadgeService _badgeService;
  final _flutterPaypalNativePlugin = FlutterPaypalNative.instance;

  // log queue
  List<String> logQueue = [];

  @override
  void initState() {
    super.initState();
    _badgeService = BadgeService(ref);
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
        "description": "Donation to ${widget.recipient.nickname}",
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
            "recipient_name": widget.recipient.nickname,
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
            note: "Donation to ${widget.recipient.nickname}",
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
        onSuccess: (data) async {
          //successfully paid
          //remove all items from queue
          _flutterPaypalNativePlugin.removeAllPurchaseItems();

          try {
            debugPrint('Making PayPal donation request...');
            debugPrint('Full recipient data: ${widget.recipient.toString()}');

            // Get current user attributes
            final attributes = await Amplify.Auth.fetchUserAttributes();
            final attrMap = {
              for (final attr in attributes)
                attr.userAttributeKey.key: attr.value,
            };
            final cognitoId = attrMap['sub'];

            if (cognitoId == null) {
              throw Exception('Failed to get user authentication information');
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

            final amount = double.parse(_amountController.text);

            // Validate all required fields
            if (amount <= 0) {
              throw Exception('Donation amount must be greater than 0');
            }

            if (userId == null || userId <= 0) {
              throw Exception('Invalid donor ID');
            }

            if (widget.recipient.id == null || widget.recipient.id <= 0) {
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

            final response = await http.post(
              uri,
              headers: headers,
              body: jsonEncode(requestBody),
            );

            debugPrint('Response status code: ${response.statusCode}');
            debugPrint('Response headers: ${response.headers}');
            debugPrint('Raw response body: ${response.body}');

            if (response.statusCode != 200 && response.statusCode != 201) {
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
                throw Exception('Failed to create donation: $errorMessage');
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
                debugPrint('Warning: Could not parse successful response: $e');
              }
            }

            // Create local transaction
            final newTransaction = Transaction.create(
              recipient: widget.recipient,
              amount: amount,
            );

            debugPrint(
                "✅ Logging PayPal transaction: \$${newTransaction.amount} to ${newTransaction.recipient.nickname ?? 'Anonymous'}");

            ref
                .read(transactionNotifierProvider.notifier)
                .addTransaction(newTransaction);

            // Increment donation count for badges
            await _badgeService.incrementDonationCount();

            showResult("Payment successful!");
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Payment successful!"),
                backgroundColor: Colors.green,
              ),
            );
            context.goNamed('/dashboard');
          } catch (e) {
            debugPrint("❌ Error in PayPal donation process: $e");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text("Failed to process PayPal donation: ${e.toString()}"),
                backgroundColor: Colors.red,
              ),
            );
          }
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
        widget.recipient.nickname ?? widget.recipient.nickname ?? 'Anonymous';

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text(
          "Make a Donation",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: GestureDetector(
        onTap: () => _focusNode.unfocus(),
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Section
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.baseBlue,
                  // gradient: LinearGradient(
                  //   begin: Alignment.topLeft,
                  //   end: Alignment.bottomRight,
                  //   colors: [
                  //     Theme.of(context).primaryColor,
                  //     Theme.of(context).primaryColor.withOpacity(0.8),
                  //   ],
                  // ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Support Someone in Need",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "You're donating to $displayName",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),

              // Instacart Gift Card
              Container(
                padding: const EdgeInsets.all(24),
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      "https://www.instacart.com/assets/gift_cards/card-1-0b1b3484746b7043f23c5209a5119504f5b44a0ce30f46c2802c4d615d74b367.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Donation Amount",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Enter the amount you'd like to donate",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      focusNode: _focusNode,
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: InputDecoration(
                        prefixText: '\$',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.grey[300]!,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        labelText: 'Amount',
                        labelStyle: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                      onChanged: (value) {
                        final formatted = _formatAmount(value);
                        if (formatted != value) {
                          _amountController.value = TextEditingValue(
                            text: formatted,
                            selection: TextSelection.collapsed(
                                offset: formatted.length),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      "Donate with PayPal",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFF0070BA), // PayPal blue
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                4), // PayPal uses smaller border radius
                          ),
                          elevation: 0,
                        ),
                        onPressed: usePaypal2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.network(
                              'https://www.paypalobjects.com/webstatic/en_US/i/buttons/pp-acceptance-small.png',
                              height: 20,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Pay with PayPal',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
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

    // Set up the callback before making the order
    _flutterPaypalNativePlugin.setPayPalOrderCallback(
      callback: FPayPalOrderCallback(
        onSuccess: (data) async {
          //successfully paid
          //remove all items from queue
          _flutterPaypalNativePlugin.removeAllPurchaseItems();

          try {
            debugPrint('Making PayPal donation request...');
            debugPrint('Full recipient data: ${widget.recipient.toString()}');

            // Get current user attributes
            final attributes = await Amplify.Auth.fetchUserAttributes();
            final attrMap = {
              for (final attr in attributes)
                attr.userAttributeKey.key: attr.value,
            };
            final cognitoId = attrMap['sub'];

            if (cognitoId == null) {
              throw Exception('Failed to get user authentication information');
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

            final amount = double.parse(_amountController.text);

            // Validate all required fields
            if (amount <= 0) {
              throw Exception('Donation amount must be greater than 0');
            }

            if (userId == null || userId <= 0) {
              throw Exception('Invalid donor ID');
            }

            if (widget.recipient.id == null || widget.recipient.id <= 0) {
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

            final response = await http.post(
              uri,
              headers: headers,
              body: jsonEncode(requestBody),
            );

            debugPrint('Response status code: ${response.statusCode}');
            debugPrint('Response headers: ${response.headers}');
            debugPrint('Raw response body: ${response.body}');

            if (response.statusCode != 200 && response.statusCode != 201) {
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
                throw Exception('Failed to create donation: $errorMessage');
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
                debugPrint('Warning: Could not parse successful response: $e');
              }
            }

            // Create local transaction
            final newTransaction = Transaction.create(
              recipient: widget.recipient,
              amount: amount,
            );

            debugPrint(
                "✅ Logging PayPal transaction: \$${newTransaction.amount} to ${newTransaction.recipient.nickname ?? 'Anonymous'}");

            ref
                .read(transactionNotifierProvider.notifier)
                .addTransaction(newTransaction);

            // Increment donation count for badges
            await _badgeService.incrementDonationCount();

            showResult("Payment successful!");
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Payment successful!"),
                backgroundColor: Colors.green,
              ),
            );
            context.goNamed('/dashboard');
          } catch (e) {
            debugPrint("❌ Error in PayPal donation process: $e");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text("Failed to process PayPal donation: ${e.toString()}"),
                backgroundColor: Colors.red,
              ),
            );
          }
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

    // Make the order after setting up the callback
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
