import 'package:flutter/material.dart';

class CategoryButton extends StatelessWidget {
  final String label;
  final String icon; 
  final Color backgroundColor;
  final bool isSelected;

  const CategoryButton({
    super.key,
    required this.label,
    required this.icon,
    required this.backgroundColor,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Icon Container
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: backgroundColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
            border: isSelected
                ? Border.all(color: backgroundColor, width: 2)
                : null,
            boxShadow: [
              if (isSelected)
                BoxShadow(
                  color: backgroundColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: Center(
            child: Text(
              icon,
              style: const TextStyle(fontSize: 30),
            ),
          ),
        ),
        const SizedBox(height: 5),
        // Label Text
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.black : Colors.grey[700],
          ),
        ),
      ],
    );
  }
}