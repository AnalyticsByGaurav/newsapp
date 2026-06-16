import 'package:flutter/material.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final String? color;
  final bool isSelected;
  final VoidCallback? onTap;

  const CategoryChip({
    super.key,
    required this.label,
    this.color,
    this.isSelected = false,
    this.onTap,
  });

  Color _parseColor() {
    try {
      if (color != null) {
        final hex = color!.replaceAll('#', '');
        return Color(int.parse('FF$hex', radix: 16));
      }
    } catch (_) {}
    return const Color(0xFFE53935);
  }

  @override
  Widget build(BuildContext context) {
    final chipColor = _parseColor();
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? chipColor : chipColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: chipColor,
            width: isSelected ? 0 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'NotoSansDevanagari',
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : chipColor,
          ),
        ),
      ),
    );
  }
}
