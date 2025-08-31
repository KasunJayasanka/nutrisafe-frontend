// lib/features/home/widgets/alerts_section.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:frontend_v2/core/theme/app_colors.dart';

class AlertsSection extends StatelessWidget {
  final List<Map<String, String>> alerts;
  final double height;
  final EdgeInsetsGeometry padding;

  const AlertsSection({
    Key? key,
    required this.alerts,
    this.height = 220, // scrollable viewport height
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (alerts.isEmpty) {
      return Card(
        color: Colors.white,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: padding,
          child: const ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.shield_moon_outlined, color: Colors.green),
            title: Text(
              'Alerts & Recommendations',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            subtitle: Text(
              'All clear for today. Keep it up!',
              style: TextStyle(color: Colors.black87),
            ),
          ),
        ),
      );
    }

    return Card(
      color: Colors.white,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.security, color: AppColors.amber600),
              title: Text(
                'Alerts & Recommendations',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            const Divider(height: 1),
            const SizedBox(height: 8),

            // Scrollable list (no always-visible scrollbar)
            SizedBox(
              height: height,
              child: ListView.separated(
                padding: const EdgeInsets.only(bottom: 8),
                itemCount: alerts.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, idx) => _AlertRow(alert: alerts[idx]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AlertRow extends StatelessWidget {
  final Map<String, String> alert;
  const _AlertRow({required this.alert});

  @override
  Widget build(BuildContext context) {
    final isWarning = alert['type'] == 'warning';
    final raw = alert['message'] ?? '';

    // "<MealType>: <Food> — <warning1; warning2; ...>"
    final parts = raw.split('—');
    final title = parts.first.trim();
    final details = parts.length > 1 ? parts.sublist(1).join('—') : '';
    final bullets = details
        .split(RegExp(r';\s*'))
        .map(_clean)
        .where((s) => s.isNotEmpty)
        .toList();

    final time = _prettyTime(alert['time']);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          isWarning ? Icons.warning_amber_rounded : Icons.check_circle,
          color: isWarning ? AppColors.amber500 : AppColors.emerald500,
          size: 20,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black),
              ),
              const SizedBox(height: 4),
              ...bullets.map(
                    (b) => Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: TextStyle(color: Colors.black87)),
                    Expanded(
                      child: Text(b, style: const TextStyle(fontSize: 13, color: Colors.black87)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(time, style: const TextStyle(fontSize: 12, color: Colors.black54)),
            ],
          ),
        ),
      ],
    );
  }

  // Remove placeholders & tidy punctuation
  String _clean(String s) {
    var t = s.trim();
    t = t.replaceAll(RegExp(r'%\{?ifMISSING\}?', caseSensitive: false), '');
    t = t.replaceAll(RegExp(r'\(\s*\)'), ''); // remove empty parentheses
    t = t.replaceAll(RegExp(r'\s{2,}'), ' ').trim();
    if (t.isEmpty) return '';
    if (!t.endsWith('.')) t += '.';
    return t;
  }

  String _prettyTime(String? iso) {
    if (iso == null || iso.isEmpty) return '';
    final dt = DateTime.tryParse(iso)?.toLocal();
    if (dt == null) return iso;
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hours ago';
    return DateFormat('MMM d, h:mm a').format(dt);
  }
}
