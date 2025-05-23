/// lib/services/income_verification_service.dart
/// used to assist with opening gallery or camera and uploading photo
/// for verification
/// includes:
/// - pickImageSource
/// - verifyIncome
/// 
/// combination of tutorials, chatgpt, stackoverflow
library;

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uplift/api/recipient_api.dart';
import 'package:uplift/constants/constants.dart';

class IncomeVerificationService {
  final RecipientApi api;

  IncomeVerificationService(this.api);

  /// opens the camera and allows user to choose photo
  Future<ImageSource?> pickImageSource(BuildContext context) {
    return showModalBottomSheet<ImageSource>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Take Photo"),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Choose from Gallery"),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
  }
// coverage:ignore-start
  /// uploads phot to backend for income verification
  Future<bool> verifyIncome({
    required BuildContext context,
    required int recipientId,
  }) async {
    // fraud warning
    final proceed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.warmWhite,
        title: const Text('Heads up!'),
        content: const Text(
            'Please make sure your 1040 document is legible. Fraudulent claims may be reported.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(_, false), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.baseRed, foregroundColor: AppColors.warmWhite),
            onPressed: () => Navigator.pop(_, true), 
            child: const Text('OK')),
        ],
      ),
    ) ?? false;
    if (!proceed) return false;

    // pick image source
    final source = await pickImageSource(context);
    if (source == null) return false;

    // pick image
    final picked = await ImagePicker().pickImage(source: source);
    if (picked == null) return false;

    // upload
    final file = File(picked.path);
    return await api.uploadIncomeVerificationImage(recipientId, file);
  }
}
// coverage:ignore-end