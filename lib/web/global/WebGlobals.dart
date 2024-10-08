import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Webglobals {
  static Widget itxLogo() {
    return Text(
      "ITX",
      style: GoogleFonts.abel(
        fontWeight: FontWeight.bold,
        fontSize: 24,
        foreground: Paint()
          ..shader = LinearGradient(
            colors: <Color>[Colors.black, Colors.black87],
          ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
        shadows: [
          Shadow(
            offset: Offset(3.0, 3.0),
            blurRadius: 8.0,
            color: Colors.black.withOpacity(0.5),
          ),
        ],
        letterSpacing: 4.0,
      ),
    );
  }
}
