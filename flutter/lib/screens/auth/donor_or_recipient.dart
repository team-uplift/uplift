import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uplift/components/standard_button.dart';
import 'package:uplift/constants/constants.dart';

class DonorOrRecipient extends StatefulWidget {
  const DonorOrRecipient({super.key});

  @override
  State<DonorOrRecipient> createState() => _DonorOrRecipientState();
}

class _DonorOrRecipientState extends State<DonorOrRecipient> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   actions: [
      //     IconButton(
      //       onPressed: () {
      //         context.goNamed('/home');
      //       }, 
      //       icon: const Icon(Icons.logout),
      //     )
      //   ],
      // ),
      backgroundColor: AppColors.baseYellow,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Register As A...",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  )
                ),
                const SizedBox(
                  height: 20,
                ),
                StandardButton(title: 'DONOR', onPressed: () => context.goNamed('/donor_registration'),),
                const SizedBox(
                  height: 10,
                ),
                StandardButton(title: 'RECIPIENT', onPressed: () => context.goNamed('/recipient_registration'),),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
