import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget floatingButton({
  required String label,
  Color fontColor = Colors.white,
  Gradient? gradient,
  Color bgColor = Colors.white,
  required VoidCallback onPressed,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 5),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: gradient ?? LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [bgColor, bgColor]),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent, // let gradient show
          shadowColor: Colors.transparent,     // no extra shadow
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          minimumSize: const Size(double.infinity, 48),
        ).copyWith(
          // keeps ink splash on top of the gradient
          overlayColor: MaterialStateProperty.resolveWith<Color?>(
                (states) => states.contains(MaterialState.pressed)
                ? Colors.white24
                : null,
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: fontColor,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}