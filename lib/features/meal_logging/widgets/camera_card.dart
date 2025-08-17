// lib/features/meal_logging/widgets/camera_card.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../provider/meal_provider.dart';
import 'manual_search_card.dart';

class CameraCard extends ConsumerWidget {
  const CameraCard({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext c, WidgetRef ref) {
    return Card(
      shape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.cyan.shade50],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(children: [
          Icon(Icons.camera_alt, size: 48, color: Colors.blue),
          const SizedBox(height: 12),
          const Text('Smart Food Recognition',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87)),
          const SizedBox(height: 8),
          const Text(
            'Take a photo and get instant nutritional analysis',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),

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
              icon: const Icon(Icons.camera_alt, color: Colors.white),
              label: const Text(
                'Capture Food',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent, // make button bg transparent
                shadowColor: Colors.transparent,     // remove shadow so gradient shows
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                final picker = ImagePicker();
                final img = await picker.pickImage(
                    source: ImageSource.camera, maxWidth: 800);
                if (img == null) return;
                final bytes = await img.readAsBytes();
                final b64 = base64Encode(bytes);
                await ref
                    .read(mealProvider)
                    .recognizeFoods('data:image/jpeg;base64,$b64');
                // show results in a bottom sheet
                showModalBottomSheet(
                  context: c,
                  builder: (_) => const Padding(
                    padding: EdgeInsets.all(16),
                    child: ManualSearchCard(),
                  ),
                  isScrollControlled: true,
                );
              },
            ),
          )

        ]),
      ),
    );
  }
}
