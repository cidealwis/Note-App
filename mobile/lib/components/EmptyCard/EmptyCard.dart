import 'package:flutter/material.dart';

class EmptyCard extends StatelessWidget {
  final String imgSrc;
  final String message;

  EmptyCard({
    required this.imgSrc,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.network(
          imgSrc,
          width: 240, // Equivalent to w-60 in Tailwind
          height: 240, // Adjust as needed
          fit: BoxFit.cover,
        ),
        SizedBox(height: 40), // Equivalent to mt-20 in Tailwind
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14, // Equivalent to text-sm in Tailwind
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
              height: 1.5, // Equivalent to leading-7 in Tailwind
            ),
          ),
        ),
      ],
    );
  }
}
