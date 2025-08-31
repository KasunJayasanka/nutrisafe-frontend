// lib/features/meal_logging/widgets/camera_card.dart

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../provider/meal_provider.dart';
import 'manual_search_card.dart';

class CameraCard extends ConsumerWidget {
  const CameraCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext c, WidgetRef ref) {
    Future<void> _pickAndProcess(ImageSource source) async {
      final picker = ImagePicker();
      final img = await picker.pickImage(
        source: source,
        maxWidth: 800,
      );
      if (img == null) return;

      // Detect a reasonable mime (jpg/png) by extension; default to jpeg
      String mime = 'image/jpeg';
      final ext = img.path.split('.').last.toLowerCase();
      if (ext == 'png') mime = 'image/png';
      if (ext == 'webp') mime = 'image/webp';
      // (If emulator returns no extension, jpeg is fine.)

      final bytes = await img.readAsBytes();
      final b64 = base64Encode(bytes);

      await ref
          .read(mealProvider)
          .recognizeFoods('data:$mime;base64,$b64');

      // Show results
      // (Your ManualSearchCard can read state from provider as it does now)
      // Use isScrollControlled for tall content
      // ignore: use_build_context_synchronously
      showModalBottomSheet(
        context: c,
        isScrollControlled: true,
        builder: (_) => const Padding(
          padding: EdgeInsets.all(16),
          child: ManualSearchCard(),
        ),
      );
    }

    void _openSourceSheet() {
      showModalBottomSheet(
        context: c,
        showDragHandle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (ctx) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined),
                title: const Text('Use Camera'),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickAndProcess(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickAndProcess(ImageSource.gallery);
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      );
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.cyan.shade50],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            const Icon(Icons.camera_alt, size: 48, color: Colors.blue),
            const SizedBox(height: 12),
            const Text(
              'Smart Food Recognition',
              style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Take a photo or choose one from the gallery to get instant nutritional analysis',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Gradient container wrapping a transparent ElevatedButton
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.indigo, Colors.indigoAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: ElevatedButton.icon(
                onPressed: _openSourceSheet,
                icon: const Icon(Icons.camera_alt, color: Colors.white),
                label: const Text('Capture or Pick', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
