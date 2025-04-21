import 'package:flutter/material.dart';
import 'package:uplift/models/recipient_model.dart';

class NameAddressBlock extends StatelessWidget {
  final Recipient? recipient;
  final Map<String, dynamic>? formData;

  const NameAddressBlock({
    super.key,
    this.recipient,
    this.formData,
  }) : assert(recipient != null || formData != null, 'Either recipient or formData must be provided.');

  @override
  Widget build(BuildContext context) {


    final addressLine1 = recipient?.streetAddress1 ?? formData?['streetAddress1'] ?? '';
    final addressLine2 = recipient?.streetAddress2 ?? formData?['streetAddress2'];
    final city = recipient?.city ?? formData?['city'] ?? '';
    final state = recipient?.state ?? formData?['state'] ?? '';
    final zip = recipient?.zipCode ?? formData?['zipCode'] ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Address", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 4),
        Text(addressLine1, style: const TextStyle(fontSize: 16)),
        if (addressLine2 != null && addressLine2.toString().isNotEmpty)
          Text(addressLine2, style: const TextStyle(fontSize: 16)),
        Text("$city, $state ${zip.isNotEmpty ? zip : ''}", style: const TextStyle(fontSize: 16)),
        const Divider(thickness: 1),
      ],
    );
  }
}
