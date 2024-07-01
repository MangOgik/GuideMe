import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditItem extends StatelessWidget {
  final Widget widget;
  final String title;
  const EditItem({
    super.key,
    required this.widget,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey,
            ),
            textAlign: TextAlign.left,
          ),
        ),
        const SizedBox(width: 25),
        Expanded(
          flex: 5,
          child: widget,
        )
      ],
    );
  }
}
