import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:frontend_v2/core/theme/app_colors.dart';

class AvatarPicker extends HookWidget {
  final ValueChanged<String> onPicked; // base64

  const AvatarPicker({required this.onPicked, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageBytes = useState<Uint8List?>(null);
    final picker = ImagePicker();

    Future<void> pick() async {
      final file = await picker.pickImage(source: ImageSource.gallery);
      if (file == null) return;
      final bytes = await file.readAsBytes();
      imageBytes.value = bytes;
      final b64 = base64Encode(bytes);
      onPicked('data:image/png;base64,$b64');
    }

    return Column(
      children: [
        CircleAvatar(
          radius: 48,
          backgroundColor: Colors.grey.shade100,            // ← your light grey
          backgroundImage: imageBytes.value != null
              ? MemoryImage(imageBytes.value!)
              : null,
          child: imageBytes.value == null
              ? Icon(
            Icons.person,
            size: 48,
            color: AppColors.textSecondary,        // make the icon a mid-grey
          )
              : null,
        ),

        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: pick,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.emerald100,
            foregroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 0,
          ),
          icon: const Icon(Icons.camera_alt),
          label: const Text('Upload Photo'),
        ),
      ],
    );
  }
}
