import 'package:flutter/material.dart';
import 'package:frontend_v2/features/home/widgets/color_extension.dart';

class QuickStatCard extends StatelessWidget {
  final IconData icon;
  final Color iconBackground;
  final String title;
  final String value;
  final String unitLabel;
  final int target;
  final String? extraLine;
  final List<Color> colors;

  const QuickStatCard({
    Key? key,
    required this.icon,
    required this.iconBackground,
    required this.title,
    required this.value,
    required this.unitLabel,
    required this.target,
    this.extraLine,
    required this.colors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 136, // set a fixed height for all cards
      child: Card(
        color: Colors.white,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: colors.last),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconBackground,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(icon, size: 20, color: Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: colors.last.darken()),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$value $unitLabel', // add a space for readability
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: colors.last.darken(by: 0.9)),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'of $target $unitLabel',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12, color: colors.last.darken()),
                    ),
                    if (extraLine != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        extraLine!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: colors.last.darken()),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

  }
}
